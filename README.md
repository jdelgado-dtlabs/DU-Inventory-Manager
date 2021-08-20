# DU-Ship-Inventory
## Dual Universe Ship Inventory Manager

![Initial Screen](/images/1.png)
This project leverages the recently released screen LUA APIs to provide an interface with the programming board.

With this system, you can set up a visual representation of your container on your ship. Designed to use a hub.

Edit the begining of the `screen1.lua` file and put your titles and options.

```lua
local title = "Inventory" -- export: Name your display.
local bgtext = "Medium Heavy Cargo Ship" -- export: Background text of your choice.
local bgPlanetImg = "assets.prod.novaquark.com/20368/954f3adb-3369-4ea9-854d-a14606334152.png" -- export: (Default: Alioth URL)
...
```
Do not edit any other options or you will mess with the system's timings.

## How to Setup

1. Place a screen anywhere you want it to be seen.
2. Place a container or hub on, around, or next to the screen.
3. Place a programming board.
4. Place a trigger. This can be a detection zone, or manual switch, or any other triggering device.
5. A relay to turn on your screen and the programming board at the same time.
5. Link in the following order (IMPORTANT):
    1. Programming Board to Screen 
    2. Programming Board to Container or Hub
    3. Load the screen with the code:
        1. Open the `screen1.lua`
        2. Edit the options at the beginning.
        3. Copy the contents with your edits
        4. Right-click the screen, click Advanced, and select Edit Content.
        5. On the top right, make sure LUA is highlighted. This code will not work in HTML mode.
        5. Paste in the box the code you copied.
        6. Click Apply.
    4. Load the programming board with the code.
        1. Open `pb_conf.json`
        2. Copy the contents without editing them.
        3. Right-cick the programming board.
        4. Click Advanced, then "Paste configuration from Clipboard" to load the script.
        5. Right-click the programming board again, click Advanced, then select `Edit Lua Parameters`.
        6. Enter your value for your total capacity. This is in L.
            - Example: if you have 1250kL capacity, you enter `1250000`
    5. Connect the relay output to the screen and the programming board.
    6. Connect your trigger to the relay.
