-- client-side/main.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

Citizen.CreateThread(function()
    while true do
        -- Justificativa da performance: Como usamos IsControlJustPressed, 
        -- precisamos de um idle de 5ms para não "perder" o frame do input do jogador.
        -- O peso no resmon é praticamente nulo (0.00ms) por não executar operações complexas.
        local idle = 5 

        if not vnClient.isPhoneOpen() then
            -- Aguardando a tecla para abrir o telefone
            if IsControlJustPressed(0, Config.OpenKey) then
                -- Solicita os dados iniciais do telefone (saldo, número, notificações) síncrono
                local res = vSERVER.vn_open_phone()
                if res then
                    if res.ok then
                        vnClient.openPhone(res.data)
                    else
                        vnClient.notify("negado", res.error or "Erro ao abrir o celular.")
                    end
                end
            end
        else
            -- Telefone aberto: Bloqueia as ações essenciais para não "socar" o ar 
            -- ou virar a câmera bruscamente enquanto clica na tela.
            DisableControlAction(0, 1, true)   -- LookLeftRight
            DisableControlAction(0, 2, true)   -- LookUpDown
            DisableControlAction(0, 24, true)  -- Attack
            DisableControlAction(0, 25, true)  -- Aim
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisablePlayerFiring(PlayerId(), true) -- Bloqueia disparo com armas

            -- Desabilita a tecla ESC/Pausa para evitar conflitos com o cursor da NUI
            DisableControlAction(0, 200, true) -- ESC (pause menu)
            DisableControlAction(0, 322, true) -- ESC (alternative)

            -- Fallback client-side para fechar o telefone (ESC, Backspace ou RMB dependendo do config)
            if IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(0, 322) or IsControlJustPressed(0, 177) then
                vnClient.closePhone()
            end
        end

        Citizen.Wait(idle)
    end
end)

-- Tratamento de segurança: se o dev der "ensure vn_smartphone" enquanto o telefone está aberto,
-- garante que o mouse será destravado, evitando soft-lock na tela do jogador.
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if vnClient.isPhoneOpen() then
            SetNuiFocus(false, false)
        end
    end
end)