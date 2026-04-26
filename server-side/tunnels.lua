-- server-side/tunnels.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local src = {}
Tunnel.bindInterface(Config.ResourceName, src)
vCLIENT = Tunnel.getInterface(Config.ResourceName)

function src.vn_open_phone()
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return { ok = false } end

    if not vnServer.canOpenPhone(user_id) then
        return { ok = false, error = "Você não possui um celular" }
    end

    local identity = vRP.query("vn_smartphone/get_identity", { user_id = user_id })
    if not identity or #identity == 0 then return { ok = false } end
    
    local p = identity[1]
    return {
        ok = true,
        data = {
            user_id = user_id,
            name = p.nome .. " " .. p.sobrenome,
            phone = p.phone,
            bankBalance = vRP.getBankMoney(user_id),
            unreadCounts = { whatsapp = 0, tinder = 0, instagram = 0 }
        }
    }
end

-- BANCO (Transferência por ID)
function src.vn_bank_transfer(payload)
    local source = source
    local user_id = vRP.getUserId(source)
    local target_id = tonumber(payload.targetId)
    local amount = tonumber(payload.amount)

    if not target_id or not amount or amount <= 0 or user_id == target_id then 
        return { ok = false, error = "Dados inválidos" } 
    end

    local myBalance = vRP.getBankMoney(user_id)
    if myBalance < amount then return { ok = false, error = "Saldo insuficiente" } end

    local target_identity = vRP.query("vn_smartphone/get_identity", { user_id = target_id })
    if #target_identity == 0 then return { ok = false, error = "ID não encontrado" } end

    -- Processa transferência
    vRP.setBankMoney(user_id, myBalance - amount)
    vRP.giveBankMoney(target_id, amount)

    -- Registra no extrato (Usa telefones para compatibilidade com o histórico)
    local myPhone = vnServer.getPlayerPhone(user_id)
    local targetPhone = target_identity[1].phone
    
    vRP.execute("vn_smartphone/bank_insert_statement", {
        pix = targetPhone,
        from = myPhone,
        source = myPhone,
        type = "transfer",
        amount = amount,
        reason = "Transferência via ID "..user_id,
        time = vnServer.now()
    })

    return { ok = true, balance = vRP.getBankMoney(user_id) }
end

function src.vn_get_bank()
    local source = source
    local user_id = vRP.getUserId(source)
    local phone = vnServer.getPlayerPhone(user_id)
    local balance = vRP.getBankMoney(user_id)
    local stats = vRP.query("vn_smartphone/bank_select_statements", { phone = phone, limit = 15 })
    return { ok = true, data = { balance = balance, statements = stats } }
end

-- CONTATOS
function src.vn_get_contacts()
    local user_id = vRP.getUserId(source)
    local phone = vnServer.getPlayerPhone(user_id)
    local rows = vRP.query("vn_smartphone/contacts_select_by_owner", { owner = phone })
    return { ok = true, data = rows }
end

function src.vn_add_contact(payload)
    local user_id = vRP.getUserId(source)
    local phone = vnServer.getPlayerPhone(user_id)
    vRP.execute("vn_smartphone/contacts_insert", { owner = phone, phone = payload.phone, name = payload.name })
    return { ok = true }
end

-- WHATSAPP
function src.vn_get_chats()
    local user_id = vRP.getUserId(source)
    local phone = vnServer.getPlayerPhone(user_id)
    local rows = vRP.query("vn_smartphone/wpp_select_channels", { phone = phone })
    return { ok = true, data = rows }
end

function src.vn_get_messages(payload)
    local msgs = vRP.query("vn_smartphone/wpp_select_messages", { channel_id = payload.channel_id, limit = 20 })
    return { ok = true, data = msgs }
end

function src.vn_send_message(payload)
    local user_id = vRP.getUserId(source)
    local phone = vnServer.getPlayerPhone(user_id)
    vRP.execute("vn_smartphone/wpp_insert_message", { channel_id = payload.channel_id, sender = phone, content = payload.content, created_at = vnServer.now() })
    return { ok = true }
end