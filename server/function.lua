if GetResourceState("es_extended") == 'started' then
    ESX = exports["es_extended"]:getSharedObject()
    Framework = 'esx'
elseif GetResourceState("qb-core") == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    Framework = 'qb'
end

RegisterNetEvent("e_gangcreator:createJob",function(gang)
    local source = source
    local queries = {
        'INSERT INTO `jobs2` (name, label, manage_pos, stash_pos, manage_password, stash_password) VALUE (@name,@label,@managepos,@stashpos,@managepassword,@stashpassword)',
        'INSERT INTO `job2_grades` (job_name, grade, name, label, salary) VALUE (@name,0,"little","Habitant",0)',
        'INSERT INTO `job2_grades` (job_name, grade, name, label, salary) VALUE (@name,1,"member","Membre",0)',
        'INSERT INTO `job2_grades` (job_name, grade, name, label, salary) VALUE (@name,2,"boss","Chef",0)',
        'INSERT INTO `addon_account`(name,label,shared) VALUE (@accountname,@label,1)',
        'INSERT INTO `addon_account_data`(account_name,money) VALUE (@accountname,0)',
    }
    local values = {
        name = gang.name,
        label = gang.label,
        managepos = json.encode(gang.managePos),
        stashpos = json.encode(gang.stashPos),
        managepassword = gang.managePassword,
        stashpassword = gang.stashPassword,
        accountname = Config.prefix..gang.name,
    }
    local success =  MySQL.transaction.await(queries,values)
    if success then
        TriggerClientEvent('ox_lib:notify', source, {title = Translate("insert_db"),type ='success'})
        if Framework == 'esx' then
            ESX.RefreshJobs()
        end
        RestartScriptStash()
    end
end)

RegisterNetEvent("e_gangcreator:EditGang",function (key,newValue,lastValue)
    local source = source
    local queries = {}
    local values = {
        newvalue = newValue,
        lastvalue = lastValue,
        newaccountname = Config.prefix..newValue,
        lastaccountname = Config.prefix..lastValue,
        pos = json.encode(newValue),
    }
    if key == "name" then
        queries = {
            'UPDATE `jobs2` SET name = @newvalue WHERE name = @lastvalue',
            'UPDATE `job2_grades` SET job_name = @newvalue WHERE job_name  = @lastvalue',
            'UPDATE `addon_account` SET name = @newaccountname WHERE name = @lastaccountname',
            'UPDATE `addon_account_data` SET account_name = @newaccountname WHERE account_name = @lastaccountname'
        }
    elseif key == "label" then
        queries = {
            'UPDATE `jobs2` SET label = @newvalue WHERE name = @lastname'
        }
    elseif key == "managePos" then
        queries = {
            'UPDATE `jobs2` SET manage_pos = @pos WHERE name = @lastname'
        }
    elseif key == "stashPos" then
        queries = {
            'UPDATE `jobs2` SET stash_pos = @pos WHERE name = @lastname'
        }
    elseif key == "stashPassword" then
        queries = {
            'UPDATE `jobs2` SET stash_password = @newvalue WHERE name = @lastvalue'
        }
    elseif key == "managePassword" then
        queries = {
            'UPDATE `jobs2` SET manage_password = @newvalue WHERE name = @lastvalue'
        }
    end
    if queries ~= {} then
        local success = MySQL.transaction.await(queries,values)
        if key == "stashPos" then
            RestartScriptStash()
        end
        if Framework == 'esx' then
            ESX.RefreshJobs()
        end
        if success then
            TriggerClientEvent('ox_lib:notify', source, {title = Translate("update_gang"),type ='success'})
        end
    end
end)

RegisterNetEvent("e_gangcreator:deleteGang",function (infogang)
    local source = source
    local queries = {
        'DELETE FROM `job2_grades` WHERE job_name = @name',
        'DELETE FROM `addon_account` WHERE name = @accountname',
        'DELETE FROM `addon_account_data` WHERE account_name = @accountname',
        'DELETE FROM `jobs2` WHERE name = @name',
        'DELETE FROM `ox_inventory` WHERE name = @accountname'
    }
    local values = {
        name = infogang.name,
        accountname = Config.prefix..infogang.name
    }
    local success = MySQL.transaction.await(queries,values)
    if success then
        RestartScriptStash()
        TriggerClientEvent('ox_lib:notify', source, {title = Translate("notify_delete_gang"),type ='success'})
    end
end)