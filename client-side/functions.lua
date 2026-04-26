-- client-side/functions.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

vnClient = {}
vnClient._isOpen = false

-- Abre a UI e trava o foco no mouse/teclado
function vnClient.openPhone(payload)
    if vnClient._isOpen then return end
    
    vnClient._isOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        action = "vn_open",
        data = payload
    })
    
    -- Futuro: tocar som de desbloqueio do iOS
    -- TriggerEvent("sounds:playSound", "iphone_lock")
end

-- Fecha a UI e libera o foco
function vnClient.closePhone()
    if not vnClient._isOpen then return end
    
    vnClient._isOpen = false
    SetNuiFocus(false, false)
    
    SendNUIMessage({
        action = "vn_close"
    })
end

-- Helper para leitura do estado
function vnClient.isPhoneOpen()
    return vnClient._isOpen
end

-- Wrapper de notificação
function vnClient.notify(type, message)
    TriggerEvent("Notify", type, message)
end

-- Placeholders para ringtones nativos
function vnClient.playRingtone()
    -- Em breve: lógica de xsound/interact-sound
end

function vnClient.stopRingtone()
    -- Em breve: parar áudio
end