RegisterCommand("gangcreator",function(source, args)
    local source = source
    if IsPlayerAceAllowed(source,"gangcreator") then
        TriggerClientEvent("o_gang_creator:openMenu",source)
    else
        TriggerClientEvent('ox_lib:notify', source, {title = Translate("notify_no_permissions"),type =  'warning'})
    end
end,true)