local infogang = {}
RegisterNetEvent("o_gang_creator:openMenu",function()
    lib.registerContext({
        id = "o_gang_creator:openMenu",
        title = Translate("default_menu_title"),
        canClose = true,
        options = {
            {
                title = Translate("default_menu_option_creator"),
                arrow = true,
                event = "o_gang_creator:openCreatorMenu"
            },
            {
                title = Translate("default_menu_option_edit"),
                arrow = true,
                event = "o_gang_creator:openListGang"
            },
        }
    })

    lib.showContext("o_gang_creator:openMenu")
end)

RegisterNetEvent("o_gang_creator:openListGang",function()
    local gangs = {}
    local listgang = lib.callback.await('o_gang_creator:getGangs', false)


    for _,v in pairs(listgang) do
        gangs[#gangs+1] = {
            title = v.name,
            descriptions = Translate("gang_select_moneygang")..v.money,
            event = "o_gang_creator:openEditgang",
            metadata = {
                {label = Translate("metadata_label"), value = v.label},
                {label = Translate("metadata_money"), value = tostring(v.money)},
                {label = Translate("metadata_grade"), value = tostring(#v.grades)},
                {label = Translate("metadata_stash_password"), value = tostring(v.manage_password)},
                {label = Translate("metadata_manage_password"), value = tostring(v.stash_password)}
            },
            args = v,
        }
    end

    lib.registerContext({
        id = "listgang_menu",
        title = Translate("gang_select_title"),
        menu = "o_gang_creator:openMenu",
        options = gangs
    })

    lib.showContext("listgang_menu")
end)

RegisterNetEvent("o_gang_creator:openCreatorMenu",function()
    local buttonSendgang = true
    if infogang.name ~= nil and infogang.label ~= nil and infogang.managePos ~= nil and infogang.stashPos ~= nil and infogang.managePassword ~= nil and infogang.stashPassword ~= nil then
        buttonSendgang = false
    end

    lib.registerContext({
        id = "creatorgang_menu",
        title = Translate("gang_creator_title"),
        menu = "o_gang_creator:openMenu",
        onExit = function ()
            infogang = {}
        end,
        onBack = function ()
            infogang = {}
        end,
        options = {
            {
                title = Translate("name_gang"),
                description = infogang.name,
                onSelect = function()
                    local input = lib.inputDialog(Translate("name_gang"),{
                        {type = "input"}
                    })
                    if input then
                        infogang.name = input[1]
                    end
                    TriggerEvent("o_gang_creator:openCreatorMenu")
                end
            },
            {
                title = Translate("label_gang"),
                description = infogang.label,
                onSelect = function()
                    local input = lib.inputDialog(Translate("label_gang"),{
                        {type = "input"}
                    })
                    if input then
                        infogang.label = input[1]
                    end
                    TriggerEvent("o_gang_creator:openCreatorMenu")
                end
            },
            {
                title = Translate("manage_gang_pos"),
                description = tostring(infogang.managePos or ""),
                onSelect = function()
                    local playerId = PlayerPedId()
                    while true do
                        local posPlayer = GetEntityCoords(playerId)
                        lib.showTextUI(Translate("set_location"),{position = 'left-center'})
                        if IsControlPressed(1, 51) then
                            infogang.managePos = posPlayer
                            break
                        end
                        Wait(1)
                    end
                    lib.hideTextUI()
                    TriggerEvent("o_gang_creator:openCreatorMenu")
                end
            },
            {
                title = Translate("manage_gang_password"),
                description = tostring(infogang.managePassword or ""),
                onSelect = function()
                    local input = lib.inputDialog(Translate("manage_gang_password"),{
                        {type = "number", min = 1000, max = 9999, default = 1000}
                    })
                    if input then
                        infogang.managePassword = input[1]
                    end
                    TriggerEvent("o_gang_creator:openCreatorMenu")
                end
            },
            {
                title = Translate("stash_gang_pos"),
                description = tostring(infogang.stashPos or ""),
                onSelect = function()
                    local playerId = PlayerPedId()
                    while true do
                        local posPlayer = GetEntityCoords(playerId)
                        lib.showTextUI(Translate("set_location"),{
                            position = 'left-center'
                        })
                        if IsControlPressed(1, 51) then
                            infogang.stashPos = posPlayer
                            break
                        end
                        Wait(1)
                    end
                    lib.hideTextUI()
                    TriggerEvent("o_gang_creator:openCreatorMenu")
                end
            },
            {
                title = Translate("stash_gang_password"),
                description = tostring(infogang.stashPassword or ""),
                onSelect = function()
                    local input = lib.inputDialog(Translate("input_password_stash_gang"),{
                        {type = "number", min = 1000, max = 9999, default = 1000}
                    })
                    if input then
                        infogang.stashPassword = input[1]
                    end
                    TriggerEvent("o_gang_creator:openCreatorMenu")
                end
            },
            {
                title = Translate("create_gang"),
                onSelect = function()
                    TriggerServerEvent("e_gangcreator:createJob",infogang)
                    infogang = {}
                end,
                disabled = buttonSendgang
            },
        }
    })

    lib.showContext("creatorgang_menu")
end)

RegisterNetEvent("o_gang_creator:openEditgang",function(selectGang)
    infogang = selectGang

    infogang.managePos = infogang.manage_pos or infogang.managePos
    infogang.manage_pos = nil

    infogang.managePassword = infogang.manage_password or infogang.managePassword
    infogang.manage_password = nil

    infogang.stashPassword = infogang.stash_password or infogang.stashPassword
    infogang.stash_password = nil

    infogang.stashPos = infogang.stash_pos or infogang.stashPos
    infogang.stash_pos = nil

    lib.registerContext({
        id = "o_gang_creator:openEditSelectgang",
        title = Translate("default_menu_title"),
        onExit = function ()
            infogang = {}
        end,
        options = {
            {
                title = Translate("name_gang"),
                description = infogang.name,
                onSelect = function()
                    local lastValue = infogang.name
                    local input = lib.inputDialog(Translate("name_gang"),{
                        {type = "input"}
                    })
                    if input then
                        infogang.name = input[1]
                    end
                    TriggerServerEvent("e_gangcreator:EditGang","name",infogang.name,lastValue)
                    TriggerEvent("o_gang_creator:openEditgang",infogang)
                end
            },
            {
                title = Translate("label_gang"),
                description = infogang.label,
                onSelect = function()
                    local input = lib.inputDialog(Translate("label_gang"),{
                        {type = "input"}
                    })
                    if input then
                        infogang.label = input[1]
                    end
                    TriggerServerEvent("e_gangcreator:EditGang","label",infogang.label,infogang.name)
                    TriggerEvent("o_gang_creator:openEditgang",infogang)
                end
            },
            {
                title = Translate("manage_gang_pos"),
                description = tostring(infogang.managePos or ""),
                onSelect = function()
                    local playerId = PlayerPedId()
                    while true do
                        local posPlayer = GetEntityCoords(playerId)
                        lib.showTextUI(Translate("set_location"),{position = 'left-center'})
                        if IsControlPressed(1, 51) then
                            infogang.managePos = posPlayer
                            break
                        end
                        Wait(1)
                    end
                    lib.hideTextUI()
                    TriggerServerEvent("e_gangcreator:EditGang","managePos",infogang.managePos,infogang.name)
                    TriggerEvent("o_gang_creator:openEditgang",infogang)
                end
            },
            {
                title = Translate("manage_gang_password"),
                description = tostring(infogang.managePassword or ""),
                onSelect = function()
                    local input = lib.inputDialog(Translate("manage_gang_password"),{
                        {type = "number", min = 1000, max = 9999, default = 1000}
                    })
                    if input then
                        infogang.managePassword = input[1]
                    end
                    TriggerServerEvent("e_gangcreator:EditGang","managePassword",infogang.managePassword,infogang.name)
                    TriggerEvent("o_gang_creator:openEditgang",infogang)
                end
            },
            {
                title = Translate("stash_gang_pos"),
                description = tostring(infogang.stashPos or ""),
                onSelect = function()
                    local playerId = PlayerPedId()
                    while true do
                        local posPlayer = GetEntityCoords(playerId)
                        lib.showTextUI(Translate("set_location"),{
                            position = 'left-center'
                        })
                        if IsControlPressed(1, 51) then
                            infogang.stashPos = posPlayer
                            break
                        end
                        Wait(1)
                    end
                    lib.hideTextUI()
                    TriggerServerEvent("e_gangcreator:EditGang","stashPos",infogang.stashPos,infogang.name)
                    TriggerEvent("o_gang_creator:openEditgang",infogang)
                end
            },
            {
                title = Translate("stash_gang_password"),
                description = tostring(infogang.stashPassword or ""),
                onSelect = function()
                    local input = lib.inputDialog(Translate("input_password_stash_gang"),{
                        {type = "number", min = 1000, max = 9999, default = 1000}
                    })
                    if input then
                        infogang.stashPassword = input[1]
                    end
                    TriggerServerEvent("e_gangcreator:EditGang","stashPassword",infogang.stashPassword,infogang.name)
                    TriggerEvent("o_gang_creator:openEditgang",infogang)
                end
            },
        }
    })
    lib.showContext("o_gang_creator:openEditSelectgang")
end)

