# HLA-NoVR
NoVR Script for Half-Life: Alyx

## Installation
[Install the official launcher.](https://github.com/bfeber/HLA-NoVR-Launcher#installation-and-usage)

If you use a Steam Deck/Linux, see the section at the bottom.

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

## Special Thanks
- JJL772 for making the flashlight and jump scripts: https://github.com/JJL772/half-life-alyx-scripts
- Withoutaface for making the amazing HUD: https://github.com/withoutaface/HLA-NoVR-alyxhl2-ui-weapons
- FrostElex for Storage script from his tools package: https://github.com/FrostSource/hla_extravaganza

## Steam Deck/Linux
The launcher is currently unsupported on Deck/Linux, so you must [download the branch here.](https://github.com/bfeber/HLA-NoVR/archive/refs/heads/steam_deck.zip)

To install it, extract the files and copy the ``game`` folder into your main Half-Life: Alyx installation folder (e.g. ``C:\Program Files (x86)\Steam\steamapps\common\Half-Life Alyx``). Make sure to accept when it asks you to replace files.

Then start the game with the launch options ``-novr -vsync +vr_enable_fake_vr 1``.
