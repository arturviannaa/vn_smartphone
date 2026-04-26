-- server-side/commands.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

RegisterCommand("celular_dar", function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id and vRP.hasPermission(user_id, "admin.permissao") then
        local target_id = tonumber(args[1]) or user_id
        vRP.giveInventoryItem(target_id, Config.Item, 1)
        TriggerClientEvent("Notify", source, "sucesso", "Celular entregue para o passaporte " .. target_id)
    end
end)

RegisterCommand("celular_remover", function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id and vRP.hasPermission(user_id, "admin.permissao") then
        local target_id = tonumber(args[1]) or user_id
        local amount = vRP.getInventoryItemAmount(target_id, Config.Item)
        if amount > 0 then
            vRP.tryGetInventoryItem(target_id, Config.Item, amount)
            TriggerClientEvent("Notify", source, "aviso", "Celular(es) removido(s) do passaporte " .. target_id)
        end
    end
end)

RegisterCommand("celular_debug", function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id and vRP.hasPermission(user_id, "admin.permissao") then
        Config.Debug = not Config.Debug
        local status = Config.Debug and "ATIVADO" or "DESATIVADO"
        TriggerClientEvent("Notify", source, "aviso", "Debug do vn_smartphone: " .. status)
    end
end)