-- client-side/tunnels.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local src = {}
Tunnel.bindInterface(Config.ResourceName, src)
vSERVER = Tunnel.getInterface(Config.ResourceName)

-- ============================================================
-- EVENTOS DO SERVER -> PARA A NUI
-- ============================================================
function src.vn_incoming_call(payload)
    SendNUIMessage({ action = "vn_incoming_call", data = payload })
end

function src.vn_new_message(payload)
    SendNUIMessage({ action = "vn_new_message", data = payload })
end

function src.vn_notification(payload)
    SendNUIMessage({ action = "vn_notification", data = payload })
end

function src.vn_update_balance(value)
    SendNUIMessage({ action = "vn_update_balance", data = value })
end

-- ============================================================
-- EVENTOS DA NUI -> PARA O CLIENT (Callbacks)
-- ============================================================

-- Quando o jogador aperta o botão "Home" do celular ou sai do app
RegisterNUICallback("vn_close", function(data, cb)
    vnClient.closePhone()
    cb({ ok = true })
end)

-- Handshake inicial de que a NUI montou o React (útil para preload)
RegisterNUICallback("vn_ready", function(data, cb)
    -- NUI está pronta
    cb({ ok = true })
end)

-- Listener de escape caso a NUI perca o foco (segurança extra)
RegisterNUICallback("vn_escape", function(data, cb)
    vnClient.closePhone()
    cb({ ok = true })
end)