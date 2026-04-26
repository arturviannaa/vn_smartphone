-- server-side/prepares.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

-- ============================================================
-- PREPARES
-- ============================================================
-- Identidade (Adaptado para o seu banco)
vRP._prepare("vn_smartphone/get_identity", "SELECT * FROM vrp_user_identities WHERE user_id = @user_id")

-- Reverse Lookup (Pega ID pelo Telefone para o Extrato)
vRP._prepare("vn_smartphone/get_user_by_phone", "SELECT user_id FROM vrp_user_identities WHERE phone = @phone")

-- Banco / Financeiro (Colunas exatas: pix, from, source, time)
vRP._prepare("vn_smartphone/bank_select_statements", "SELECT * FROM "..Config.Tables.bank_statements.." WHERE pix = @phone OR `from` = @phone ORDER BY time DESC LIMIT @limit")
vRP._prepare("vn_smartphone/bank_insert_statement", "INSERT INTO "..Config.Tables.bank_statements.." (pix, `from`, source, type, amount, reason, time) VALUES (@pix, @from, @source, @type, @amount, @reason, @time)")

-- Contatos
vRP._prepare("vn_smartphone/contacts_select_by_owner", "SELECT * FROM "..Config.Tables.contacts.." WHERE owner = @owner")
vRP._prepare("vn_smartphone/contacts_insert", "INSERT INTO "..Config.Tables.contacts.." (owner, phone, name) VALUES (@owner, @phone, @name)")
vRP._prepare("vn_smartphone/contacts_delete", "DELETE FROM "..Config.Tables.contacts.." WHERE id = @id AND owner = @owner")

-- WhatsApp (Canais e Mensagens)
vRP._prepare("vn_smartphone/wpp_select_channels", "SELECT * FROM "..Config.Tables.wpp_channels.." WHERE sender = @phone OR target = @phone")
vRP._prepare("vn_smartphone/wpp_select_messages", "SELECT * FROM "..Config.Tables.wpp_messages.." WHERE channel_id = @channel_id ORDER BY created_at DESC LIMIT @limit")
vRP._prepare("vn_smartphone/wpp_insert_message", "INSERT INTO "..Config.Tables.wpp_messages.." (channel_id, sender, content, created_at) VALUES (@channel_id, @sender, @content, @created_at)")