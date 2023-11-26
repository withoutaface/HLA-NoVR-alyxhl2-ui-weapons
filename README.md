# HLA-NoVR alyxhl2-ui-weapons
I'm part of the novr mod team and use this repository for development and contributing to the project.
Most of my work is already merged to the [upstream](https://github.com/bfeber/HLA-NoVR) repository.

For mod support use this branch: [branch - mod_support](https://github.com/withoutaface/HLA-NoVR-alyxhl2-ui-weapons/tree/mod_support)
(based on [Hypercycle](https://github.com/VladManyanov/HLA-NOVR-Mods) amazing work)
There is also a branch containing my classic hl2 based viewmodels: [branch - classic](https://github.com/withoutaface/HLA-NoVR-alyxhl2-ui-weapons/tree/classic)

# HLA-NoVR
NoVR Script for Half-Life: Alyx

## Installation
[Install the official launcher for easy updates](https://github.com/bfeber/HLA-NoVR-Launcher#installation-and-usage).

You can also get the [NoVR Map Edits addon](https://steamcommunity.com/sharedfiles/filedetails/?id=2956743603) for smoother traversal and less out of bounds glitches.

## Controls
To change the controls/rebind buttons or change your FOV, edit ``game\hlvr\scripts\vscripts\bindings.lua`` in your main Half-Life: Alyx installation folder.

If you get stuck try to move back or crouch! In case that does not help you can enable noclip with V.

### Keyboard and Mouse
Left Click: Select in Main Menu/Throw Held Object/Primary Attack

W, A, S, D: Move

Space: Jump

Ctrl: Crouch

Shift: Sprint

E: Interact/Pick Up Object/Gravity Gloves/Put Valuable Item in Wrist Pocket

Z: Use Health Pen in Wrist Pocket

X: Drop Object in Wrist Pocket

F: Flashlight (if you have it)

H: Cover your mouth

F5: Quick Save

F9: Quick Load

M: Main Menu

P: Pause

V: Noclip (if you get stuck)

C: Console

T: Inspect Weapon

## Official Discord Server
https://discord.gg/AyfBeuZXsR

## Old installation method
If the launcher doesn't work, then you can try the old installation method:

Copy the ``game`` folder into your main Half-Life: Alyx installation folder (e.g. ``C:\Program Files (x86)\Steam\steamapps\common\Half-Life Alyx``).

Then start the game with the launch options ``-novr -vsync +vr_enable_fake_vr 1``.

## Special Thanks
- JJL772 for making the flashlight and jump scripts: https://github.com/JJL772/half-life-alyx-scripts
- Withoutaface for making the amazing HUD: https://github.com/withoutaface/HLA-NoVR-alyxhl2-ui-weapons
- FrostElex for Storage script from his tools package: https://github.com/FrostSource/hla_extravaganza
