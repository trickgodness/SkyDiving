ESX = nil
local alreadyflying = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('moneycheckdiving', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.Price then
		xPlayer.removeMoney(Config.Price)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('isalreadysomeoneflying', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if alreadyflying then
		cb(alreadyflying)
	else
		cb(alreadyflying)
		Citizen.Wait(300)
		alreadyflying = true
	end
end)

RegisterServerEvent("flyinghasended")
AddEventHandler("flyinghasended", function()
	alreadyflying = false
end)
