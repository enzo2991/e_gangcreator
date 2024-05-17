if Config.useStash then
    Citizen.CreateThread(function ()
        if GetResourceState("e_gangcreator_stash")  == "started" then
            StopResource("e_gangcreator_stash")
            Citizen.Wait(1000)
            StartResource("e_gangcreator_stash")
        else 
            StartResource("e_gangcreator_stash")
        end
    end)
end