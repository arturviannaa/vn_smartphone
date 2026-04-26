-- server-side/prepares.lua
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local vRP = Proxy.getInterface("vRP")

-- ============================================================
-- INITIALIZE / MIGRATIONS
-- ============================================================
Citizen.CreateThread(function()
    -- Como estamos usando dump legado, as tabelas já existem.
    -- Futuros ALTER TABLE (ex: adicionar colunas novas) devem ser feitos aqui.
end)

-- ============================================================
-- PREPARES
-- ============================================================
-- Reverse Lookup
vRP._prepare("vn_smartphone/get_user_by_phone", "SELECT user_id FROM vrp_user_identities WHERE phone = @phone")

-- Banco / Financeiro
vRP._prepare("vn_smartphone/bank_select_statements", "SELECT * FROM "..Config.Tables.bank_statements.." WHERE pix = @phone OR `from` = @phone ORDER BY time DESC LIMIT @limit")
vRP._prepare("vn_smartphone/bank_insert_statement", "INSERT INTO "..Config.Tables.bank_statements.." (pix, `from`, source, type, amount, reason, time) VALUES (@pix, @from, @source, @type, @amount, @reason, @time)")

-- Contatos
vRP._prepare("vn_smartphone/contacts_select_by_owner", "SELECT * FROM "..Config.Tables.contacts.." WHERE owner = @owner")
vRP._prepare("vn_smartphone/contacts_insert", "INSERT INTO "..Config.Tables.contacts.." (owner, phone, name) VALUES (@owner, @phone, @name)")
vRP._prepare("vn_smartphone/contacts_update", "UPDATE "..Config.Tables.contacts.." SET name = @name, phone = @phone WHERE id = @id AND owner = @owner")
vRP._prepare("vn_smartphone/contacts_delete", "DELETE FROM "..Config.Tables.contacts.." WHERE id = @id AND owner = @owner")

-- WhatsApp
vRP._prepare("vn_smartphone/wpp_select_channels", "SELECT * FROM "..Config.Tables.wpp_channels.." WHERE sender = @phone OR target = @phone")
vRP._prepare("vn_smartphone/wpp_select_messages", "SELECT * FROM "..Config.Tables.wpp_messages.." WHERE channel_id = @channel_id ORDER BY created_at DESC LIMIT @limit")
vRP._prepare("vn_smartphone/wpp_insert_channel", "INSERT INTO "..Config.Tables.wpp_channels.." (sender, target) VALUES (@sender, @target)")
vRP._prepare("vn_smartphone/wpp_insert_message", "INSERT INTO "..Config.Tables.wpp_messages.." (channel_id, sender, content, created_at) VALUES (@channel_id, @sender, @content, @created_at)")

-- Ligações
vRP._prepare("vn_smartphone/calls_insert", "INSERT INTO "..Config.Tables.calls.." (initiator, target, duration, status, anonymous, created_at) VALUES (@initiator, @target, @duration, @status, @anonymous, @created_at)")
vRP._prepare("vn_smartphone/calls_select_history", "SELECT * FROM "..Config.Tables.calls.." WHERE initiator = @phone OR target = @phone ORDER BY created_at DESC LIMIT @limit")

-- Galeria
vRP._prepare("vn_smartphone/gallery_select", "SELECT * FROM "..Config.Tables.gallery.." WHERE user_id = @user_id ORDER BY created_at DESC")
vRP._prepare("vn_smartphone/gallery_insert", "INSERT INTO "..Config.Tables.gallery.." (user_id, folder, url, created_at) VALUES (@user_id, @folder, @url, @created_at)")
vRP._prepare("vn_smartphone/gallery_delete", "DELETE FROM "..Config.Tables.gallery.." WHERE id = @id AND user_id = @user_id")