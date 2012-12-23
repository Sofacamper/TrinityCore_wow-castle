/*
 * Copyright (C) 2008-2012 TrinityCore <http://www.trinitycore.org/>
 * Copyright (C) 2006-2010 ScriptDev2 <https://scriptdev2.svn.sourceforge.net/>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/* ScriptData
SDName: trial_of_the_crusader
SD%Complete: ??%
SDComment: based on /dev/rsa
SDCategory: Crusader Coliseum
EndScriptData */

// Known bugs:
//    - They should be floating but they aren't respecting the floor =(
//    - Hardcoded bullets spawner

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "GridNotifiers.h"
#include "GridNotifiersImpl.h"
#include "Cell.h"
#include "CellImpl.h"
#include "trial_of_the_crusader.h"
#include "Spell.h"

void HandleAuraOnRaidTwinValkyr(Unit* caller, uint32 spellId, bool remove, bool add, uint32 addAmount)
{
    if (spellId <= 0 || (add && addAmount <= 0) || !caller)
        return;

    Map* map = caller->GetMap();
    if (map && map->IsDungeon())
    {
        Map::PlayerList const &PlayerList = map->GetPlayers();

        if (PlayerList.isEmpty())
            return;

        for (Map::PlayerList::const_iterator i = PlayerList.begin(); i != PlayerList.end(); ++i)
        {
            if (i->getSource())
            {
                if (remove)
                    if (i->getSource()->HasAura(spellId))
                        i->getSource()->RemoveAurasDueToSpell(spellId);

                if (add)
                {
                    if (addAmount > 0)
                    {
                        if (Aura* aur = caller->AddAura(spellId, i->getSource()))
                        {
                            aur->SetStackAmount(addAmount);
                            aur->SetCharges(addAmount);
                        }
                    }
                }
            }
       }
    }
}

enum Yells
{
    SAY_AGGRO               = 0,
    SAY_NIGHT               = 1,
    SAY_LIGHT               = 2,
    EMOTE_VORTEX            = 3,
    EMOTE_TWINK_PACT        = 4,
    SAY_TWINK_PACT          = 5,
    SAY_KILL_PLAYER         = 6,
    SAY_BERSERK             = 7,
    SAY_DEATH               = 8,
};

enum Equipment
{
    EQUIP_MAIN_1         = 49303,
    EQUIP_OFFHAND_1      = 47146,
    EQUIP_RANGED_1       = 47267,
    EQUIP_MAIN_2         = 45990,
    EQUIP_OFFHAND_2      = 47470,
    EQUIP_RANGED_2       = 47267,
    EQUIP_DONE           = EQUIP_NO_CHANGE,
};

enum Summons
{
    NPC_DARK_ESSENCE     = 34567,
    NPC_LIGHT_ESSENCE    = 34568,

    NPC_UNLEASHED_DARK   = 34628,
    NPC_UNLEASHED_LIGHT  = 34630,
};

enum BossSpells
{
    SPELL_LIGHT_TWIN_SPIKE      = 66075,
    SPELL_LIGHT_SURGE           = 65766,
    SPELL_LIGHT_SHIELD_0        = 65858,
    SPELL_LIGHT_SHIELD_1        = 67259,
    SPELL_LIGHT_SHIELD_2        = 67260,
    SPELL_LIGHT_SHIELD_3        = 67261,
    SPELL_LIGHT_TWIN_PACT_0     = 65876,
    SPELL_LIGHT_TWIN_PACT_1     = 67306,
    SPELL_LIGHT_TWIN_PACT_2     = 67307,
    SPELL_LIGHT_TWIN_PACT_3     = 67308,
    SPELL_LIGHT_VORTEX          = 66046,
    SPELL_LIGHT_TOUCH_1         = 67297,
    SPELL_LIGHT_TOUCH_3         = 67298,

    SPELL_DARK_TWIN_SPIKE       = 66069,
    SPELL_DARK_SURGE            = 65768,
    SPELL_DARK_SHIELD_0         = 65874,
    SPELL_DARK_SHIELD_1         = 67256,
    SPELL_DARK_SHIELD_2         = 67257,
    SPELL_DARK_SHIELD_3         = 67258,
    SPELL_DARK_TWIN_PACT_0      = 65875,
    SPELL_DARK_TWIN_PACT_1      = 67303,
    SPELL_DARK_TWIN_PACT_2      = 67304,
    SPELL_DARK_TWIN_PACT_3      = 67305,
    SPELL_DARK_VORTEX           = 66058,
    SPELL_DARK_TOUCH_1          = 67282,
    SPELL_DARK_TOUCH_3          = 67283,

    SPELL_TWIN_POWER            = 65916,
    SPELL_LIGHT_ESSENCE         = 65686,
    SPELL_DARK_ESSENCE          = 65684,
    SPELL_BERSERK               = 64238,

    SPELL_EMPOWERED_DARK        = 67215,
    SPELL_EMPOWERED_LIGHT       = 67218,

    SPELL_UNLEASHED_DARK        = 65808,
    SPELL_UNLEASHED_LIGHT       = 65795,

    SPELL_POWER_UP              = 67604,
    SPELL_SPEED                 = 67243
};


/*######
## boss_twin_base
######*/

struct boss_twin_baseAI : public ScriptedAI
{
    boss_twin_baseAI(Creature* creature) : ScriptedAI(creature), Summons(me)
    {
        instance = creature->GetInstanceScript();
    }

    InstanceScript* instance;
    SummonList Summons;

    bool   m_bIsBerserk;
    uint8  m_uiWaveCount;
    uint32 m_uiColorballsTimer;
    uint32 m_uiSpecialAbilityTimer;
    uint32 m_uiSpikeTimer;
    uint32 m_uiTouchTimer;
    uint32 m_uiBerserkTimer;

    int32 m_uiVortexEmote;
    uint32 m_uiSisterNpcId;
    uint32 m_uiColorballNpcId;
    uint32 m_uiEssenceNpcId;
    uint32 m_uiMyEssenceSpellId;
    uint32 m_uiOtherEssenceSpellId;
    uint32 m_uiEmpoweredWeaknessSpellId;
    uint32 m_uiSurgeSpellId;
    uint32 m_uiVortexSpellId;
    uint32 m_uiShieldSpellId;
    uint32 m_uiTwinPactSpellId;
    uint32 m_uiSpikeSpellId;
    uint32 m_uiTouchSpellId;

    Position HomeLocation;
    Position EssenceLocation[2];

    void Reset()
    {
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE | UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_NOT_SELECTABLE);
        me->ApplySpellImmune(0, IMMUNITY_EFFECT, SPELL_EFFECT_KNOCK_BACK, true);
        me->ApplySpellImmune(0, IMMUNITY_EFFECT, SPELL_EFFECT_KNOCK_BACK_DEST, true);
        me->SetReactState(REACT_PASSIVE);
        /* Uncomment this once that they are flying above the ground
        me->SetLevitate(true);
        me->SetFlying(true); */
        m_bIsBerserk = false;

        m_uiWaveCount = 1;
        m_uiColorballsTimer = 15*IN_MILLISECONDS;
        m_uiSpecialAbilityTimer = MINUTE*IN_MILLISECONDS;
        m_uiSpikeTimer = 20*IN_MILLISECONDS;
        m_uiTouchTimer = urand(10, 15)*IN_MILLISECONDS;
        m_uiBerserkTimer = IsHeroic() ? 6*MINUTE*IN_MILLISECONDS : 10*MINUTE*IN_MILLISECONDS;

        HandleAuraOnRaidTwinValkyr(me, SPELL_POWER_UP, true, false, 0);
        Summons.DespawnAll();

        if (instance)
            instance->SetData(DATA_HEALTH_TWIN_SHARED, me->GetMaxHealth());
    }

    void SpellHit(Unit* caster, const SpellInfo* spell)
    {
        if (caster->ToCreature() == me)
        {
            if (spell->Id == SPELL_DARK_TWIN_PACT_0 ||
                spell->Id == SPELL_DARK_TWIN_PACT_1 ||
                spell->Id == SPELL_DARK_TWIN_PACT_2 ||
                spell->Id == SPELL_DARK_TWIN_PACT_3 ||
                spell->Id == SPELL_LIGHT_TWIN_PACT_0 ||
                spell->Id == SPELL_LIGHT_TWIN_PACT_1 ||
                spell->Id == SPELL_LIGHT_TWIN_PACT_2 ||
                spell->Id == SPELL_LIGHT_TWIN_PACT_3)
            {
                if (instance)
                {
                    uint32 setHealthVal = 0;

                    uint32 percentageAddVal = (uint32)(me->GetMaxHealth() * RAID_MODE(0.2, 0.2, 0.5, 0.5));
                    uint32 currentHealthVal = instance->GetData(DATA_HEALTH_TWIN_SHARED);

                    setHealthVal = percentageAddVal + currentHealthVal;

                    if (setHealthVal > me->GetMaxHealth())
                        setHealthVal = me->GetMaxHealth();

                    instance->SetData(DATA_HEALTH_TWIN_SHARED, setHealthVal);
                }
            }
        }
    }

    void JustReachedHome()
    {
        if (instance)
        {
            instance->SetData(TYPE_VALKIRIES, FAIL);
            instance->SetData(DATA_HEALTH_TWIN_SHARED, me->GetMaxHealth());
        }

        me->DespawnOrUnsummon();

        if (Creature* Sister = GetSister())
        {
            Sister->DespawnOrUnsummon();
        }
    }

    void MovementInform(uint32 uiType, uint32 uiId)
    {
        if (uiType != POINT_MOTION_TYPE)
            return;

        switch (uiId)
        {
            case 0:
                me->GetMotionMaster()->MovePoint(1, HomeLocation.GetPositionX(), HomeLocation.GetPositionY(), HomeLocation.GetPositionZ());
                me->SetHomePosition(HomeLocation);
                break;
            case 1:
                if (me->isAlive())
                {
                    me->SummonCreature(m_uiEssenceNpcId, EssenceLocation[0].GetPositionX(), EssenceLocation[0].GetPositionY(), EssenceLocation[0].GetPositionZ());
                    me->SummonCreature(m_uiEssenceNpcId, EssenceLocation[1].GetPositionX(), EssenceLocation[1].GetPositionY(), EssenceLocation[1].GetPositionZ());
                }

                me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE | UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_NOT_SELECTABLE);
                me->SetReactState(REACT_AGGRESSIVE);
                break;
        }
    }

    void KilledUnit(Unit* who)
    {
        if (!who)
            return;

        if (who->GetTypeId() != TYPEID_PLAYER)
            return;

        if (who->HasAura(SPELL_DARK_ESSENCE))
            who->RemoveAurasDueToSpell(SPELL_DARK_ESSENCE);

        if (who->HasAura(SPELL_LIGHT_ESSENCE))
            who->RemoveAurasDueToSpell(SPELL_LIGHT_ESSENCE);

        Talk(SAY_KILL_PLAYER);
        if (instance)
            instance->SetData(DATA_TRIBUTE_TO_IMMORTALITY_ELIGIBLE, 0);
    }

    void JustSummoned(Creature* summoned)
    {
        switch (summoned->GetEntry())
        {
            case NPC_UNLEASHED_DARK:
            case NPC_UNLEASHED_LIGHT:
                DoZoneInCombat(summoned);
                summoned->SetCorpseDelay(0);
                break;
        }

        Summons.Summon(summoned);
    }

    void SummonedCreatureDespawn(Creature* summoned)
    {
        switch (summoned->GetEntry())
        {
            case NPC_LIGHT_ESSENCE:
            case NPC_DARK_ESSENCE:
                if (Map* map = me->GetMap())
                {
                    Map::PlayerList const &lPlayers = map->GetPlayers();
                    for (Map::PlayerList::const_iterator itr = lPlayers.begin(); itr != lPlayers.end(); ++itr)
                    {
                        Unit* player = itr->getSource();
                        if (!player) continue;
                        if (player->isAlive())
                            if (summoned->GetEntry() == NPC_LIGHT_ESSENCE)
                                player->RemoveAurasDueToSpell(SPELL_LIGHT_ESSENCE);
                            if (summoned->GetEntry() == NPC_DARK_ESSENCE)
                                player->RemoveAurasDueToSpell(SPELL_DARK_ESSENCE);
                    }
                }
                break;
        }
        Summons.Despawn(summoned);
    }

    void DamageTaken(Unit* pDoneBy, uint32 &uiDamage)
    {
        if (!me || !me->isAlive() || !pDoneBy)
            return;

        if (pDoneBy->GetGUID() == me->GetGUID())
            return;

        if (pDoneBy->GetTypeId() == TYPEID_PLAYER)
        {
            if (pDoneBy->HasAura(m_uiOtherEssenceSpellId))
                uiDamage += uiDamage/2;
            else if (pDoneBy->HasAura(m_uiMyEssenceSpellId))
                uiDamage /= 2;

            if (pDoneBy->HasAura(m_uiEmpoweredWeaknessSpellId))
                uiDamage += uiDamage;
        }

        if (instance)
        {
            // Force update health values here, needed for correct further calculations
            if (instance->GetData(DATA_HEALTH_TWIN_SHARED) != 0)
                me->SetHealth(instance->GetData(DATA_HEALTH_TWIN_SHARED));
            else if (me->getVictim() && HealthBelowPct(10)) // If we come here, we usually should have low hp
            {
                me->LowerPlayerDamageReq(me->GetMaxHealth());
                me->getVictim()->Kill(me);
                return;
            }

            if (me->GetHealth() > uiDamage)
            {
                if (instance->GetData(DATA_HEALTH_TWIN_SHARED) > me->GetHealth() - uiDamage)
                {
                    instance->SetData(DATA_HEALTH_TWIN_SHARED, me->GetHealth() - uiDamage);
                }
            }
            else
            {
                me->LowerPlayerDamageReq(me->GetMaxHealth());
                instance->SetData(DATA_HEALTH_TWIN_SHARED, 0);
            }
        }
    }

    void SummonColorballs(uint8 quantity)
    {
        float x0 = ToCCommonLoc[1].GetPositionX(), y0 = ToCCommonLoc[1].GetPositionY(), r = 47.0f;
        float y = y0;
        for (uint8 i = 0; i < quantity; i++)
        {
            float x = float(urand(uint32(x0 - r), uint32(x0 + r)));
            if (urand(0, 1))
                y = y0 + sqrt(pow(r, 2) - pow((x-x0), 2));
            else
                y = y0 - sqrt(pow(r, 2) - pow((x-x0), 2));
            me->SummonCreature(m_uiColorballNpcId, x, y, me->GetPositionZ(), TEMPSUMMON_CORPSE_DESPAWN);
        }
    }

    void JustDied(Unit* /*killer*/)
    {
        Talk(SAY_DEATH);

        HandleAuraOnRaidTwinValkyr(me, SPELL_POWER_UP, true, false, 0);
        HandleAuraOnRaidTwinValkyr(me, SPELL_LIGHT_ESSENCE, true, false, 0);
        HandleAuraOnRaidTwinValkyr(me, SPELL_DARK_ESSENCE, true, false, 0);

        if (instance)
        {
            instance->SetData(DATA_HEALTH_TWIN_SHARED, 0);

            if (Creature* pSister = GetSister())
            {
                if (!pSister->isAlive())
                {
                    instance->SetData(TYPE_VALKIRIES, DONE);
                }
                else
                    instance->SetData(TYPE_VALKIRIES, SPECIAL);
            }
            else
                instance->SetData(TYPE_VALKIRIES, DONE); // In case we cannot find sister, set done by default
        }

        Summons.DespawnAll();
    }

    // Called when sister pointer needed
    Creature* GetSister()
    {
        if (instance)
            return Unit::GetCreature((*me), instance->GetData64(m_uiSisterNpcId));
        else
            return NULL;
    }

    void EnterCombat(Unit* /*who*/)
    {
        if (instance)
        {
            instance->SetData(TYPE_VALKIRIES, IN_PROGRESS);
            instance->SetData(DATA_HEALTH_TWIN_SHARED, me->GetMaxHealth());
        }

        DoZoneInCombat();

        if (Creature* Sister = GetSister())
        {
            DoZoneInCombat(Sister);
        }

        Talk(SAY_AGGRO);
        DoCast(me, m_uiSurgeSpellId);
    }

    void UpdateAI(const uint32 uiDiff)
    {
        if (!instance || !UpdateVictim())
            return;

        if (instance->GetData(DATA_HEALTH_TWIN_SHARED) != 0)
            me->SetHealth(instance->GetData(DATA_HEALTH_TWIN_SHARED));
        else if (me->getVictim())
        {
            me->LowerPlayerDamageReq(me->GetMaxHealth());
            me->getVictim()->Kill(me);
            return;
        }
        else
            me->SetHealth(1);

        if (m_uiSpecialAbilityTimer <= uiDiff)
        {
            me->InterruptNonMeleeSpells(false);

            if (urand(0, 1))
            {
                Talk(m_uiVortexEmote);
                DoCastAOE(m_uiVortexSpellId);

                std::list<Unit*> targetList;

                SelectTargetList(targetList, 100, SELECT_TARGET_NEAREST, 150.0f, true, m_uiMyEssenceSpellId);
                if (!targetList.empty())
                {
                    for (std::list<Unit* >::const_iterator itr = targetList.begin(); itr != targetList.end(); ++itr)
                    {
                        Unit* unit = (*itr);
                        if (unit && unit->isAlive())
                        {
                            if (!unit->HasAura(SPELL_POWER_UP))
                                unit->AddAura(SPELL_POWER_UP, unit);

                            if (Aura* aur = unit->GetAura(SPELL_POWER_UP))
                            {
                                if (aur->GetStackAmount() + 30 > 100)
                                {
                                    unit->RemoveAurasDueToSpell(SPELL_POWER_UP);
                                    unit->CastSpell(unit, me->GetEntry() == NPC_LIGHTBANE ? SPELL_EMPOWERED_LIGHT : SPELL_EMPOWERED_DARK, true);
                                }
                                else
                                {
                                    if (urand(0, 100) <= 15)
                                        unit->CastSpell(unit, SPELL_SPEED, true);

                                    aur->SetStackAmount(aur->GetStackAmount() + 30);
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                Talk(EMOTE_TWINK_PACT);
                Talk(SAY_TWINK_PACT);

                if (Creature* Sister = GetSister())
                    Sister->CastSpell(Sister, SPELL_TWIN_POWER, true);

                DoCast(me, m_uiShieldSpellId);
                me->CastCustomSpell(me, m_uiTwinPactSpellId, 0, 0, 0, false);
            }

            m_uiSpecialAbilityTimer = 80000;

        } else m_uiSpecialAbilityTimer -= uiDiff;

        if (m_uiSpikeTimer <= uiDiff)
        {
            DoCastVictim(m_uiSpikeSpellId);
            m_uiSpikeTimer = 20*1000;
        } else m_uiSpikeTimer -= uiDiff;

        if (IsHeroic())
        {
            if (m_uiTouchTimer <= uiDiff)
            {
                if (Unit* target = SelectTarget(SELECT_TARGET_RANDOM, 0, 200.0f, true, m_uiOtherEssenceSpellId))
                {
                    if (!target->HasAura(m_uiTouchSpellId))
                    {
                        target->AddAura(m_uiTouchSpellId, target);
                    }
                }
                m_uiTouchTimer = urand(10, 15)*1000;
            } else m_uiTouchTimer -= uiDiff;
        }

        if (m_uiColorballsTimer <= uiDiff)
        {
            if (m_uiWaveCount >= 2)
            {
                SummonColorballs(15);
                m_uiWaveCount = 0;
            } 
            else
            {
                SummonColorballs(2);
                m_uiWaveCount++;
            }
            m_uiColorballsTimer = 15*1000;
        } else m_uiColorballsTimer -= uiDiff;

        if (m_uiBerserkTimer <= uiDiff)
        {
            if (!m_bIsBerserk)
            {
                DoCast(me, SPELL_BERSERK);
                Talk(SAY_BERSERK);
                m_bIsBerserk = true;
            }
        } else m_uiBerserkTimer -= uiDiff;

        DoMeleeAttackIfReady();
    }
};

/*######
## boss_fjola
######*/

class boss_fjola : public CreatureScript
{
public:
    boss_fjola() : CreatureScript("boss_fjola") { }

    CreatureAI* GetAI(Creature* creature) const
    {
        return new boss_fjolaAI(creature);
    }

    struct boss_fjolaAI : public boss_twin_baseAI
    {
        boss_fjolaAI(Creature* creature) : boss_twin_baseAI(creature)
        {
            instance = creature->GetInstanceScript();
        }

        InstanceScript* instance;

        void Reset() {
            boss_twin_baseAI::Reset();
            SetEquipmentSlots(false, EQUIP_MAIN_1, EQUIP_OFFHAND_1, EQUIP_RANGED_1);
            m_uiSpecialAbilityTimer = 40000;
            m_uiVortexEmote = EMOTE_VORTEX;
            m_uiSisterNpcId = NPC_DARKBANE;
            m_uiColorballNpcId = NPC_UNLEASHED_LIGHT;
            m_uiEssenceNpcId = NPC_LIGHT_ESSENCE;
            m_uiMyEssenceSpellId = SPELL_LIGHT_ESSENCE;
            m_uiOtherEssenceSpellId = SPELL_DARK_ESSENCE;
            m_uiEmpoweredWeaknessSpellId = SPELL_EMPOWERED_DARK;
            m_uiSurgeSpellId = SPELL_LIGHT_SURGE;
            m_uiVortexSpellId = SPELL_LIGHT_VORTEX;
            m_uiShieldSpellId = SPELL_LIGHT_SHIELD_0;
            m_uiTwinPactSpellId = SPELL_LIGHT_TWIN_PACT_0;
    
            if (GetDifficulty() == RAID_DIFFICULTY_10MAN_HEROIC)
            {
                m_uiTouchSpellId = SPELL_LIGHT_TOUCH_1;
            }
            else if (GetDifficulty() == RAID_DIFFICULTY_25MAN_HEROIC)
            {
                m_uiTouchSpellId = SPELL_LIGHT_TOUCH_3;
            }
            else
            {
                m_uiTouchSpellId = 0;
            }

            m_uiSpikeSpellId = SPELL_LIGHT_TWIN_SPIKE;

            HomeLocation = ToCCommonLoc[8];
            EssenceLocation[0] = TwinValkyrsLoc[2];
            EssenceLocation[1] = TwinValkyrsLoc[3];

            if (instance)
            {
                instance->DoStopTimedAchievement(ACHIEVEMENT_TIMED_TYPE_EVENT,  EVENT_START_TWINS_FIGHT);
            }
        }

        void EnterCombat(Unit* who)
        {
            boss_twin_baseAI::EnterCombat(who);
            if (instance)
            {
                instance->DoStartTimedAchievement(ACHIEVEMENT_TIMED_TYPE_EVENT,  EVENT_START_TWINS_FIGHT);
            }
        }
    };

};

/*######
## boss_eydis
######*/

class boss_eydis : public CreatureScript
{
public:
    boss_eydis() : CreatureScript("boss_eydis") { }

    CreatureAI* GetAI(Creature* creature) const
    {
        return new boss_eydisAI(creature);
    }

    struct boss_eydisAI : public boss_twin_baseAI
    {
        boss_eydisAI(Creature* creature) : boss_twin_baseAI(creature) {}

        void Reset() {
            boss_twin_baseAI::Reset();
            SetEquipmentSlots(false, EQUIP_MAIN_2, EQUIP_OFFHAND_2, EQUIP_RANGED_2);
            m_uiSpecialAbilityTimer = 80000;
            m_uiVortexEmote = EMOTE_VORTEX;
            m_uiSisterNpcId = NPC_LIGHTBANE;
            m_uiColorballNpcId = NPC_UNLEASHED_DARK;
            m_uiEssenceNpcId = NPC_DARK_ESSENCE;
            m_uiMyEssenceSpellId = SPELL_DARK_ESSENCE;
            m_uiOtherEssenceSpellId = SPELL_LIGHT_ESSENCE;
            m_uiEmpoweredWeaknessSpellId = SPELL_EMPOWERED_LIGHT;
            m_uiSurgeSpellId = SPELL_DARK_SURGE;
            m_uiVortexSpellId = SPELL_DARK_VORTEX;
            m_uiShieldSpellId = SPELL_DARK_SHIELD_0;
            m_uiTwinPactSpellId = SPELL_DARK_TWIN_PACT_0;
    
            if (GetDifficulty() == RAID_DIFFICULTY_10MAN_HEROIC)
            {
                m_uiTouchSpellId = SPELL_DARK_TOUCH_1;
            }
            else if (GetDifficulty() == RAID_DIFFICULTY_25MAN_HEROIC)
            {
                m_uiTouchSpellId = SPELL_DARK_TOUCH_3;
            }
            else
            {
                m_uiTouchSpellId = 0;
            }

            m_uiSpikeSpellId = SPELL_DARK_TWIN_SPIKE;

            HomeLocation = ToCCommonLoc[9];
            EssenceLocation[0] = TwinValkyrsLoc[0];
            EssenceLocation[1] = TwinValkyrsLoc[1];
        }
    };

};


class mob_essence_of_twin : public CreatureScript
{
public:
    mob_essence_of_twin() : CreatureScript("mob_essence_of_twin") { }

    bool OnGossipHello(Player* player, Creature* creature)
    {
        switch (creature->GetEntry())
        {
            case NPC_LIGHT_ESSENCE:
                if (player && player->HasAura(SPELL_DARK_ESSENCE))
                    player->RemoveAurasDueToSpell(SPELL_DARK_ESSENCE);
    
                player->AddAura(SPELL_LIGHT_ESSENCE, player);
                break;
            case NPC_DARK_ESSENCE:
                if (player && player->HasAura(SPELL_LIGHT_ESSENCE))
                    player->RemoveAurasDueToSpell(SPELL_LIGHT_ESSENCE);
    
                player->AddAura(SPELL_DARK_ESSENCE, player);
                break;
        }
        player->CLOSE_GOSSIP_MENU();
        return true;
    }
};

struct mob_unleashed_ballAI : public ScriptedAI
{
    mob_unleashed_ballAI(Creature* creature) : ScriptedAI(creature)
    {
        instance = creature->GetInstanceScript();
    }

    InstanceScript* instance;
    uint32 m_uiRangeCheckTimer;

    void KilledUnit(Unit* who)
    {
        if (!who)
            return;

        if (who->GetTypeId() != TYPEID_PLAYER)
            return;

        if (who->HasAura(SPELL_DARK_ESSENCE))
            who->RemoveAurasDueToSpell(SPELL_DARK_ESSENCE);

        if (who->HasAura(SPELL_LIGHT_ESSENCE))
            who->RemoveAurasDueToSpell(SPELL_LIGHT_ESSENCE);
    }

    void MoveToNextPoint()
    {
        float x0 = ToCCommonLoc[1].GetPositionX(), y0 = ToCCommonLoc[1].GetPositionY(), r = 47.0f;
        float y = y0;
        float x = frand(x0 - r, x0 + r);
        float sq = pow(r, 2) - pow(x - x0, 2);
        float rt = sqrtf(fabs(sq));
        if (urand(0, 1))
            y = y0 + rt;
        else
            y = y0 - rt;
        me->GetMotionMaster()->MovePoint(0, x, y, me->GetPositionZ());
    }

    void Reset()
    {
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE | UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_NOT_SELECTABLE);
        me->SetReactState(REACT_PASSIVE);
        me->SetDisableGravity(true);
        me->SetCanFly(true);
        SetCombatMovement(false);
        MoveToNextPoint();
        m_uiRangeCheckTimer = 500;
    }

    void MovementInform(uint32 uiType, uint32 uiId)
    {
        if (uiType != POINT_MOTION_TYPE)
            return;

        switch (uiId)
        {
            case 0:
                if (urand(0, 3) == 0)
                    MoveToNextPoint();
                else
                    me->DespawnOrUnsummon();
                break;
        }
    }
};

class mob_unleashed_dark : public CreatureScript
{
public:
    mob_unleashed_dark() : CreatureScript("mob_unleashed_dark") { }

    CreatureAI* GetAI(Creature* creature) const
    {
        return new mob_unleashed_darkAI(creature);
    }

    struct mob_unleashed_darkAI : public mob_unleashed_ballAI
    {
        mob_unleashed_darkAI(Creature* creature) : mob_unleashed_ballAI(creature) {}

        void UpdateAI(const uint32 uiDiff)
        {
            if (m_uiRangeCheckTimer < uiDiff)
            {
                if (Unit* target = me->SelectNearestTarget(3.0f))
                {
                    if (target->GetTypeId() == TYPEID_PLAYER && target->isAlive())
                    {
                        if (target->HasAura(SPELL_LIGHT_ESSENCE))
                        {
                            DoCastAOE(SPELL_UNLEASHED_DARK);
                            me->GetMotionMaster()->MoveIdle();
                            me->DespawnOrUnsummon();
                        }
                        else if (target->HasAura(SPELL_DARK_ESSENCE))
                        {
                            std::list<Unit*> targetList;
    
                            SelectTargetList(targetList, 100, SELECT_TARGET_NEAREST, 6.0f, true, SPELL_DARK_ESSENCE);
                            if (!targetList.empty())
                            {
                                for (std::list<Unit* >::const_iterator itr = targetList.begin(); itr != targetList.end(); ++itr)
                                {
                                    Unit* unit = (*itr);
                                    if (unit && unit->isAlive())
                                    {
                                        if (!unit->HasAura(SPELL_POWER_UP))
                                            unit->AddAura(SPELL_POWER_UP, unit);
    
                                        if (Aura* aur = unit->GetAura(SPELL_POWER_UP))
                                        {
                                            if (aur->GetStackAmount() + 6 > 100)
                                            {
                                                unit->RemoveAurasDueToSpell(SPELL_POWER_UP);
                                                unit->CastSpell(unit, SPELL_EMPOWERED_DARK, true);
                                            }
                                            else
                                            {
                                                if (urand(0, 100) <= 15)
                                                    unit->CastSpell(unit, SPELL_SPEED, true);
    
                                                aur->SetStackAmount(aur->GetStackAmount() + 6);
                                            }
                                        }
                                    }
                                }
                            }
    
                            me->GetMotionMaster()->MoveIdle();
                            me->DespawnOrUnsummon();
                        }
                    }
                }
                m_uiRangeCheckTimer = 500;
            }
            else m_uiRangeCheckTimer -= uiDiff;
        }
    };
};

class mob_unleashed_light : public CreatureScript
{
public:
    mob_unleashed_light() : CreatureScript("mob_unleashed_light") { }

    CreatureAI* GetAI(Creature* creature) const
    {
        return new mob_unleashed_lightAI(creature);
    }

    struct mob_unleashed_lightAI : public mob_unleashed_ballAI
    {
        mob_unleashed_lightAI(Creature* creature) : mob_unleashed_ballAI(creature) {}

        void UpdateAI(const uint32 uiDiff)
        {
            if (m_uiRangeCheckTimer < uiDiff)
            {
                if (Unit* target = me->SelectNearestTarget(3.0f))
                {
                    if (target->GetTypeId() == TYPEID_PLAYER && target->isAlive())
                    {
                        if (target->HasAura(SPELL_DARK_ESSENCE))
                        {
                            DoCastAOE(SPELL_UNLEASHED_LIGHT);
                            me->GetMotionMaster()->MoveIdle();
                            me->DespawnOrUnsummon();
                        }
                        else if (target->HasAura(SPELL_LIGHT_ESSENCE))
                        {
                            std::list<Unit*> targetList;
    
                            SelectTargetList(targetList, 100, SELECT_TARGET_NEAREST, 6.0f, true, SPELL_LIGHT_ESSENCE);
                            if (!targetList.empty())
                            {
                                for (std::list<Unit* >::const_iterator itr = targetList.begin(); itr != targetList.end(); ++itr)
                                {
                                    Unit* unit = (*itr);
                                    if (unit && unit->isAlive())
                                    {
                                        if (!unit->HasAura(SPELL_POWER_UP))
                                            unit->AddAura(SPELL_POWER_UP, unit);
    
                                        if (Aura* aur = unit->GetAura(SPELL_POWER_UP))
                                        {
                                            if (aur->GetStackAmount() + 6 > 100)
                                            {
                                                unit->RemoveAurasDueToSpell(SPELL_POWER_UP);
                                                unit->CastSpell(unit, SPELL_EMPOWERED_LIGHT, true);
                                            }
                                            else
                                            {
                                                if (urand(0, 100) <= 15)
                                                    unit->CastSpell(unit, SPELL_SPEED, true);
    
                                                aur->SetStackAmount(aur->GetStackAmount() + 6);
                                            }
                                        }
                                    }
                                }
                            }
    
                            me->GetMotionMaster()->MoveIdle();
                            me->DespawnOrUnsummon();
                        }
                    }
                }
                m_uiRangeCheckTimer = 500;
            }
            else m_uiRangeCheckTimer -= uiDiff;
        }
    };

};

void AddSC_boss_twin_valkyr()
{
    new boss_fjola();
    new boss_eydis();
    new mob_unleashed_light();
    new mob_unleashed_dark();
    new mob_essence_of_twin();
}
