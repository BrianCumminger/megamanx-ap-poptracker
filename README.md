# Mega Man X Archipelago Tracker for PopTracker

This is a PopTracker pack for Mega Man X Archipelago. Created by MeridianBC.

![](https://raw.githubusercontent.com/BrianCumminger/megamanx-ap-poptracker/master/images/screenshot.png)

## Installation

Just download the lastest build or source and put in your PopTracker packs folder.

## Features
Detects and tracks all logic as of Mega Man X AP 1.0 including:

- Charged shotgun ice logic
- Pickupsanity
- Jammed buster
- Sigma access conditions (medals/weapons/upgrades/heart/sub/access codes)
- Legs required for Sigma
- Boss weaknesses required
  
Includes individual stage maps showing item locations, with the option to automatically switch tabs (on by default).

## Usage
When using Archipelago auto tracking, logic settings will all be set automatically.  For manual operation (or to check which settings are active), click on the "Open Pack Settings" button at the top of PopTracker while this pack is loaded.

Brief notes for various settings when not using autotracker:
- Right hand side sigma options: sets the access requirements for Sigma stage 1.  If all of these are blank or set to 0, Sigma 1 will unlock when Sigma Fortress Access Codes is acquired.
- Bosses Require (Unshuffled) Weaknesses: Does not map directly to a yaml option.  If boss weaknesses are required by logic (`logic_boss_weakness: true`) and weaknesses are unshuffled (`boss_weakness_rando: vanilla`), this will show bosses as being in logic only if you have their required weakness.  Otherwise, bosses will always be shown as in logic if you can reach them.
- Jammed Buster: yaml option `jammed_buster` - adds an extra arm upgrade to the pool which will be indicated with a "2" in the corner of the arms upgrade icon.
- Sigma Stages Open As Group: yaml option `sigma_all_levels`


## More Info

Check out PopTrackers Documentation on packs [here](https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md)

Still having trouble realizing your pack and looking for help or just want more information about everything PopTracker? Check out the ['Unofficial' PopTracker Discord Server](https://discord.com/invite/gwThqMCPgK)!

## License

Public Domain