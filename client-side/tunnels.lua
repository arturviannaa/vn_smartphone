-- client-side/tunnels.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local src = {}
Tunnel.bindInterface(Config.ResourceName, src)
vSERVER = Tunnel.getInterface(Config.ResourceName)

-- Callbacks NUI com retorno obrigatório
RegisterNUICallback("vn_close", function(data, cb)
    vnClient.closePhone()
    cb({ ok = true }) -- Sempre retorne algo
end)

RegisterNUICallback("vn_ready", function(data, cb)
    cb({ ok = true })
end)

-- Proxies para as chamadas de banco/contatos/mensagens
RegisterNUICallback("vn_get_bank", function(data, cb) cb(vSERVER.vn_get_bank()) end)
RegisterNUICallback("vn_bank_transfer", function(data, cb) cb(vSERVER.vn_bank_transfer(data)) end)
RegisterNUICallback("vn_get_contacts", function(data, cb) cb(vSERVER.vn_get_contacts()) end)
RegisterNUICallback("vn_add_contact", function(data, cb) cb(vSERVER.vn_add_contact(data)) end)
RegisterNUICallback("vn_get_chats", function(data, cb) cb(vSERVER.vn_get_chats()) end)
RegisterNUICallback("vn_get_messages", function(data, cb) cb(vSERVER.vn_get_messages(data)) end)
RegisterNUICallback("vn_send_message", function(data, cb) cb(vSERVER.vn_send_message(data)) end)