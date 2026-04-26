-- server-side/main.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

-- Garante que o jogador tem o registro inicial em tabelas essenciais (ex: Wpp) ao spawnar
AddEventHandler('vRP:playerSpawn', function(user_id, source, first_spawn)
    if first_spawn then
        local phone = vnServer.getPlayerPhone(user_id)
        if phone then
            -- Exemplo: vRP.execute("vn_smartphone/wpp_ensure_profile", { phone = phone })
        end
    end
end)

-- Utilização do item pelo inventário (Fallback caso a thread do cliente falhe ou se a framework for baseada em uso de item estrito)
-- Funciona em vRPex nativo
vRP.defInventoryItem(Config.Item, "Telefone Celular", function(args)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        vCLIENT.vn_openPhone(source) -- Chamaremos o tunnel do client side (será feito no Passo 3)
    end
end)

-- TODO: Thread diária para envio de relatórios financeiros/webhooks consolidados.