-- Scripts/CullingofStratholme: Fix Arthas waiting position in fire street
UPDATE `script_waypoint` SET `waittime` = 0 WHERE `entry` = 26499 AND `pointid` = 47;
UPDATE `script_waypoint` SET `location_x` = 2514.10, `location_y` = 1321.17, `location_z` = 131.63, `waittime` = 20000 WHERE `entry` = 26499 AND `pointid` = 48;
UPDATE `script_waypoint` SET `location_x` = 2510.41, `location_y` = 1331.24, `location_z` = 132.3 WHERE `entry` = 26499 AND `pointid` = 49;