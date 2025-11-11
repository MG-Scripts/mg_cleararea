ESX = nil
QBCore = nil

-- Framework laden
if Config.Framework == 'ESX' then
    ESX = exports[Config.ESXExport]:getSharedObject()
    print('^2[Zone Manager]^7 ESX Framework geladen')
elseif Config.Framework == 'QBCore' then
    QBCore = exports[Config.QBCoreExport]:GetCoreObject()
    print('^2[Zone Manager]^7 QBCore Framework geladen')
else
    print('^2[Zone Manager]^7 Standalone Modus')
end

-- Berechtigungsprüfung
local function HasPermission(source)
    if Config.Framework == 'ESX' then
        if not Config.Permission.ESX.enabled then
            return true
        end
        
        if not ESX then
            print('^1[Zone Manager] ERROR: ESX nicht geladen!^7')
            return false
        end
        
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then
            return false
        end
        
        -- Prüfe Gruppen
        local playerGroup = xPlayer.getGroup()
        for _, allowedGroup in ipairs(Config.Permission.ESX.groups) do
            if playerGroup == allowedGroup then
                return true
            end
        end
        
        -- Prüfe Jobs mit Mindestrang
        if Config.Permission.ESX.jobs then
            local playerJob = xPlayer.getJob()
            
            for job, minGrade in pairs(Config.Permission.ESX.jobs) do
                if playerJob.name == job and playerJob.grade >= minGrade then
                    return true
                end
            end
        end
        
        return false
        
    elseif Config.Framework == 'QBCore' then
        if not Config.Permission.QBCore.enabled then
            return true
        end
        
        if not QBCore then
            print('^1[Zone Manager] ERROR: QBCore nicht geladen!^7')
            return false
        end
        
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then
            return false
        end
        
        -- Prüfe auf Permission
        if Config.Permission.QBCore.permission and QBCore.Functions.HasPermission(source, Config.Permission.QBCore.permission) then
            return true
        end
        
        -- Prüfe auf Job und Grad
        if Config.Permission.QBCore.jobs then
            local playerJob = Player.PlayerData.job.name
            local playerGrade = Player.PlayerData.job.grade.level
            
            for job, minGrade in pairs(Config.Permission.QBCore.jobs) do
                if playerJob == job and playerGrade >= minGrade then
                    return true
                end
            end
        end
        
        return false
    else
        -- Standalone - erlaube allen (oder implementiere eigene Logik)
        return true
    end
end

-- Lade alle Zonen aus der Datenbank
lib.callback.register('mg_cleararea:getZones', function(source)
    local result = MySQL.query.await('SELECT * FROM mg_cleararea', {})
    return result or {}
end)

-- Füge eine neue Zone hinzu
lib.callback.register('mg_cleararea:addZone', function(source, name, coords, radius)
    if not HasPermission(source) then
        return false
    end
    
    local result = MySQL.insert.await('INSERT INTO mg_cleararea (name, x, y, z, radius) VALUES (?, ?, ?, ?, ?)', {
        name,
        coords.x,
        coords.y,
        coords.z,
        radius
    })
    
    if result then
        TriggerClientEvent('mg_cleararea:zoneAdded', -1, {
            id = result,
            name = name,
            x = coords.x,
            y = coords.y,
            z = coords.z,
            radius = radius
        })
        return true
    end
    return false
end)

-- Lösche eine Zone
lib.callback.register('mg_cleararea:deleteZone', function(source, zoneId)
    if not HasPermission(source) then
        return false
    end
    
    local result = MySQL.query.await('DELETE FROM mg_cleararea WHERE id = ?', {zoneId})
    
    if result then
        TriggerClientEvent('mg_cleararea:zoneDeleted', -1, zoneId)
        return true
    end
    return false
end)

-- Prüfe Berechtigung
lib.callback.register('mg_cleararea:hasPermission', function(source)
    return HasPermission(source)
end)