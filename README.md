# Mega Man X Archipelago Tracker for PopTracker

This is a PopTracker pack for Mega Man X Archipelago. Created by MeridianBC.

![](https://raw.githubusercontent.com/BrianCumminger/megamanx-ap-poptracker/master/images/screenshot.png)

## Installation

Just download the lastest build or source and put in your PopTracker packs folder.

## Recent Changes
### v1.0.0 (June 6, 2024)
- Version 1.0 because all game logic is now tracked and therefore should be feature complete for now.
- Reworked boss weaknesses. Weaknesses are now detected and used for logic calculations, with vanilla weaknesses as a fallback if not autotracking
- Bosses that can be reached and damaged but not required by logic are shown in yellow
- Added yellow logic for hadouken on Chill Penguin domes
- Added game-themed map icons to replace the default chest location marker
  
### v0.1.2 (May 31, 2024)
- Combined various close map items for a cleaner look
- Changed arms/jammed buster to function the same as the X3 tracker
- Fixed bug in armor upgrades count calculation
- Added 'yellow' logic for bosses

## Features
Detects and tracks all logic as of Mega Man X AP 1.0.2 including:

- Charged shotgun ice logic
- Pickupsanity
- Jammed buster
- Sigma access conditions (medals/weapons/upgrades/heart/sub/access codes)
- Legs required for Sigma
- Boss weaknesses and appropriate "yellow" shading when a boss can be damaged but is not in logic (following strictness setting)
  
Includes individual stage maps showing item locations, with the option to automatically switch tabs (on by default).

## Usage
When using Archipelago auto tracking, logic settings will all be set automatically.  For manual operation (or to check which settings are active), click on the "Open Pack Settings" button at the top of PopTracker while this pack is loaded.

Brief notes for various settings when not using autotracker:
- Right hand side sigma options: sets the access requirements for Sigma stage 1.  If all of these are blank or set to 0, Sigma 1 will unlock when Sigma Fortress Access Codes is acquired.
- Bosses Require Weaknesses: yaml option (`logic_boss_weakness`).  Bosses will be shaded yellow if you can reach and damage them but destroying them is not in logic. When not autotracking, bosses are assumed to have unshuffled weaknesses.
- Jammed Buster: yaml option `jammed_buster` - adds an extra arm upgrade to the pool. Right click arms upgrade icon to start with a down arrow on the arms icon that first be upgraded to a gray 'no upgrade' icon before going to a standard upgrade indicator.
- Sigma Stages Open As Group: yaml option `sigma_all_levels`


## More Info

Check out PopTrackers Documentation on packs [here](https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md)

Still having trouble realizing your pack and looking for help or just want more information about everything PopTracker? Check out the ['Unofficial' PopTracker Discord Server](https://discord.com/invite/gwThqMCPgK)!

## License

Public Domain