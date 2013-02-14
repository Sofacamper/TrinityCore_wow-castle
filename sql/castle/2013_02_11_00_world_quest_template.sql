-- Quests 24655, 24536 Irgendwas stinkt hier / Something Stinks autocomplete quest
-- Backup : 37558
UPDATE `quest_template` SET `RequiredNpcOrGo1` = 0, `RequiredNpcOrGoCount1` = 0 WHERE `Id` IN (24655, 24536);

-- Prequest changing to final quest:
-- Alliance (backup: 24657)
UPDATE `quest_template` SET `PrevQuestID` = 24655 WHERE `Id` IN (24666, 24658, 24659, 24660, 24662, 24663, 24664, 24665);
-- Horde (backup: 24576)
UPDATE `quest_template` SET `PrevQuestID` = 24536 WHERE `Id` IN (24652, 24638, 24645, 24647, 24648, 24649, 26450, 26451);