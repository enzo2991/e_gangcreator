if GetResourceState("es_extended") == 'started' then
    ESX = exports["es_extended"]:getSharedObject()
    Framework = 'esx'
elseif GetResourceState("qb-core") == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    Framework = 'qb'
end

RegisterNetEvent("e_gangcreator:createJob",function(gang)
    local querieGrade = 'INSERT INTO `job2_grades` (job_name, grade, name, label, salary) VALUE (?,?,?,?,?)'
    local querieJob = 'INSERT INTO `jobs2` (name, label, manage_pos, stash_pos, manage_password, stash_password) VALUE (?,?,?,?,?,?)'
    local querieAddon = 'INSERT INTO `addon_account`(name,label,shared) VALUE (?,?,?)'
    local querieAddonData = 'INSERT INTO `addon_account_data`(account_name,money) VALUE (?,?)'

    local source = source
    local id =  MySQL.insert.await(querieJob,{gang.name, gang.label, json.encode(gang.managePos), json.encode(gang.stashPos), gang.managePassword, gang.stashPassword})
    if id then
        local addonaccount = MySQL.insert.await(querieAddon,{Config.Queries.money.prefix..gang.name, gang.label, 1})
        local addonaccountData = MySQL.insert.await(querieAddonData,{Config.Queries.money.prefix..gang.name, 0})
        local grade1 = MySQL.insert.await(querieGrade,{gang.name, 0, "little", "Habitant", 0})
        local grade2 = MySQL.insert.await(querieGrade,{gang.name, 1, "member", "Membre", 0})
        local grade3 =  MySQL.insert.await(querieGrade,{gang.name, 3, "boss", "Chef", 0})
        if grade1 and grade2 and grade3 and addonaccount and addonaccountData then
            TriggerClientEvent('ox_lib:notify', source, {title = Translate("insert_db"),type ='success'})
            if Framework == 'esx' then
                ESX.RefreshJobs()
            end
        end
    end
end)

RegisterNetEvent("e_gangcreator:EditGang",function (key,newValue,lastValue)
    local source = source
    if key == "name" then
        MySQL.update.await('UPDATE `jobs2` SET name = ? WHERE name = ?',{newValue,lastValue})
        MySQL.update.await('UPDATE `job2_grades` SET job_name = ? WHERE job_name  = ?',{newValue,lastValue})
        MySQL.update.await('UPDATE `addon_account` SET name = ? WHERE name = ?',{"gang_"..newValue,"gang_"..lastValue})
        MySQL.update.await('UPDATE `addon_account_data` SET account_name = ? WHERE account_name = ?',{"gang_"..newValue,"gang_"..lastValue})
        TriggerClientEvent('ox_lib:notify', source, {title = Translate("update_gang"),type ='success'})
    elseif key == "label" then
        MySQL.update.await('UPDATE `jobs2` SET label = ? WHERE name = ?',{newValue,lastValue})
        TriggerClientEvent('ox_lib:notify', source, {title = Translate("update_gang"),type ='success'})
    elseif key == "managePos" then
        MySQL.update.await('UPDATE `jobs2` SET manage_pos = ? WHERE name = ?',{json.encode(newValue),lastValue})
        TriggerClientEvent('ox_lib:notify', source, {title = Translate("update_gang"),type ='success'})
    elseif key == "stashPos" then
        MySQL.update.await('UPDATE `jobs2` SET stash_pos = ? WHERE name = ?',{json.encode(newValue),lastValue})
        TriggerClientEvent('ox_lib:notify', source, {title = Translate("update_gang"),type ='success'})
    elseif key == "stashPassword" then
        MySQL.update.await('UPDATE `jobs2` SET stash_password = ? WHERE name = ?',{newValue,lastValue})
        TriggerClientEvent('ox_lib:notify', source, {title = Translate("update_gang"),type ='success'})
    elseif key == "managePassword" then
        MySQL.update.await('UPDATE `jobs2` SET manage_password = ? WHERE name = ?',{newValue,lastValue})
        TriggerClientEvent('ox_lib:notify', source, {title = Translate("update_gang"),type ='success'})
    end
end)