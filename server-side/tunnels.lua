-- server-side/tunnels.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local src = {}
Tunnel.bindInterface(Config.ResourceName, src)
vCLIENT = Tunnel.getInterface(Config.ResourceName)

-- Função inicial de Handshake NUI -> Server
function src.vn_open_phone()
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return { ok = false, error = "Usuário não encontrado" } end

    if not vnServer.canOpenPhone(user_id) then
        return { ok = false, error = "Você não possui um celular" }
    end

    local identity = vRP.getUserIdentity(user_id)
    local phone = identity.phone
    
    vnServer.debug("Jogador " .. user_id .. " abriu o telefone.")

    return {
        ok = true,
        data = {
            user_id = user_id,
            name = identity.name .. " " .. identity.firstname,
            phone = phone,
            bankBalance = vRP.getBankMoney(user_id),
            unreadCounts = { whatsapp = 0, tinder = 0, instagram = 0 }
        }
    }
end

-- ============================================================
-- APP TELEFONE / CONTATOS
-- ============================================================
function src.vn_get_contacts()
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return { ok = false, error = "Não autorizado" } end
    local phone = vnServer.getPlayerPhone(user_id)
    if not phone then return { ok = true, data = {} } end

    local rows = vRP.query("vn_smartphone/contacts_select_by_owner", { owner = phone })
    return { ok = true, data = rows }
end

function src.vn_add_contact(payload)
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return { ok = false } end
    local phone = vnServer.getPlayerPhone(user_id)
    if not phone then return { ok = false, error = "Você não tem um número" } end

    vRP.execute("vn_smartphone/contacts_insert", { owner = phone, phone = payload.phone, name = payload.name })
    return { ok = true }
end

-- ============================================================
-- APP BANCO
-- ============================================================
function src.vn_get_bank()
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return { ok = false, error = "Não autorizado" } end
    
    local phone = vnServer.getPlayerPhone(user_id)
    local balance = vRP.getBankMoney(user_id)
    local statements = vRP.query("vn_smartphone/bank_select_statements", { phone = phone, limit = Config.PageSize })
    
    return { ok = true, data = { balance = balance, statements = statements } }
end

function src.vn_bank_transfer(payload)
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return { ok = false, error = "Não autorizado" } end
    
    local amount = tonumber(payload.amount)
    if not amount or amount <= 0 then return { ok = false, error = "Valor inválido" } end
    
    local target_id = tonumber(payload.targetId)
    if not target_id or target_id <= 0 then return { ok = false, error = "Passaporte inválido" } end
    
    if user_id == target_id then return { ok = false, error = "Você não pode transferir para si mesmo" } end
    
    local targetIdentity = vRP.getUserIdentity(target_id)
    if not targetIdentity then return { ok = false, error = "Passaporte não encontrado no sistema" } end
    
    local senderPhone = vnServer.getPlayerPhone(user_id) or tostring(user_id)
    local targetPhone = targetIdentity.phone or tostring(target_id)
    
    local bankBalance = vRP.getBankMoney(user_id)
    if bankBalance < amount then return { ok = false, error = "Saldo bancário insuficiente" } end
    
    vRP.setBankMoney(user_id, bankBalance - amount)
    vRP.giveBankMoney(target_id, amount)
    
    local time = vnServer.now()
    
    vRP.execute("vn_smartphone/bank_insert_statement", {
        pix = targetPhone,
        ["from"] = senderPhone,
        source = senderPhone,
        type = "transfer",
        amount = amount,
        reason = payload.reason or "Transferência via Passaporte",
        time = time
    })
    
    vnServer.logFinancial("💰 **PIX REALIZADO**\n\n**De:** ID "..user_id.." ("..senderPhone..")\n**Para:** ID "..target_id.." ("..targetPhone..")\n**Valor:** $"..amount)
    
    local target_source = vRP.getUserSource(target_id)
    if target_source then
        vCLIENT.vn_update_balance(target_source, vRP.getBankMoney(target_id))
        TriggerClientEvent("Notify", target_source, "sucesso", "Você recebeu um PIX de $"..amount.." do passaporte "..user_id)
    end
    
    vCLIENT.vn_update_balance(source, vRP.getBankMoney(user_id))
    
    return { ok = true, balance = vRP.getBankMoney(user_id) }
end

-- ============================================================
-- APP MENSAGENS (WHATSAPP)
-- ============================================================
function src.vn_get_chats()
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return { ok = false } end
    
    local phone = vnServer.getPlayerPhone(user_id)
    if not phone then return { ok = true, data = {} } end

    -- Busca canais onde eu sou o remetente ou o destinatário
    local channels = vRP.query("vn_smartphone/wpp_select_channels", { phone = phone })
    return { ok = true, data = channels }
end

function src.vn_get_messages(channel_id)
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return { ok = false } end

    local msgs = vRP.query("vn_smartphone/wpp_select_messages", { channel_id = channel_id, limit = Config.PageSize })
    
    -- Inverte a tabela em Lua para o NUI receber a mais antiga em cima e a mais nova embaixo
    local reversed = {}
    for i = #msgs, 1, -1 do table.insert(reversed, msgs[i]) end

    return { ok = true, data = reversed }
end

function src.vn_send_message(payload)
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return { ok = false } end
    
    local phone = vnServer.getPlayerPhone(user_id)
    local time = vnServer.now()

    vRP.execute("vn_smartphone/wpp_insert_message", {
        channel_id = payload.channel_id,
        sender = phone,
        content = payload.content,
        created_at = time
    })

    -- TODO: Aqui no futuro faremos a lógica de disparar TriggerClientEvent("vn_new_message") para o alvo se ele estiver online.
    
    return { ok = true }
end

-- Placeholders restantes
function src.vn_get_gallery() return { ok = true, data = {} } end
local function notImplemented() return { ok = false, error = "Em desenvolvimento" } end
src.vn_get_ig_feed = notImplemented
src.vn_get_tinder_profiles = notImplemented
src.vn_tor_get_messages = notImplemented
src.vn_olx_list = notImplemented
src.vn_weazel_list = notImplemented