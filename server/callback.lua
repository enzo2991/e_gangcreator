lib.callback.register("o_gang_creator:getGangs",function()
    local listgangs = {}
    local gangs = MySQL.query.await(Config.Queries.gangs.query)
    for _,v in pairs(gangs) do
        local listgrades = MySQL.query.await(Config.Queries.grade.query,{v.name})
        local addonAccount = MySQL.single.await(Config.Queries.money.query,{Config.Queries.money.prefix..v.name})
        v.grades = listgrades
        v.money = addonAccount.money
        listgangs[#listgangs+1] = v
    end
    return listgangs
end)