# mg_cleararea: NPC & Vehicle Remover

A FiveM script for easily managing zones where NPCs and vehicles are automatically removed.

## Features

- ✅ In-game menu for management
- ✅ Create zones at current position
- ✅ Individual radius per zone
- ✅ Name zones
- ✅ Database storage (persistent)
- ✅ Delete zones
- ✅ Zone list with waypoint function
- ✅ On/Off switch for clearing
- ✅ Real-time synchronization across all players
- ✅ **ESX & QBCore Support**
- ✅ **Multi-Language Support (DE/EN)**

## Dependencies

This script requires:
- **ox_lib** - https://github.com/overextended/ox_lib Callbacks and Menu
- **oxmysql** - https://github.com/overextended/oxmysql Database!

## Installation

1. **Copy files:**
   - Extract the folder into your `resources` directory

2. **Create database:**
   - Run the `install.sql` in your database or copy the SQL prompt
```sql 
CREATE TABLE IF NOT EXISTS `mg_cleararea` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `radius` FLOAT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
```   

3. **Adjust server.cfg:**
   ```cfg
   start ox_lib
   start oxmysql
   start mg_cleararea
   ```

4. **Adjust config:**
   - Open `config.lua` and set your framework:
   ```lua
   Config.Framework = 'ESX' -- or 'QBCore' or 'standalone'
   ```
   - Adjust permissions (see below)
   - Optional: Change language (`Config.Locale = 'de'` or `'en'`)

## Usage

### Open menu
- **Command:** `/zonemanager`
- **Keybind:** `F6` (customizable in FiveM settings)

### Create zone
1. Open menu
2. Select "Add Zone"
3. Enter name
4. Enter radius (5-500 meters)
5. Zone will be created at your current position

### Delete zone
1. Open menu
2. Select "Delete Zone"
3. Select zone from list
4. Confirm deletion

### Activate/Deactivate clearing
- In the main menu, you can turn automatic clearing on and off
- Status is displayed in the menu (Green = ON, Red = OFF)

## Configuration

### Set framework

In the `config.lua`:

```lua
Config.Framework = 'ESX' -- Options: 'ESX', 'QBCore', 'standalone'
Config.ESXExport = 'es_extended' -- Name of your ESX export
Config.QBCoreExport = 'qb-core' -- Name of your QBCore export
```

### Permissions for ESX

```lua
Config.Permission = {
    ESX = {
        enabled = true, -- set to false to allow everyone
        groups = {'admin', 'superadmin'}, -- Allowed groups
        jobs = { -- Optional: Allowed jobs with minimum rank
            ['police'] = 3, -- Police from rank 3
            ['sheriff'] = 2, -- Sheriff from rank 2
        }
    }
}
```

**Note:** ESX checks EITHER the group OR the job. If either applies, the player has access.

### Permissions for QBCore

```lua
Config.Permission = {
    QBCore = {
        enabled = true, -- set to false to allow everyone
        jobs = { -- Allowed jobs with minimum rank
            ['police'] = 3, -- Police from rank 3
            ['admin'] = 0   -- Admin all ranks
        },
        permission = 'god' -- Or 'admin', 'god', etc.
    }
}
```

**Note:** QBCore checks EITHER the permission OR the job. If either applies, the player has access.

### Change language

```lua
Config.Locale = 'de' -- 'de' for German, 'en' for English
```

You can also add your own translations:

```lua
Config.Locales['fr'] = {
    ['menu_main_title'] = 'Zone Manager',
    -- ... more translations
}
```

### Zone settings

```lua
Config.DefaultRadius = 50 -- Default radius in meters
Config.MinRadius = 5 -- Minimum radius
Config.MaxRadius = 500 -- Maximum radius
Config.ClearingInterval = 100 -- Interval for clearing in ms
```

### Command & Keybind

```lua
Config.CommandName = 'zonemanager' -- Command to open
Config.Keybind = 'F6' -- Default keybind
```

## Support & Customization

For further customization or help, check out the comments in the code or adjust the values according to your needs.

## License

Free to use for private and non-commercial FiveM servers.
Selling or copying the code is prohibited!
