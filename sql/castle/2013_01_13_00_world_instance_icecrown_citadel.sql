-- ICC Buff
DELETE FROM `disables` WHERE `entry` IN (73816, 73818, 73819, 73820, 73821, 73822, 73762, 73824, 73825, 73826, 73827, 73828) AND `sourceType` = 0;
DELETE FROM `conditions` WHERE `SourceEntry` IN (73816, 73818, 73819, 73820, 73821, 73822, 73762, 73824, 73825, 73826, 73827, 73828) AND `SourceTypeOrReferenceId` = 17;
INSERT INTO `conditions` (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, NegativeCondition, ErrorTextId, ScriptName, Comment) VALUES
(17, 0, 73816, 0, 0, 19, 0, 4, 0, 0, 0, 0, '', 'ICC Buff - Horde 5, just allow specified modes'),
-- (17, 0, 73818, 0, 0, 19, 0, 1, 0, 0, 0, 0, '', 'ICC Buff - Horde 10, just allow specified modes'),
-- (17, 0, 73819, 0, 0, 19, 0, 1, 0, 0, 0, 0, '', 'ICC Buff - Horde 15, just allow specified modes'),
(17, 0, 73820, 0, 0, 19, 0, 1, 0, 0, 0, 0, '', 'ICC Buff - Horde 20, just allow specified modes'),
-- (17, 0, 73821, 0, 0, 19, 0, 1, 0, 0, 0, 0, '', 'ICC Buff - Horde 25, just allow specified modes'),
-- (17, 0, 73822, 0, 0, 19, 0, 1, 0, 0, 0, 0, '', 'ICC Buff - Horde 30, just allow specified modes'),
(17, 0, 73762, 0, 0, 19, 0, 4, 0, 0, 0, 0, '', 'ICC Buff - Alliance 5, just allow specified modes'),
-- (17, 0, 73824, 0, 0, 19, 0, 1, 0, 0, 0, 0, '', 'ICC Buff - Alliance 10, just allow specified modes'),
-- (17, 0, 73825, 0, 0, 19, 0, 1, 0, 0, 0, 0, '', 'ICC Buff - Alliance 15, just allow specified modes'),
(17, 0, 73826, 0, 0, 19, 0, 1, 0, 0, 0, 0, '', 'ICC Buff - Alliance 20, just allow specified modes');
-- (17, 0, 73827, 0, 0, 19, 0, 1, 0, 0, 0, 0, '', 'ICC Buff - Alliance 25, just allow specified modes'),
-- (17, 0, 73828, 0, 0, 19, 0, 1, 0, 0, 0, 0, '', 'ICC Buff - Alliance 30, just allow specified modes');
DELETE FROM `spell_area` WHERE `spell` IN (73816, 73818, 73819, 73820, 73821, 73822, 73762, 73824, 73825, 73826, 73827, 73828) AND `area` = 4812;
INSERT INTO `spell_area` (spell, area, quest_start, quest_start_active, quest_end, aura_spell, racemask, gender, autocast) VALUES
(73816, 4812, 0, 0, 0, 0, 690, 2, 1), -- Horde, 5
-- (73818, 4812, 0, 0, 0, 0, 690, 2, 1), -- Horde, 10
-- (73819, 4812, 0, 0, 0, 0, 690, 2, 1), -- Horde, 15
(73820, 4812, 0, 0, 0, 0, 690, 2, 1), -- Horde, 20
-- (73821, 4812, 0, 0, 0, 0, 690, 2, 1), -- Horde, 25
-- (73822, 4812, 0, 0, 0, 0, 690, 2, 1), -- Horde, 30
(73762, 4812, 0, 0, 0, 0, 1101, 2, 1), -- Alliance, 5
-- (73824, 4812, 0, 0, 0, 0, 1101, 2, 1), -- Alliance, 10
-- (73825, 4812, 0, 0, 0, 0, 1101, 2, 1), -- Alliance, 15
(73826, 4812, 0, 0, 0, 0, 1101, 2, 1); -- Alliance, 20
-- (73827, 4812, 0, 0, 0, 0, 1101, 2, 1), -- Alliance, 25
-- (73828, 4812, 0, 0, 0, 0, 1101, 2, 1); -- Alliance, 30