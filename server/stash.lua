if Config.useStash then
    function RestartScriptStash()
        local nameRessource = Config.ressourceStashName
        if GetResourceState(nameRessource)  == "started" then
            StopResource(nameRessource)
            Citizen.Wait(1000)
            StartResource(nameRessource)
        else 
            StartResource(nameRessource)
        end
    end
end