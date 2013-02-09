-- ======== OLD FIXES ========

-- Fix visual bug for race dependent vehicle items of Argent Tournament, by Leona
DELETE FROM `vehicle_template_accessory` WHERE `entry` in (33414, 33298, 33416, 33408, 33301, 33418, 33409, 33300, 33299, 33297, 33297);

-- Fix quest 9759 Ihre Welt enden lassen / Ending Their World, remove escort requirement
UPDATE `quest_template` SET `SpecialFlags` = 0 WHERE `Id` = 9759;

-- Fix Item bug for Item 35348 - change loot chance for pets to 10, by Leona
UPDATE `item_loot_template` SET `ChanceOrQuestChance` = 10 WHERE `entry` = 35348 AND `item` = 11116;

-- Fix questrelations 13036, 13226, 13227 Der Tag der Abrechnung kommt! / Judgment Day Comes! comes before Honor Above All Else / Ehre über alles
DELETE FROM `conditions` WHERE `SourceEntry` = 13227 AND `SourceTypeOrReferenceId` = 20;
UPDATE `quest_template` SET `NextQuestId` = 13036, `NextQuestIdChain` = 13036, `ExclusiveGroup` = 13226 WHERE `Id` IN (13226, 13227);

-- Fix Spirit Healer graveyard link for Alliance in Undercity
DELETE FROM `game_graveyard_zone` WHERE `ghost_zone` = 1497 AND `faction` = 469;
INSERT INTO `game_graveyard_zone` (id, ghost_zone, faction) VALUES
(1409, 1497, 469);

-- Fix item 42203 Dunkle Plattenrüstung / Dark Armor Plate dropping after quest 12978 has been completed
DELETE FROM `conditions` WHERE `SourceEntry` = 42203;
INSERT INTO `conditions` (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, NegativeCondition, ErrorTextId, ScriptName, Comment) VALUES
(10, 44005, 42203, 0, 0, 9, 0, 12978, 0, 0, 0, 0, '', ''),
(10, 44005, 42203, 0, 1, 8, 0, 12978, 0, 0, 0, 0, '', '');

-- Fix NPC 30285 Eye of Taldaram / Auge von Taldaram using wrong scaling spell (way too much dmg) 17439 / 17289 Schattenschock / Shadow Shock
DELETE FROM `creature_ai_scripts` WHERE `creature_id` = 30285;
INSERT INTO `creature_ai_scripts` (id, creature_id, event_type, event_inverse_phase_mask, event_chance, event_flags, event_param1, event_param2, event_param3, event_param4, action1_type, action1_param1, action1_param2, action1_param3, action2_type, action2_param1, action2_param2, action2_param3, action3_type, action3_param1, action3_param2, action3_param3, comment) VALUES
(3028501, 30285, 0, 0, 100, 3, 1000, 3000, 6000, 8000, 11, 56730, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Eye of Taldaram (Normal)- Dark Counterspell '),
(3028502, 30285, 0, 0, 100, 5, 1000, 3000, 6000, 8000, 11, 59111, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Eye of Taldaram (Heroic)- Dark Counterspell '),
(3028503, 30285, 6, 0, 100, 2, 0, 0, 0, 0, 11, 56733, 1, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Eye of Taldaram (Normal) - Cast Shadow Fury on Death'),
(3028504, 30285, 6, 0, 100, 4, 0, 0, 0, 0, 11, 61463, 1, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Eye of Taldaram (Heroic) - Cast Shadow Fury on Death');

-- Fix quest 1221 Blueleaf Tubers / Blaulaubknollen, just available for Horde
UPDATE `quest_template` SET `RequiredRaces` = 690 WHERE `Id` = 1221; 

-- Fix quests 13404 / 13406 (Statische Schocktruppen: das Bombardement / Static Shock Troops: the Bombardment)
-- by giving killcredits from similar NPCs, by Salonia
UPDATE `creature_template` SET `KillCredit1`= 32410 WHERE `entry` = 32771;
UPDATE `creature_template` SET `KillCredit2`= 32188 WHERE `entry` = 32769;

-- Fix dropchance for item 30689 Razuun's Orders / Razuuns Befehle for
-- quest 10586 / 10603 Bring Down the Warbringer! / Nieder mit dem Kriegshetzer! - increase it from -60 to -100.
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -100 WHERE `entry` = 21287 AND `item` = 30689;

-- Disable Explosive Trap in Dalaran - Bug, could attack hostile faction players
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 17 AND `SourceEntry` IN (13813,14316,14317,27025,49066,49067);
INSERT INTO `conditions` (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, NegativeCondition, ErrorTextId, ScriptName, Comment) VALUES
(17, 0, 13813, 0, 0, 4, 0, 4395, 0, 0, 1, 0, '', 'Disable Explosive Trap in Dalaran - Bug'),
(17, 0, 14316, 0, 0, 4, 0, 4395, 0, 0, 1, 0, '', 'Disable Explosive Trap in Dalaran - Bug'),
(17, 0, 14317, 0, 0, 4, 0, 4395, 0, 0, 1, 0, '', 'Disable Explosive Trap in Dalaran - Bug'),
(17, 0, 27025, 0, 0, 4, 0, 4395, 0, 0, 1, 0, '', 'Disable Explosive Trap in Dalaran - Bug'),
(17, 0, 49066, 0, 0, 4, 0, 4395, 0, 0, 1, 0, '', 'Disable Explosive Trap in Dalaran - Bug'),
(17, 0, 49067, 0, 0, 4, 0, 4395, 0, 0, 1, 0, '', 'Disable Explosive Trap in Dalaran - Bug');

-- Fix quest 11202 Mission 'Ewige Flamme' / Mission: Eternal Flame, set needed spell target information
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 42564;
INSERT INTO `conditions` (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, NegativeCondition, ErrorTextId, ScriptName, Comment) VALUES
(13, 1, 42564, 0, 0, 31, 0, 3, 23921, 0, 0, 0, '', 'Ever-burning Torch targets, quest 11202'),
(13, 1, 42564, 0, 1, 31, 0, 3, 23922, 0, 0, 0, '', 'Ever-burning Torch targets, quest 11202'),
(13, 1, 42564, 0, 2, 31, 0, 3, 23923, 0, 0, 0, '', 'Ever-burning Torch targets, quest 11202'),
(13, 1, 42564, 0, 3, 31, 0, 3, 23924, 0, 0, 0, '', 'Ever-burning Torch targets, quest 11202');

-- Fix quest 12592 Des großen Jägers Wettstreit / The Great Hunter's Challenge
-- by deleting duplicate Killcredit 28566 from needed NPCs, by Salonia
-- Schreckenssäbler / Dreadsaber, 28001
-- Splitterhornrhinozeros / Shardhorn Rhino, 28009
-- Mangalkrokilisk / Mangal Crocolisk, 28002
UPDATE `creature_template` SET `KillCredit1` = 0 WHERE `entry` IN (28001, 28009, 28002);

-- Fix quest 13335 Vor dem Tor des Schreckens / Before the Gate of Horror
-- by giving killcredits from required NPCs Skeletthäscher / Skeletal Reaver, by Salonia
UPDATE `creature_template` SET `Killcredit2` = 32288 WHERE `entry` = 32467;

-- Fix quest Zerstört die Altäre / Destroying the Altars (13119) vladkata7979 https://github.com/TrinityCore/TrinityCore/issues/8032
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceGroup` = 1 AND `SourceEntry` = 57853;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,57853,0,0,31,0,3,30742,0,0,0,'','Master Summoner\'s Staff spell implicit target First Summoning Altar'),
(13,1,57853,0,1,31,0,3,30744,0,0,0,'','Master Summoner\'s Staff spell implicit target Second Summoning Altar'),
(13,1,57853,0,2,31,0,3,30745,0,0,0,'','Master Summoner\'s Staff spell implicit target Third Summoning Altar'),
(13,1,57853,0,3,31,0,3,30950,0,0,0,'','Master Summoner\'s Staff spell implicit target Fourth Summoning Altar');
-- Fix drop chance for required item 43159 Master Summoner's Staff / Stab des Meisterbeschwörers
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -100 WHERE `entry` = 30746 AND `item` = 43159;

-- Fix quest 13211 By Fire Be Purged / Das Feuer wird Euch läutern
-- Set correct targets for used spell 58641 Olakin's Torch / Olakins Fackel
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceGroup` = 1 AND `SourceEntry` = 58641;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,58641,0,0,31,0,3,31130,0,0,0,'','Olakin\'s Torch spell implicit target First Summoning Altar');

-- Fix spell exchange for mages (Teleport: Darnassus <-> Teleport: Thunder Bluff)
DELETE FROM `player_factionchange_spells` WHERE `alliance_id` = 3565 OR `horde_id` = 3566;
INSERT INTO `player_factionchange_spells` (`alliance_id`, `horde_id`) VALUES
(3565, 3566);
/*
select * from character_spell where spell = 3565 and guid in (select guid from characters where race in (2, 5, 6, 8, 10));
select * from character_spell where spell = 3566 and guid in (select guid from characters where race in (1, 3, 4, 7, 11));
*/

-- Fix dropchance for item 23239 Plump Buzzard Wing / Fleischiger Bussardflügel, by Salonia
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -50 WHERE `item` = 23239;

-- Fix quest 10836 (Unterwanderung der Festung des Drachenmals / Infiltrating Dragonmaw Fortress)
-- by deleting duplicate Killcredit 22197 from needed NPCs, by Salonia
-- Drachenreiter des Drachenmals / Dragonmaw Drake-Rider, 21719
-- Peon des Drachenmals / Dragonmaw Peon, 22252
-- Himmelsteiler des Drachenmals / Dragonmaw Skybreaker, 22274
-- Transporter des Drachenmals / Dragonmaw Transporter, 23188
-- Elitesoldat des Drachenmals / Dragonmaw Elite, 22331
-- Schamane des Drachenmals / Dragonmaw Shaman, 21720
-- Unterwerfer des Drachenmals / Dragonmaw Subjugator, 21718
-- Zänker des Drachenmals / Dragonmaw Wrangler, 21717
UPDATE `creature_template` SET `KillCredit1` = 0 WHERE `entry` IN (21717, 21718, 21720, 22331,23188, 22274, 22252, 21719);

-- Fix dropchances for recipes in item 33844 Barrel of Fish / Fass mit Fischen, by Salonia
-- Item 33869 Rezept: Gebratene Blutflosse / Repice: Broiled Bloodfin
-- Item 33870 Rezept: Schädelfischsuppe / Recipe: Skullfish Soup
-- Item 33875 Rezept: Kiblers Häppchen / Repice: Kibler's bits
UPDATE `item_loot_template` SET `ChanceOrQuestChance` = 15 WHERE `item` = 33869 AND `entry` = 33844;
UPDATE `item_loot_template` SET `ChanceOrQuestChance` = 14 WHERE `item` = 33870 AND `entry` = 33844;
UPDATE `item_loot_template` SET `ChanceOrQuestChance` = 5 WHERE `item` = 33875 AND `entry` = 33844;

-- An Improper Burial/ Ein unangemessenes Begräbnis (10913) quest fix by nelegalno
-- https://github.com/TrinityCore/TrinityCore/issues/1977
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 39189;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,39189,0,0,31,0,3,21846,0,0,0,'','set Sha\'tari Torch implicit target to Slain Auchenai Warrior'),
(13,1,39189,0,1,31,0,3,21859,0,0,0,'','set Sha\'tari Torch implicit target to Slain Sha\'tar Vindicator');
-- Remove wrong kill credit entries of npcs 21846, 21859 Slain Auchenai Warrior, Slain Sha'tar Vindicator, Getöteter Verteidiger der Sha'tar, Getöteter Kämpfer der Auchenai
UPDATE `creature_template` SET `KillCredit1` = 0 WHERE `entry` IN (21846, 21859);

-- Quests 12432, 12437 Ritt auf der roten Rakete / Riding the Red Rocket autocomplete quest
UPDATE `quest_template` SET `RequiredNpcOrGo1` = 0, `RequiredNpcOrGoCount1` = 0 WHERE `Id` IN (12432, 12437);


-- ======== NEW FIXES ========

-- Fix visual bug for race dependent vehicle items of Argent Tournament again
DELETE FROM `creature_template` WHERE `entry` = 50060;
INSERT INTO `creature_template` (entry, difficulty_entry_1, difficulty_entry_2, difficulty_entry_3, KillCredit1, KillCredit2, modelid1, modelid2, modelid3, modelid4, name, subname, IconName, gossip_menu_id, minlevel, maxlevel, exp, faction_A, faction_H, npcflag, speed_walk, speed_run, scale, rank, mindmg, maxdmg, dmgschool, attackpower, dmg_multiplier, baseattacktime, rangeattacktime, unit_class, unit_flags, dynamicflags, family, trainer_type, trainer_spell, trainer_class, trainer_race, minrangedmg, maxrangedmg, rangedattackpower, type, type_flags, lootid, pickpocketloot, skinloot, resistance1, resistance2, resistance3, resistance4, resistance5, resistance6, spell1, spell2, spell3, spell4, spell5, spell6, spell7, spell8, PetSpellDataId, VehicleId, mingold, maxgold, AIName, MovementType, InhabitType, HoverHeight, Health_mod, Mana_mod, Armor_mod, RacialLeader, questItem1, questItem2, questItem3, questItem4, questItem5, questItem6, movementId, RegenHealth, equipment_id, mechanic_immune_mask, flags_extra, ScriptName, WDBVerified) VALUES
(50060, 0, 0, 0, 0, 0, 11686, 0, 0, 0, 'Castle Argent Mount Trigger', '', '', 0, 80, 80, 2, 35, 35, 0, 1, 1.14286, 1, 1, 422, 586, 0, 642, 7.5, 0, 0, 1, 33554432, 8, 0, 0, 0, 0, 0, 345, 509, 103, 7, 2048, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1, 5.95238, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '', 12340);
DELETE FROM `vehicle_template_accessory` WHERE `entry` IN (33414, 33298, 33416, 33408, 33301, 33418, 33409, 33300, 33299, 33297, 33297);
INSERT INTO `vehicle_template_accessory` (entry, accessory_entry, seat_id, minion, description, summontype, summontimer) VALUES
(33297, 50060, 0, 1, 'Stormwind Steed - Block one seat invisible', 6, 30000),
(33298, 50060, 0, 1, 'Darnassian Nightsaber - Block one seat invisible', 6, 30000),
(33299, 50060, 0, 1, 'Darkspear Raptor - Block one seat invisible', 6, 30000),
(33300, 50060, 0, 1, 'Thunder Bluff Kodo - Block one seat invisible', 6, 30000),
(33301, 50060, 0, 1, 'Gnomeregan Mechanostrider - Block one seat invisible', 6, 30000),
(33408, 50060, 0, 1, 'Ironforge Ram - Block one seat invisible', 6, 30000),
(33409, 50060, 0, 1, 'Orgrimmar Wolf - Block one seat invisible', 6, 30000),
(33414, 50060, 0, 1, 'Forsaken Warhorse - Block one seat invisible', 6, 30000),
(33416, 50060, 0, 1, 'Exodar Elekk - Block one seat invisible', 6, 30000),
(33418, 50060, 0, 1, 'Silvermoon Hawkstrider - Block one seat invisible', 6, 30000);

-- DB/Quest: Raise the Barricades, Errichtet die Barrikaden, 13306, 13332
-- https://github.com/TrinityCore/TrinityCore/commit/e1026296015ea65b3a50a8abfcf19df5fc8f8df8
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=31887;
DELETE FROM `smart_scripts` WHERE `entryorguid`=31887 AND `source_type`=0;
INSERT INTO `smart_scripts`(`entryorguid`,`id`,`link`,`event_type`,`event_param1`,`action_type`,`action_param1`,`action_param2`,`target_type`,`comment`) VALUES
(31887,0,1,8,59925,88,3188700,3188702,1,'Ebon Blade Marker - On spell hit of Construct Barricade - Call random actionlist'),
(31887,1,2,61,0,33,31887,0,7,'Ebon Blade Marker - On spell hit of Construct Barricade - Give quest credit'),
(31887,2,0,61,0,41,0,0,1,'Ebon Blade Marker - On spell hit of Construct Barricade - Despawn'),
(31887,3,0,11,0,75,59919,0,1,'Ebon Blade Marker - Apply aura to self on spawn');
DELETE FROM `smart_scripts` WHERE `entryorguid` BETWEEN 3188700 AND 3188702 AND `source_type`=9;
INSERT INTO `smart_scripts`(`entryorguid`,`source_type`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
(3188700,9,11,59922,1,'Ebon Blade Marker - Actionlist - Cast Summon Barricade A'),
(3188701,9,11,59923,1,'Ebon Blade Marker - Actionlist - Cast Summon Barricade B'),
(3188702,9,11,59924,1,'Ebon Blade Marker - Actionlist - Cast Summon Barricade C');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=59925;
INSERT INTO `conditions`(`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`Comment`) VALUE
(13,1,59925,31,3,31887,'Construct Barricade - Target must be Ebon Blade Marker');
DELETE FROM `creature_addon` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` = 31887);
UPDATE `creature` SET `MovementType`=0,`spawndist`=0 WHERE `id`=31887;

-- Fix quest Bringing Down the Iron Thane, Nieder mit dem Eisenthan!, 12199
-- https://github.com/TrinityCore/TrinityCore/commit/c44c6248ecc52304a76ed5f44575fbf4e90abc80
-- Add missing spawns
DELETE FROM `creature` WHERE `id`=26405;
INSERT INTO `creature` (`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`unit_flags`,`dynamicflags`)  VALUES
(26405 ,571,1,1,0,1419,3317.76,-5112.08,300.462,1.78269,300,0,0,12762,3561,0,0,0,0); -- spawn NPC if there isn't, GUID is random
-- SAI for Thane
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=26405;
UPDATE `creature_template` SET `AIName`='SmartAI',`faction_A`=1954,`faction_H`=1954 WHERE `entry`=26405 ;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (26405,2640600);
INSERT INTO `smart_scripts` VALUES
(26405,0,0,0,38,0,100,0,0,1,0,0,80,2640600,2,0,0,0,0,1,0,0,0,0,0,0,0,'Thane - On data set 0 1 - Run timed action list'),
(26405,0,1,0,1,0,100,0,0,0,20000,20000,75,47922,0,0,0,0,0,1,0,0,0,0,0,0,0,'Iron Thane - OOC - Add Aura'),
(26405,0,2,0,0,0,100,0,5000,9000,10000,14000,11,61575,0,0,0,0,0,2,0,0,0,0,0,0,0,'Iron Thane - IC - Cast Furyhammer'),
(26405,0,3,0,6,0,100,0,0,0,0,0,28,47923,0,0,0,0,0,19,26406,30,0,0,0,0,0,'Thane - Script action 3 - Remove stun aura from Avil'),
-- Script 0 for Thane
(2640600,9,0,0,0,0,100,0,0,0,0,0,75,47923,0,0,0,0,0,19,26406,30,0,0,0,0,0,'Thane - Script action 0 - Add aura stunned to Anvil'),
(2640600,9,1,0,0,0,100,0,500,500,0,0,28,47922,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thane - Script action 1 - Remove inurnable aura from self'),
(2640600,9,2,0,0,0,100,0,0,0,0,0,45,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Thane - Script action 2 - Data set 0 0'),
(2640600,9,3,0,0,0,100,0,14500,14500,0,0,28,47923,0,0,0,0,0,19,26406,30,0,0,0,0,0,'Thane - Script action 3 - Remove stun aura from Avil');
-- Add SAI for Anvil
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=26406;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=26406;
DELETE FROM `smart_scripts` WHERE `entryorguid`=26406;
INSERT INTO `smart_scripts` VALUES
(26406,0,0,0,8,0,100,0,47911,0,0,0,45,0,1,0,0,0,0,19,26405,30,0,0,0,0,0,'Anvil - on Spell hit - Data set 0 1 on Thane'),
(26406,0,1,0,0,0,100,0,5000,7500,1200,14500,11,61577,0,0,0,0,0,2,0,0,0,0,0,0,0,'Anvil - IC - Cast Molten Blast');
-- Add npc_spellclick_spells
UPDATE `creature_template` SET `VehicleId`=149,`spell1`=61380,`spell2`=47911 WHERE `entry`=29005;
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=29005;
INSERT INTO `npc_spellclick_spells` (`npc_entry`,`spell_id`,`cast_flags`,`user_type`) VALUES
(29005,60944,1,0);
-- Add conditions for npc_spellclick_spells
DELETE FROM `conditions` WHERE `SourceGroup`=29005 AND `SourceTypeOrReferenceId`=18;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,29005,60944,0,1,9,0,12199,0,0,0,0,'', 'Player must be on quest 12199'),
(18,29005,60944,0,2,9,0,12153,0,0,0,0,'', 'Player must be on quest 12153');
-- Add conditions EMP to hit Anvil /for new condition system/
DELETE FROM `conditions` WHERE `SourceEntry`=47911 AND `SourceTypeOrReferenceId`=13;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,47911,0,0,31,0,3,26406,0,0,0,'', 'EMP can hit only Anvil /rewritten condition/');
-- Add conditions EMP to cast only, if in 10 yards to anvil
DELETE FROM `conditions` WHERE `SourceEntry`=47911 AND `SourceTypeOrReferenceId`=17;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(17,0,47911,0,0,29,0,26406,10,0,0,0,'', 'EMP can cast, if in 10 yards of Anvil');

-- Fix quest 13663 The Black Knight's Orders / Die Befehle des Schwarzen Ritters
-- Skip Gryphon requirement, too complex movement stuff for fixing it correctly
UPDATE `quest_template` SET `RequiredNpcOrGo1` = 0, `RequiredNpcOrGoCount1` = 0 WHERE `Id` = 13663;

-- Fix quest Tails Up, Männchen oder Weibchen?, 13549
-- Based on: https://github.com/rebirth-core/Rebirth---WoW/commit/36f3e1840c8c3ecbb1b73c59ea2d2f073eea9d95
-- Apparently it won't fall asleep due to evading. We are evading because the gossip won't show if we are in combat.. -_-
-- Misc stuff
UPDATE `creature_template` SET `unit_flags` = 0 WHERE `entry` IN (33007, 33008);
-- Frost Leopard SAI
UPDATE `creature_template` SET `AIName`='SmartAI',`npcflag`=0,`gossip_menu_id`=54000,`faction_A`=1990,`faction_H`=1990 WHERE `entry`=29327;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=29327;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (29327,29327*100,29327*100+1,29327*100+2,29327*100+3) AND `source_type` IN (0, 9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(29327,0,0,0,0,0,100,0,1000,1000,8000,11000,11,54668,0,0,0,0,0,2,0,0,0,0,0,0,0,"Frost Leopard - In Combat - Cast Rake"),
(29327,0,1,2,25,0,100,0,0,0,0,0,2,1990,0,0,0,0,0,1,0,0,0,0,0,0,0,"Frost Leopard - On Reset - Set Faction Back"),
(29327,0,2,0,8,0,100,1,62105,0,0,0,80,29327*100,0,2,0,0,0,1,0,0,0,0,0,0,0,"Frost Leopard - On Spellhit - Run Script"),
(29327,0,3,0,62,0,100,0,54000,0,0,0,88,29327*100+1,29327*100+3,0,0,0,0,1,0,0,0,0,0,0,0,"Frost Leopard - On Gossip Select - Run Random Script"),
(29327*100,9,0,0,0,0,100,0,0,0,0,0,11,52742,2,0,0,0,0,1,0,0,0,0,0,0,0,"Frost Leopard - On Script - Cast Sleep"),
(29327*100,9,1,0,0,0,100,0,0,0,0,0,2,35,0,0,0,0,0,1,0,0,0,0,0,0,0,"Frost Leopard - On Script - Set Faction Friendly"),
(29327*100,9,2,0,0,0,100,0,0,0,0,0,81,1,0,0,0,0,0,1,0,0,0,0,0,0,0,"Frost Leopard - On Script - Set npc_flag Gossip"),
(29327*100,9,3,0,0,0,100,0,0,0,0,0,41,300000,0,0,0,0,0,1,0,0,0,0,0,0,0,"Frost Leopard - On Script - Init despawn"),
(29327*100+1,9,0,0,0,0,100,0,0,0,0,0,36,33007,0,0,0,0,0,1,0,0,0,0,0,0,0,"Frost Leopard - On Script 1 - Update Template Male"),
(29327*100+1,9,1,0,0,0,100,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"Frost Leopard - Script 1 - Say Line 0"),
(29327*100+2,9,0,0,0,0,100,0,0,0,0,0,36,33010,0,0,0,0,0,1,0,0,0,0,0,0,0,"Frost Leopard - On Script 2 - Update Template Female"),
(29327*100+2,9,1,0,0,0,100,0,0,0,0,0,33,33005,0,0,0,0,0,7,0,0,0,0,0,0,0,"Frost Leopard - On Script 2 - Quest Credit"),
(29327*100+3,9,0,0,0,0,100,0,0,0,0,0,36,33007,0,0,0,0,0,1,0,0,0,0,0,0,0,"Frost Leopard - On Script 3 - Update Template Male"),
(29327*100+3,9,1,0,0,0,100,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"Frost Leopard - Script 3 - Say Line 0");
-- Insert gossip and static text
DELETE FROM `gossip_menu` WHERE `entry`=54000 AND `text_id`=14266;
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES (54000,14266);
DELETE FROM `gossip_menu_option` WHERE `menu_id`=54000;
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`) VALUES
(54000,0,0,"Lift the frost leopard's tail to check if it's a male or a female.",1,1,0);
-- Text
DELETE FROM `creature_text` WHERE `entry`=33007;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(33007,0,0,"It's an angry male!",42,0,100,0,0,0,"Male Frost Leopard");
-- Male Frost Leopard SAI
UPDATE `creature_template` SET `AIName`='SmartAI',`faction_A`=1990,`faction_H`=1990,`unit_flags`=`unit_flags`|0 WHERE `entry`=33007;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (33007,33007*100) AND `source_type` IN (0, 9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(33007,0,0,0,0,0,100,0,3000,4000,9000,11000,11,54668,0,0,0,0,0,2,0,0,0,0,0,0,0,"Male Frost Leopard - In Combat - Cast Rake");
-- Icepaw Bear SAI
UPDATE `creature_template` SET `AIName`='SmartAI',`npcflag`=0,`gossip_menu_id`=55000,`faction_A`=1990,`faction_H`=1990 WHERE `entry`=29319;
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=29319;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (29319,29319*100,29319*100+1,29319*100+2,29319*100+3) AND `source_type` IN (0, 9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(29319,0,0,0,0,0,100,0,1000,1000,8000,11000,11,54632,0,0,0,0,0,2,0,0,0,0,0,0,0,"Icepaw Bear - In Combat - Cast Claws of Ice"),
(29319,0,1,0,25,0,100,0,0,0,0,0,2,1990,0,0,0,0,0,1,0,0,0,0,0,0,0,"Icepaw Bear - On Reset - Set Faction Back"),
(29319,0,2,0,8,0,100,1,62105,0,0,0,80,29319*100,0,2,0,0,0,1,0,0,0,0,0,0,0,"Icepaw Bear - On Spellhit - Run Script"),
(29319,0,3,0,62,0,100,0,55000,0,0,0,88,29319*100+1,29319*100+3,0,0,0,0,1,0,0,0,0,0,0,0,"Icepaw Bear - On Gossip Select - Run Random Script"),
(29319*100,9,0,0,0,0,100,0,0,0,0,0,11,52742,2,0,0,0,0,1,0,0,0,0,0,0,0,"Icepaw Bear - On Script - Cast Sleep"),
(29319*100,9,1,0,0,0,100,0,0,0,0,0,2,35,0,0,0,0,0,1,0,0,0,0,0,0,0,"Icepaw Bear - On Script - Set Faction Friendly"),
(29319*100,9,2,0,0,0,100,0,0,0,0,0,81,1,0,0,0,0,0,1,0,0,0,0,0,0,0,"Icepaw Bear - On Script - Set npc_flag Gossip"),
(29319*100,9,3,0,0,0,100,0,0,0,0,0,41,300000,0,0,0,0,0,1,0,0,0,0,0,0,0,"Icepaw Bear - On Script - Init despawn"),
(29319*100+1,9,0,0,0,0,100,0,0,0,0,0,36,33008,0,0,0,0,0,1,0,0,0,0,0,0,0,"Icepaw Bear - On Script 1 - Update Template Male"),
(29319*100+1,9,1,0,0,0,100,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"Icepaw Bear - Script 1 - Say Line 0"),
(29319*100+2,9,0,0,0,0,100,0,0,0,0,0,36,33011,0,0,0,0,0,1,0,0,0,0,0,0,0,"Icepaw Bear - On Script 2 - Update Template Female"),
(29319*100+2,9,1,0,0,0,100,0,0,0,0,0,33,33006,0,0,0,0,0,7,0,0,0,0,0,0,0,"Icepaw Bear - On Script 2 - Quest Credit"),
(29319*100+3,9,0,0,0,0,100,0,0,0,0,0,36,33008,0,0,0,0,0,1,0,0,0,0,0,0,0,"Icepaw Bear - On Script 3 - Update Template Male"),
(29319*100+3,9,1,0,0,0,100,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"Icepaw Bear - Script 3 - Say Line 0");
-- Insert gossip and static text
DELETE FROM `gossip_menu` WHERE `entry`=55000 AND `text_id`=14267;
INSERT INTO `gossip_menu` (`entry`,`text_id`) VALUES (55000,14267);
DELETE FROM `gossip_menu_option` WHERE `menu_id`=55000;
INSERT INTO `gossip_menu_option` (`menu_id`,`id`,`option_icon`,`option_text`,`option_id`,`npc_option_npcflag`,`action_menu_id`) VALUES
(55000,0,0,"Lift the icepaw bear's tail to check if it's a male or a female.",1,1,0);
-- Male Icepaw Bear SAI
UPDATE `creature_template` SET `AIName`='SmartAI',`faction_A`=1990,`faction_H`=1990 WHERE `entry`=33008;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (33008,33008*100) AND `source_type` IN (0, 9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(33008,0,0,0,0,0,100,0,3000,4000,9000,11000,11,54632,0,0,0,0,0,2,0,0,0,0,0,0,0,"Male Icepaw Bear - In Combat - Cast Claws of Ice");
-- Text
DELETE FROM `creature_text` WHERE `entry`=33008;
INSERT INTO `creature_text` (`entry`,`groupid`,`id`,`text`,`type`,`language`,`probability`,`emote`,`duration`,`sound`,`comment`) VALUES
(33008,0,0,"It's an angry male!",42,0,100,0,0,0,"Male Icepaw Bear");
-- Only show first gossip if player is on quest Tails Up
DELETE FROM `conditions` WHERE `SourceGroup`=55000 AND `ConditionValue1`=13549;
DELETE FROM `conditions` WHERE `SourceEntry` IN (62105) AND `ConditionValue1` IN (29327,29319);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,55000,0,0,9,13549,0,0,0,'',"Only show gossip if player is on quest Tails Up"),
(17,0,62105,0,19,29327,0,0,0,'',"Spell To'kini's Blowgun can only be cast at Frost Leopard"),
(17,0,62105,1,19,29319,0,0,0,'',"Spell To'kini's Blowgun can only be cast at Icepaw Bear");

-- Fix quest 10839 Dunkelstein des Skithverstecks / Veil Skith: Darkstone of Terokk
-- Grant external event credit on LoS with creature 22288 Terokkar Quest Target
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 22288;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 22288 AND `source_type` = 0;
INSERT INTO `smart_scripts` (entryorguid, source_type, id, link, event_type, event_phase_mask, event_chance, event_flags, event_param1, event_param2, event_param3, event_param4, action_type, action_param1, action_param2, action_param3, action_param4, action_param5, action_param6, target_type, target_param1, target_param2, target_param3, target_x, target_y, target_z, target_o, comment) VALUES
(22288, 0, 0, 0, 10, 0, 100, 0, 0, 15, 1000, 1000, 15, 10839, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Terokkar Quest Target - Complete Quest 10839 on OOC LoS');
DELETE FROM `creature` WHERE `id` = 22288;
INSERT INTO `creature` (id, map, spawnMask, phaseMask, modelid, equipment_id, position_x, position_y, position_z, orientation, spawntimesecs, spawndist, currentwaypoint, curhealth, curmana, MovementType, npcflag, unit_flags, dynamicflags) VALUES
(22288, 530, 1, 1, 0, 0, -2512.74, 5418.92, 5.14871, 4.55531, 300, 0, 0, 42, 0, 0, 0, 0, 0),
(22288, 530, 1, 1, 0, 0, -2517.13, 5418.37, 0.0482962, 3.43768, 300, 0, 0, 42, 0, 0, 0, 0, 0),
(22288, 530, 1, 1, 0, 0, -2507.8, 5420.69, 0.0482962, 3.43768, 300, 0, 0, 42, 0, 0, 0, 0, 0);

-- Fix quest 11026 Banish the Demons / Bannt die Dämonen
-- https://github.com/TrinityCore/TrinityCore/commit/cabfcb1a3df7faf1425e5fecc1cc5100eec5ffb0
-- Issue 1520: Banish the Demons
DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (19973,22327,22201,22195,22204,22392,20557,22291,23322);
UPDATE `creature_template` SET `ainame`='SmartAI' WHERE `entry` IN (19973,22327,22201,22195,22204,22392,20557,22291,23322);
UPDATE `creature_template` SET `flags_extra`=130, `unit_flags`=33554432 WHERE `entry` IN (23322,23327);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (19973,22327,22201,22195,22204,22392,20557,22291,23322);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(19973,0,0,0,8,0,100,1,40825,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit - Set phase 1'),
(19973,0,1,0,6,1,100,0,0,0,0,0,33,23327,0,0,0,0,0,16,0,0,0,0,0,0,0, 'On death in phase 1 - give quest credit'),
(20557,0,0,0,8,0,100,1,40825,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit - Set phase 1'),
(20557,0,1,0,6,1,100,0,0,0,0,0,33,23327,0,0,0,0,0,16,0,0,0,0,0,0,0, 'On death in phase 1 - give quest credit'),
(20557,0,2,0,4,0,100,0,0,0,0,0,11,22911,0,0,0,0,0,2,0,0,0,0,0,0,0, 'On aggro - cast charge'),
(20557,0,3,0,0,0,100,0,5000,11000,20000,27000,11,36406,0,0,0,0,0,2,0,0,0,0,0,0,0,'In combat - cast breath'),
(22195,0,0,0,8,0,100,1,40825,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit - Set phase 1'),
(22195,0,1,0,6,1,100,0,0,0,0,0,33,23327,0,0,0,0,0,16,0,0,0,0,0,0,0, 'On death in phase 1 - give quest credit'),
(22195,0,2,0,0,0,75,0,2500,7500,14000,18000,11,34017,0,0,0,0,0,2,0,0,0,0,0,0,0, 'In combat - cast rain of chaos'),
(22195,0,3,0,0,0,100,0,10100,14100,122000,130000,11,11980,0,0,0,0,0,5,0,0,0,0,0,0,0, 'In combat - cast curse of weakness'),
(22201,0,0,0,8,0,100,1,40825,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit - Set phase 1'),
(22201,0,1,0,6,1,100,0,0,0,0,0,33,23327,0,0,0,0,0,16,0,0,0,0,0,0,0, 'On death in phase 1 - give quest credit'),
(22204,0,0,0,8,0,100,1,40825,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit - Set phase 1'),
(22204,0,1,0,6,1,100,0,0,0,0,0,33,23327,0,0,0,0,0,16,0,0,0,0,0,0,0, 'On death in phase 1 - give quest credit'),
(22291,0,0,0,8,0,100,1,40825,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit - Set phase 1'),
(22291,0,1,0,6,1,100,0,0,0,0,0,33,23327,0,0,0,0,0,16,0,0,0,0,0,0,0, 'On death in phase 1 - give quest credit'),
(22291,0,2,0,0,0,100,0,6300,12800,6300,12800,11,32736,0,0,0,0,0,2,0,0,0,0,0,0,0, 'In combat - cast mortal strike'),
(22327,0,0,0,8,0,100,1,40825,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit - Set phase 1'),
(22327,0,1,0,6,1,100,0,0,0,0,0,33,23327,0,0,0,0,0,16,0,0,0,0,0,0,0, 'On death in phase 1 - give quest credit'),
(22392,0,0,0,8,0,100,1,40825,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spell hit - Set phase 1'),
(22392,0,1,0,6,1,100,0,0,0,0,0,33,23327,0,0,0,0,0,16,0,0,0,0,0,0,0, 'On death in phase 1 - give quest credit'),
(23322,0,0,1,54,0,100,0,0,0,0,0,11,40849,0,0,0,0,0,1,0,0,0,0,0,0,0, 'On spawn - cast portal'),
(23322,0,1,0,61,0,100,0,0,0,0,0,11,40857,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Link with 0 - cast aura');

-- Delete old questrelations of NPCs from Scourge Invasion event
-- by deleting questrelation 12783 from needed NPCs, by Salonia
-- Blutelfenbürger / Blood Elf Commoner, 19169
-- Orcbürger / Orc Commoner, 19175
-- Taurenbürger / Tauren Commoner, 19176
-- Trollbürger / Troll Commoner, 19177
-- Bürger der Verlassenen / Forsaken Commoner, 19178
DELETE FROM `creature_questrelation` WHERE `id` IN (19169, 19175, 19176, 19177, 19178);

-- Fix quest 10855 Teufelshäscher, nein Danke! / Fel Reavers, No Thanks!
DELETE FROM `creature` WHERE `guid` = 78370 AND `id` = 22293;
DELETE FROM `creature_ai_scripts` WHERE `creature_id` = 22293;
UPDATE `creature_template` SET `AIName` = '' WHERE `entry` = 22293;
UPDATE `quest_template` SET `CompleteScript` = 10850 WHERE `Id` = 10850;
DELETE FROM `quest_end_scripts` WHERE `id` = 10850;
INSERT INTO `quest_end_scripts` (id, delay, command, datalong, datalong2, dataint, x, y, z, o) VALUES
(10850, 0, 7, 10855, 30, 0, 0, 0, 0, 0),
(10850, 0, 8, 22293, 0, 0, 0, 0, 0, 0);

-- Fix quest 11537 Die Schlacht muss weitergehen / The Battle Must Go On
-- by deleting duplicate Killcredit 25068 from needed NPCs, by Salonia
-- Abyssal Flamewalker / Abyssischer Flammenwandler, 25001
-- Irespeaker / Wutsprecherin, 24999
-- Unleashed Hellion / Entfesselter Vandale, 25002
UPDATE `creature_template` SET `Killcredit1`= 0 WHERE `entry` IN (25001, 24999, 25002);
-- Fix invisible modelid for NPC 25001, by Elron
UPDATE `creature_template` SET `modelid1` = 22810 WHERE `entry` = 25001;

-- Fix quest 13046 Feeding Arngrim / Arngrim füttern
DELETE FROM `gameobject_questrelation` WHERE `quest` = 13046;
INSERT INTO `gameobject_questrelation` (`id`, `quest`) VALUES (192524, 13046);
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 13046;
INSERT INTO `gameobject_involvedrelation` (`id`, `quest`) VALUES (192524, 13046);
DELETE FROM `gameobject` WHERE `id` = 192524;
INSERT INTO `gameobject` (id, map, spawnMask, phaseMask, position_x, position_y, position_z, orientation, rotation0, rotation1, rotation2, rotation3, spawntimesecs, animprogress, state) VALUES
(192524, 571, 1, 1, 7361.23, -2959.65, 913.502, 1.4987, 0, 0, 0.681163, 0.732132, 360, 0, 1);
UPDATE `quest_template` SET `RequiredMinRepFaction` = 1119, `RequiredMinRepValue` = 21000, `RequiredNpcOrGo1` = 30422 WHERE `Id` = 13046;

-- Fix quest 10672 Frankly,It Makes No Sense / Das ergibt echt keinen Sinn...
-- Taken from: https://github.com/TrinityCore/TrinityCore/commit/2a00b20da9bb9cbff8259c05304ff65397519300
-- Add spawns for two missing Arcano-Scorps
UPDATE `creature_template` SET `AIName`='PetAI',`unit_flags`=512,`MovementType`=1,`spell4`=37851,`spell5`=37917,`spell6`=37919,`spell7`=37918 WHERE `entry`=21909;
UPDATE `creature` SET `MovementType`=1,`spawndist`=3,`position_x`=-3414.004,`position_y`=825.4113,`position_z`=-30.77301 WHERE `guid`=76655;
DELETE FROM `creature` WHERE `id` IN (21909, 21924);
INSERT INTO `creature` (`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`MovementType`) VALUES
(21909,530,1,1,-3414.294,813.9421,-31.12042,1.478481,30,3,0,1),
(21909,530,1,1,-3408.508,795.8544,-31.42966,1.452154,30,3,0,1);
-- Spell script for trigger of control spell *will rewrite it once SAI spell script is released*
DELETE FROM `spell_scripts` WHERE `id` IN (37867,37892,37894);
INSERT INTO `spell_scripts` (`id`,`effindex`,`delay`,`command`,`datalong`,`datalong2`) VALUES
(37867,0,0,15,37868,2),
(37892,0,0,15,37893,2),
(37894,0,0,15,37895,2);
-- Limit 37851 only to Diametrons,also to ones not affected by it
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=17 AND `SourceEntry`=37851;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition` ,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(17,0,37851,0,0,31,1,3,21462,0,0,0, '', 'Tag can only target Greater Felfire Diametrons'),
(17,0,37851,0,0,1,1,37851,0,0,1,0, '', 'Tag cannot be casted on tagged Diametrons');
-- Limit Arcano_Dismantle to not being able to hit self and cannot damage anything else beside Arcano-scorp
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=37919;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition` ,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,37919,0,0,33,1,0,1,0,1,0, '', 'Arcano-Dismantle effect 0 cannot hit self'),
(13,2,37919,0,0,33,1,0,1,0,1,0, '', 'Arcano-Dismantle effect 1 cannot hit self'),
(13,1,37919,0,0,31,0,3,21909,0,0,0, '', 'Arcano-Dismantle effect 0 can hit only Arcano-Scorp'),
(13,2,37919,0,0,31,0,3,21909,0,0,0, '', 'Arcano-Dismantle effect 1 can hit only Arcano-Scorp');
-- Limit 37918 to not being able to hit self and cannot damage anything else beside Arcano-scorp
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=37918;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition` ,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,37918,0,0,33,1,0,1,0,1,0, '', 'Arcano_pince effect 0 cannot hit self'),
(13,1,37918,0,0,31,0,3,21909,0,0,0, '', 'Arcano_pince effect 0 can hit only Arcano-Scorp');
-- Add SAI for Greater Diametron to prevent some bugs
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=21462;
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=21462;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(21462,0,0,0,0,0,100,0,4500,5000,5000,7000,11,37945,0,0,0,0,0,2,0,0,0,0,0,0,0, 'Greater Fellfire Diametron - IC - Cast Fel Fireball'),
(21462,0,1,0,0,0,100,0,1500,3000,15000,17000,11,37941,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Greater Fellfire Diametron - IC - Cast Flaming Wound'),
(21462,0,2,3,8,0,100,0,37851,0,0,0,90,256,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Greater Fellfire Diametron - On hit by spell Tag - Set bytes to wipe aggro'),
(21462,0,3,4,61,0,100,0,0,0,0,0,91,256,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Greater Fellfire Diametron - Linked with previous event - Remove bytes'),
(21462,0,4,0,61,0,100,0,0,0,0,0,75,37851,0,0,0,0,0,1,0,0,0,0,0,0,0, 'Greater Fellfire Diametron - Linked with previous event - Add Tag aura on self');

-- Fix NPC 19055 Windrocmatriarchin / Windroc Matriarch
-- required for quest 10111 Bring me the Egg! / Bringt mir das Ei!
DELETE FROM `event_scripts` WHERE `id` = 12307;
INSERT INTO `event_scripts` (id, delay, command, datalong, datalong2, dataint, x, y, z, o) VALUES
(12307, 1, 10, 19055, 900000, 0, -2427.8, 6906.27, 12.7, 3.67);
DELETE FROM `smart_scripts` WHERE `entryorguid` = 19055 AND `source_type` = 0;
INSERT INTO `smart_scripts` (entryorguid, source_type, id, link, event_type, event_phase_mask, event_chance, event_flags, event_param1, event_param2, event_param3, event_param4, action_type, action_param1, action_param2, action_param3, action_param4, action_param5, action_param6, target_type, target_param1, target_param2, target_param3, target_x, target_y, target_z, target_o, comment) VALUES
(19055, 0, 3, 0, 0, 0, 100, 0, 4000, 4000, 6000, 6000, 11, 30285, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Windroc Matriarch - In Combat - Cast Eagle Claw'),
(19055, 0, 4, 0, 0, 0, 100, 0, 7000, 8000, 11000, 14000, 11, 32914, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Windroc Matriarch - In Combat - Cast Wing Buffet');