-- Fix spell 71255 Erstickende Gasbombe / Chocking Gas Bomb effects selecting player in vehicle NPC 37672 Mutated Abomination / Mutierte Monstrosität
DELETE FROM `spell_script_names` WHERE spell_id IN (71278, 72460, 72619, 72620, 71279, 72459, 72621, 72622);
INSERT INTO `spell_script_names` (spell_id, ScriptName) VALUES
(71278, 'spell_putricide_choking_gas_bomb_effect'),
(72460, 'spell_putricide_choking_gas_bomb_effect'),
(72619, 'spell_putricide_choking_gas_bomb_effect'),
(72620, 'spell_putricide_choking_gas_bomb_effect'),
(71279, 'spell_putricide_choking_gas_bomb_effect'),
(72459, 'spell_putricide_choking_gas_bomb_effect'),
(72621, 'spell_putricide_choking_gas_bomb_effect'),
(72622, 'spell_putricide_choking_gas_bomb_effect');