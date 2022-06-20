ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(0)
    end

end)

function DrawText3D(x, y, z, text, scale)
    SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

-----# NPC Thread

local Kordinat = {

    {Config.NPCCord.x,Config.NPCCord.y,Config.NPCCord.z, "Sky",Config.NPCHeading,Config.NPCHash,Config.NPCModel},
}
  
  
Citizen.CreateThread(function()
  
    for _,v in pairs(Kordinat) do
        RequestModel(GetHashKey(v[7]))
        while not HasModelLoaded(GetHashKey(v[7])) do
          Wait(1)
        end
    
        RequestAnimDict("anim@heists@heist_corona@single_team")
        while not HasAnimDictLoaded("anim@heists@heist_corona@single_team") do
          Wait(1)
        end
        ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
        SetEntityHeading(ped, v[5])
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskPlayAnim(ped,"anim@heists@heist_corona@single_team","single_team_loop_boss", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local distance = GetDistanceBetweenCoords(Config.NPCCord, playerCoords, true)
        if distance <= 2.0 then
            DrawText3D(Config.NPCCord.x, Config.NPCCord.y, Config.NPCCord.z+1.0,Config.Text)
            if IsControlJustPressed(1, 38) then
                ESX.TriggerServerCallback('moneycheckdiving', function(money)
                    if money then
                        GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), true)
                        DoScreenFadeOut(4000)
                        Citizen.Wait(4000)
                        ESX.Game.SpawnLocalVehicle('dodo', vector3(2420.75, 5574.31, 1570.84), 178.31, function(vehicle)
                            local distanceToTarget = #(playerCoords - GetEntityCoords(vehicle))
                            SetPedIntoVehicle(player, vehicle, 2)
                            driver = CreatePedInsideVehicle(vehicle, 26, 'csb_jackhowitzer', -1, true, false)
                            SetDriverAbility(driver, 1.0)
                            SetDriverAggressiveness(driver, 0.0)
                            TaskVehicleDriveToCoord(driver, vehicle, 1201.69, 2700.12, 1450.0, 230.0, 0, 1341619767, 4457279, 1, true)
                            Citizen.Wait(60000)
                            TaskLeaveVehicle(player, vehicle, 64)
                            Citizen.Wait(10000)
                            ESX.Game.DeleteVehicle(vehicle)
                            DeletePed(driver)
                        end)
                        Citizen.Wait(4000)
                        DoScreenFadeIn(4000)
                    else
                        exports['mythic_notify']:DoHudText('error', Config.NoMoney)
                    end
                end)
            end
        else
            Citizen.Wait(100)
        end

    end

end)

Citizen.CreateThread(function()

    if Config.Blip then
        blip = AddBlipForCoord(Config.NPCCord.x, Config.NPCCord.y, Config.NPCCord.z)
        SetBlipSprite(blip, Config.BlipID)
        SetBlipDisplay(blip, 4) 
        SetBlipScale(blip, Config.BlipScale)
        SetBlipColour(blip, Config.BlipColour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.BlipName)
        EndTextCommandSetBlipName(blip)

    end
end)
