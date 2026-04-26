-- server-side/functions.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

vnServer = {}

function vnServer.getPlayerPhone(user_id)
    local identity = vRP.query("vn_smartphone/get_identity", { user_id = user_id })
    return (identity and identity[1]) and identity[1].phone or nil
end

function vnServer.findUserIdByPhone(phone)
    local rows = vRP.query("vn_smartphone/get_user_by_phone", { phone = phone })
    if #rows > 0 then return rows[1].user_id end
    return nil
end

function vnServer.canOpenPhone(user_id)
    if not Config.RequireItem then return true end
    return vRP.getInventoryItemAmount(user_id, Config.Item) >= 1
end

function vnServer.now() return os.time() end

function vnServer.debug(msg)
    if Config.Debug then print("^5[vn_smartphone]^7 " .. tostring(msg)) end
end

function vnServer.sendWebhook(url, title, msg, color)
    if not url or url == "" then return end
    local embed = {{ ["color"] = color, ["title"] = title, ["description"] = msg, ["footer"] = { ["text"] = "vn_smartphone • " .. os.date("%d/%m/%Y") } }}
    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end