-- server-side/functions.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

vnServer = {}

-- Retorna o número de telefone do usuário (vRP padrão)
function vnServer.getPlayerPhone(user_id)
    local identity = vRP.getUserIdentity(user_id)
    return identity and identity.phone or nil
end

-- Query reversa (útil para transferências via número de celular / PIX)
function vnServer.findUserIdByPhone(phone)
    local rows = vRP.query("vn_smartphone/get_user_by_phone", { phone = phone })
    if #rows > 0 then
        return rows[1].user_id or rows[1].id
    end
    return nil
end

-- Checa se o jogador tem o item em mãos (se Config.RequireItem = true)
function vnServer.canOpenPhone(user_id)
    if not Config.RequireItem then return true end
    return vRP.getInventoryItemAmount(user_id, Config.Item) >= 1
end

-- Timestamp helper
function vnServer.now()
    return os.time()
end

-- Logger console (só imprime se debug true)
function vnServer.debug(msg)
    if Config.Debug then
        print("^5[vn_smartphone:DEBUG]^7 " .. tostring(msg))
    end
end

-- Wrappers de Webhook
function vnServer.sendWebhook(url, title, msg, color)
    if url == nil or url == "" then return end
    local embed = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = msg,
            ["footer"] = { ["text"] = "vn_smartphone • " .. os.date("%d/%m/%Y %H:%M:%S") }
        }
    }
    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end

function vnServer.logFinancial(msg)
    vnServer.sendWebhook(Config.Webhooks.financial, "Movimentação Financeira", msg, 3066993) -- Verde
end

function vnServer.logGeneral(msg)
    vnServer.sendWebhook(Config.Webhooks.general, "Log Geral", msg, 15105570) -- Laranja
end