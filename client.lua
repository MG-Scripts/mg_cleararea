local zones = {}
local clearingActive = Config.ClearingActiveByDefault

-- Framework Exports
local ESX = nil
local QBCore = nil

if Config.Framework == 'ESX' then
    ESX = exports[Config.ESXExport]:getSharedObject()    
elseif Config.Framework == 'QBCore' then
    CreateThread(function()
        while QBCore == nil do
            QBCore = exports[Config.QBCoreExport]:GetCoreObject()
            Wait(0)
        end
    end)
end

-- Custom Notification Function
function notification(title, description, type)
    if Config.NotificationType == 'mg_notify' then
        exports['mg_notify']:Notify(description, type, 6000, title)
    elseif Config.NotificationType == 'lib' then
        lib.notify({
            title = title,
            description = description,
            type = type
        })
    elseif Config.NotificationType == 'esx' then
        if ESX then
            ESX.ShowNotification(description, type)
        else
            print('^1[Zone Manager]^7 ESX is not loaded for notifications.')
            -- fallback lib.notify
            lib.notify({
                title = title,
                description = description,
                type = type
            })
        end
    elseif Config.NotificationType == 'qbcore' then
        if QBCore then
            QBCore.Functions.Notify(description, type)
        else
            print('^1[Zone Manager]^7 QBCore is not loaded for notifications.')
            -- fallback lib.notify
            lib.notify({
                title = title,
                description = description,
                type = type
            })
        end
    else
        -- Fallback to lib.notify if type is unknown or not configured
        lib.notify({
            title = title,
            description = description,
            type = type
        })
    end
end

-- Lade Zonen beim Start
CreateThread(function()
    Wait(1000)
    LoadZones()
end)

-- Lade Zonen von der Datenbank
function LoadZones()
    lib.callback('mg_cleararea:getZones', false, function(result)
        zones = {}
        for _, zone in ipairs(result) do
            zones[zone.id] = {
                id = zone.id,
                name = zone.name,
                coords = vector3(zone.x, zone.y, zone.z),
                radius = zone.radius
            }
        end
        print('^2[Zone Manager]^7 ' .. #result .. ' ' .. _L('console_loaded'))
    end)
end

-- Hauptmenü
function OpenMainMenu()
    lib.callback('mg_cleararea:hasPermission', false, function(hasPermission)
        if not hasPermission then
            notification(_L('no_permission'), _L('no_permission_desc'), 'error')
            return
        end

        local clearingStatus = clearingActive and _L('menu_clearing_on') or _L('menu_clearing_off')
        
        lib.registerContext({
            id = 'zone_manager_main',
            title = _L('menu_main_title'),
            options = {
                {
                    title = _L('menu_add_zone'),
                    description = _L('menu_add_zone_desc'),
                    icon = 'plus',
                    onSelect = function()
                        OpenAddZoneMenu()
                    end
                },
                {
                    title = _L('menu_delete_zone'),
                    description = _L('menu_delete_zone_desc'),
                    icon = 'trash',
                    onSelect = function()
                        OpenDeleteZoneMenu()
                    end
                },
                {
                    title = _L('menu_show_zones'),
                    description = _L('menu_show_zones_desc'),
                    icon = 'list',
                    onSelect = function()
                        OpenZoneListMenu()
                    end
                },
                {
                    title = string.format(_L('menu_clearing_toggle'), clearingStatus),
                    description = _L('menu_clearing_toggle_desc'),
                    icon = 'power-off',
                    onSelect = function()
                        clearingActive = not clearingActive
                        local statusMsg = clearingActive and _L('clearing_enabled') or _L('clearing_disabled')
                        notification(_L('clearing_status'), statusMsg, clearingActive and 'success' or 'warning')
                        OpenMainMenu()
                    end
                }
            }
        })
        lib.showContext('zone_manager_main')
    end)
end

-- Zone hinzufügen Menü
function OpenAddZoneMenu()
    local input = lib.inputDialog(_L('input_zone_title'), {
        {type = 'input', label = _L('input_zone_name'), required = true, min = 3, max = 50},
        {type = 'number', label = _L('input_zone_radius'), required = true, default = Config.DefaultRadius, min = Config.MinRadius, max = Config.MaxRadius}
    })

    if not input then return end

    local name = input[1]
    local radius = tonumber(input[2]) +0.0
    local coords = GetEntityCoords(PlayerPedId())

    lib.callback('mg_cleararea:addZone', false, function(success)
        if success then
            notification(_L('zone_created'), string.format(_L('zone_created_desc'), name), 'success')
        else
            notification(_L('error'), _L('error_zone_create'), 'error')
        end
    end, name, coords, radius)
end

-- Zone löschen Menü
function OpenDeleteZoneMenu()
    if next(zones) == nil then
        notification(_L('no_zones'), _L('no_zones_desc'), 'info')
        return
    end

    local options = {}
    for id, zone in pairs(zones) do
        table.insert(options, {
            title = zone.name,
            description = string.format(_L('zone_info'), zone.radius, id),
            icon = 'location-dot',
            onSelect = function()
                local alert = lib.alertDialog({
                    header = _L('alert_delete_header'),
                    content = string.format(_L('alert_delete_content'), zone.name),
                    centered = true,
                    cancel = true
                })

                if alert == 'confirm' then
                    lib.callback('mg_cleararea:deleteZone', false, function(success)
                        if success then
                            notification(_L('zone_deleted'), _L('zone_deleted_desc'), 'success')
                        else
                            notification(_L('error'), _L('error_zone_delete'), 'error')
                        end
                    end, id)
                end
            end
        })
    end

    lib.registerContext({
        id = 'zone_manager_delete',
        title = _L('menu_delete_zone'),
        menu = 'zone_manager_main',
        options = options
    })
    lib.showContext('zone_manager_delete')
end

-- Zonen Liste Menü
function OpenZoneListMenu()
    if next(zones) == nil then
        notification(_L('no_zones'), _L('no_zones_desc'), 'info')
        return
    end

    local options = {}
    for id, zone in pairs(zones) do
        table.insert(options, {
            title = zone.name,
            description = string.format(_L('zone_coords'), zone.coords.x, zone.coords.y, zone.coords.z, zone.radius),
            icon = 'location-dot',
            onSelect = function()
                SetNewWaypoint(zone.coords.x, zone.coords.y)
                notification(_L('waypoint_set'), string.format(_L('waypoint_set_desc'), zone.name), 'info')
            end
        })
    end

    lib.registerContext({
        id = 'zone_manager_list',
        title = string.format(_L('zone_list_title'), #options),
        menu = 'zone_manager_main',
        options = options
    })
    lib.showContext('zone_manager_list')
end

-- NPC und Fahrzeug Clearing Thread
CreateThread(function()
    while true do
        Wait(Config.ClearingInterval)
        
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        -- Entferne Fahrzeuge aus Generatoren (läuft immer, auch ohne aktive Zonen)
        if Config.RemoveVehiclesFromGenerators then
            RemoveVehiclesFromGeneratorsInArea(coords.x - 400.0, coords.y - 400.0, coords.z - 50.0, coords.x + 400.0, coords.y + 400.0, coords.z + 50.0)
        end
        
        -- Räume alle definierten Zonen, wenn Clearing aktiviert ist
        if clearingActive and (zones) ~= nil then
            for _, zone in pairs(zones) do
                ClearAreaOfVehicles(zone.coords, zone.radius)
                ClearAreaOfPeds(zone.coords, zone.radius, 1)
            end
        else
            Wait(2000)
        end
    end
end)

-- Events von Server
RegisterNetEvent('mg_cleararea:zoneAdded', function(zone)
    zones[zone.id] = {
        id = zone.id,
        name = zone.name,
        coords = vector3(zone.x, zone.y, zone.z),
        radius = zone.radius
    }
end)

RegisterNetEvent('mg_cleararea:zoneDeleted', function(zoneId)
    zones[zoneId] = nil
end)

-- Command zum Öffnen des Menüs
RegisterCommand(Config.CommandName, function()
    OpenMainMenu()
end, false)

-- Keybind
RegisterKeyMapping(Config.CommandName, 'Zone Manager öffnen', 'keyboard', Config.Keybind)

