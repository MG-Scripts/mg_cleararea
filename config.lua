Config = {}

-- Framework Einstellungen
Config.Framework = 'ESX' -- 'ESX' oder 'QBCore'
Config.ESXExport = 'es_extended' -- Name deines ESX Exports (meist 'es_extended' oder 'legacy')
Config.QBCoreExport = 'qb-core' -- Name deines QBCore Exports

Config.Locale = 'en' -- Gewählte Sprache: 'de' oder 'en'
-- Berechtigungen
Config.Permission = {
    ESX = {
        enabled = true,
        groups = {'admin', 'superadmin'}, -- Erlaubte Gruppen
        jobs = { -- Optional: Erlaubte Jobs mit Mindestrang
            --['police'] = 3, -- Police ab Rang 3
            --['sheriff'] = 2, -- Sheriff ab Rang 2
            -- ['ambulance'] = 4, -- Beispiel für weitere Jobs
        }
    },
    QBCore = {
        enabled = false,
        jobs = { -- Erlaubte Jobs mit Mindestrang
            ['police'] = 3,
            ['admin'] = 0
        },
        permission = 'god' -- Oder Permission wie 'admin', 'god', etc.
    }
}

-- Autos von den Generators entfernen?
Config.RemoveVehiclesFromGenerators = true -- or false


-- Zone Einstellungen
Config.DefaultRadius = 50 -- Standard Radius in Metern
Config.MinRadius = 5 -- Minimaler Radius
Config.MaxRadius = 500 -- Maximaler Radius
Config.ClearingInterval = 10 -- Interval für Clearing in ms (niedrigere Werte = häufiger aber mehr Performance-Last)
Config.ClearingActiveByDefault = true -- Clearing standardmäßig aktiviert

-- Keybind
Config.CommandName = 'zonemanager' -- Command zum öffnen
Config.Keybind = '' -- Standard Keybind (kann Ingame geändert werden)

-- Notification Einstellungen
Config.NotificationType = 'mg_notify'  -- 'mg_notify', 'lib', 'esx', 'qbcore' --client.lua Zeile 25+ Kannst du dein eigenes integrieren! 

-- Übersetzungen / Locales
Config.Locales = {
    ['de'] = {
        -- Notifications
        ['no_permission'] = 'Keine Berechtigung',
        ['no_permission_desc'] = 'Du hast keine Berechtigung für dieses Menü',
        ['zone_created'] = 'Zone erstellt',
        ['zone_created_desc'] = 'Die Zone "%s" wurde erfolgreich erstellt',
        ['zone_deleted'] = 'Zone gelöscht',
        ['zone_deleted_desc'] = 'Die Zone wurde erfolgreich gelöscht',
        ['error'] = 'Fehler',
        ['error_zone_create'] = 'Die Zone konnte nicht erstellt werden',
        ['error_zone_delete'] = 'Die Zone konnte nicht gelöscht werden',
        ['no_zones'] = 'Keine Zonen',
        ['no_zones_desc'] = 'Es existieren noch keine Zonen',
        ['waypoint_set'] = 'Wegpunkt gesetzt',
        ['waypoint_set_desc'] = 'Wegpunkt zur Zone "%s" wurde gesetzt',
        ['clearing_status'] = 'Zone Clearing',
        ['clearing_enabled'] = 'Clearing ist jetzt aktiviert',
        ['clearing_disabled'] = 'Clearing ist jetzt deaktiviert',
        ['zones_loaded'] = 'Zonen geladen',
        
        -- Menü Texte
        ['menu_main_title'] = 'Clear Area',
        ['menu_add_zone'] = 'Zone hinzufügen',
        ['menu_add_zone_desc'] = 'Erstelle eine neue Zone an deiner Position',
        ['menu_delete_zone'] = 'Zone löschen',
        ['menu_delete_zone_desc'] = 'Lösche eine bestehende Zone',
        ['menu_show_zones'] = 'Zonen anzeigen',
        ['menu_show_zones_desc'] = 'Liste aller aktiven Zonen',
        ['menu_clearing_toggle'] = 'Clearing: %s',
        ['menu_clearing_toggle_desc'] = 'Aktiviere/Deaktiviere das automatische NPC Clearing',
        ['menu_clearing_on'] = 'AN',
        ['menu_clearing_off'] = 'AUS',
        
        -- Input Dialog
        ['input_zone_title'] = 'Neue Zone erstellen',
        ['input_zone_name'] = 'Zonenname',
        ['input_zone_radius'] = 'Radius (Meter)',
        
        -- Delete Dialog
        ['alert_delete_header'] = 'Zone löschen',
        ['alert_delete_content'] = 'Möchtest du die Zone "%s" wirklich löschen?',
        
        -- Zone List
        ['zone_list_title'] = 'Zonen Liste (%s)',
        ['zone_info'] = 'Radius: %sm | ID: %s',
        ['zone_coords'] = 'X: %.2f | Y: %.2f | Z: %.2f | Radius: %.1fm',
        
        -- Console
        ['console_loaded'] = 'Zonen geladen',
        ['console_started'] = 'Script gestartet. Benutze ^3/%s^7 oder ^3%s^7 um das Menü zu öffnen',
    },
    
    ['en'] = {
        -- Notifications
        ['no_permission'] = 'No Permission',
        ['no_permission_desc'] = 'You don\'t have permission to access this menu',
        ['zone_created'] = 'Zone Created',
        ['zone_created_desc'] = 'The zone "%s" has been successfully created',
        ['zone_deleted'] = 'Zone Deleted',
        ['zone_deleted_desc'] = 'The zone has been successfully deleted',
        ['error'] = 'Error',
        ['error_zone_create'] = 'The zone could not be created',
        ['error_zone_delete'] = 'The zone could not be deleted',
        ['no_zones'] = 'No Zones',
        ['no_zones_desc'] = 'There are no zones yet',
        ['waypoint_set'] = 'Waypoint Set',
        ['waypoint_set_desc'] = 'Waypoint to zone "%s" has been set',
        ['clearing_status'] = 'Zone Clearing',
        ['clearing_enabled'] = 'Clearing is now enabled',
        ['clearing_disabled'] = 'Clearing is now disabled',
        ['zones_loaded'] = 'Zones Loaded',
        
        -- Menu Texts
        ['menu_main_title'] = 'Clear Area',
        ['menu_add_zone'] = 'Add Zone',
        ['menu_add_zone_desc'] = 'Create a new zone at your position',
        ['menu_delete_zone'] = 'Delete Zone',
        ['menu_delete_zone_desc'] = 'Delete an existing zone',
        ['menu_show_zones'] = 'Show Zones',
        ['menu_show_zones_desc'] = 'List of all active zones',
        ['menu_clearing_toggle'] = 'Clearing: %s',
        ['menu_clearing_toggle_desc'] = 'Enable/Disable automatic NPC clearing',
        ['menu_clearing_on'] = 'ON',
        ['menu_clearing_off'] = 'OFF',
        
        -- Input Dialog
        ['input_zone_title'] = 'Create New Zone',
        ['input_zone_name'] = 'Zone Name',
        ['input_zone_radius'] = 'Radius (Meters)',
        
        -- Delete Dialog
        ['alert_delete_header'] = 'Delete Zone',
        ['alert_delete_content'] = 'Do you really want to delete the zone "%s"?',
        
        -- Zone List
        ['zone_list_title'] = 'Zone List (%s)',
        ['zone_info'] = 'Radius: %sm | ID: %s',
        ['zone_coords'] = 'X: %.2f | Y: %.2f | Z: %.2f | Radius: %.1fm',
        
        -- Console
        ['console_loaded'] = 'Zones Loaded',
        ['console_started'] = 'Script started. Use ^3/%s^7 or ^3%s^7 to open the menu',
    }
}

-- Funktion um Übersetzungen zu bekommen
function _L(key)
    if Config.Locales[Config.Locale] and Config.Locales[Config.Locale][key] then
        return Config.Locales[Config.Locale][key]
    else
        return 'Translation [' .. key .. '] not found'
    end
end
