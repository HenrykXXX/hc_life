local function resetSpawnedField()
    exports['mysql-async']:mysql_execute('UPDATE vehicles SET spawned = 0 WHERE spawned = 1', {}, function(rowsChanged)
        if rowsChanged > 0 then
            print("hc:core: Reset 'spawned' field for " .. rowsChanged .. " vehicles.")
        else
            print("hc:core: No vehicles needed 'spawned' field reset.")
        end
    end)
end

-- Event handler for when the resource starts
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print("hc:core: Resource " .. resourceName .. " started. Resetting 'spawned' field in database.")
        resetSpawnedField()
    end
end)


AddEventHandler('playerJoining', function()
    local src = source
    local steamid = false
    local license = false
    local discord = false
    local xbl = false
    local liveid = false
    local ip = false

    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = string.sub(v, string.len("steam:") + 1)
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = string.sub(v, string.len("license:") + 1)
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl = string.sub(v, string.len("xbl:") + 1)
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = string.sub(v, string.len("ip:") + 1)
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = string.sub(v, string.len("discord:") + 1)
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = string.sub(v, string.len("live:") + 1)
        end
    end

    -- Check if the player exists in the database
    exports['mysql-async']:mysql_fetch_all('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = license
    }, function(result)
        if result[1] then
            -- Player found in the database, load their data
            local playerData = result[1]
            HC.PlayerData[src] = {
                money = playerData.money,
                bankMoney = playerData.bank,
                inventory = json.decode(playerData.inventory),
                vehicles = json.decode(playerData.vehicles) or {}
            }
            print("hc:core: Player data loaded from database for player ID " .. src)
        else
            -- Player not found in the database, insert default values
            HC.PlayerData[src] = {
                money = 100000, -- Default money
                bankMoney = 5000, -- Default bank money
                inventory = {
                    items = {},
                    maxWeight = 24,
                    currentWeight = 0
                }, -- Empty inventory
                vehicles = {}
            }

            exports['mysql-async']:mysql_execute('INSERT INTO users (identifier, license, steam, discord, xbl, live, ip, name, money, bank, inventory, vehicles) VALUES (@identifier, @license, @steam, @discord, @xbl, @live, @ip, @name, @money, @bank, @inventory, @vehicles)', {
                ['@identifier'] = license or NULL,
                ['@license'] = license or NULL,
                ['@steam'] = steamid or NULL,
                ['@discord'] = discord or NULL,
                ['@xbl'] = xbl or NULL,
                ['@live'] = liveid or NULL,
                ['@ip'] = ip or NULL,
                ['@name'] = GetPlayerName(src) or NULL,
                ['@money'] = 100000, -- Default money
                ['@bank'] = 5000, -- Default bank money
                ['@inventory'] = json.encode({items = {{"pineapple", 1}}, maxWeight = 24, currentWeight = 0}), -- Empty inventory
                ['@vehicles'] = json.encode({}) -- Empty vehicles
            }, function(rowsChanged)
                print("hc:core: Default player data inserted into the database for player ID " .. src)
            end)
        end

        HC.PlayerData[src].key = license

        --HC.Inventory.AddItem(src, 'pineapple', 1)
        print("Player stats initialized for player ID " .. src)
    end)
end)

-- Clean up player stats on player disconnect
AddEventHandler('playerDropped', function(reason)
    local src = source
    if HC.PlayerData[src] then
        -- Save player data to the database before removing from memory
        exports['mysql-async']:mysql_execute('UPDATE users SET money = @money, bank = @bank, inventory = @inventory, vehicles = @vehicles WHERE identifier = @identifier', {
            ['@identifier'] = HC.PlayerData[src].key, --string.sub(GetPlayerIdentifier(src, 0), string.len("license:") + 1),
            ['@money'] = HC.PlayerData[src].money,
            ['@bank'] = HC.PlayerData[src].bankMoney,
            ['@inventory'] = json.encode(HC.PlayerData[src].inventory),
            ['@vehicles'] = json.encode(HC.PlayerData[src].vehicles)
        }, function(rowsChanged)
            HC.PlayerData[src] = nil
            print("hc:core: Player data saved to database and removed from memory for player ID " .. src)
        end)
    end
end)