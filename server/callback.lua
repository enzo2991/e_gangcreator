lib.callback.register("o_gang_creator:getGangs",function()
    local listgangs = {}
    local gangs = MySQL.query.await('SELECT * FROM `jobs2` WHERE name != "unemployed"')
    for _,v in pairs(gangs) do
        local listgrades = MySQL.query.await('SELECT * FROM job2_grades WHERE job_name = ?',{v.name})
        local addonAccount = MySQL.single.await('SELECT money FROM addon_account_data WHERE account_name = ? LIMIT 1',{Config.prefix..v.name})
        v.grades = listgrades
        v.money = addonAccount.money
        listgangs[#listgangs+1] = v
    end
    return listgangs
end)