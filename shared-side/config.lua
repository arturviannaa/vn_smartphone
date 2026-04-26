--[[
    shared-side/config.lua
    ----------------------
    Único ponto de configuração do resource. Tudo que pode mudar entre
    servidores/instâncias DEVE viver aqui. Nunca deixe valores mágicos
    espalhados em functions.lua ou main.lua.

    Acessível tanto no server quanto no client porque é shared_script.
]]

Config = {}

-- ============================================================
-- IDENTIDADE
-- ============================================================
Config.ResourceName = 'vn_smartphone'
Config.Version      = '0.1.0'
Config.Locale       = 'pt-BR'

-- ============================================================
-- ITEM E ABERTURA
-- ============================================================
-- Nome do item no inventário do vRP que representa o celular físico.
-- O jogador SÓ pode abrir o telefone se possuir este item.
Config.Item = 'celular'

-- Tecla padrão para abrir o celular (mapeamento INPUT_* do FiveM).
-- Lista de códigos: https://docs.fivem.net/docs/game-references/controls/
-- 288 = F1, 170 = F3, 311 = K, 47 = G, 244 = M
Config.OpenKey         = 311    -- F1 padrão
Config.OpenKeyLabel    = 'K'   -- usado em mensagens/UI ("aperte K")

-- Se true, o jogador precisa ter o item Config.Item no inventário.
-- Se false, qualquer player pode abrir o celular (modo dev/staff).
Config.RequireItem = true

-- ============================================================
-- LIMITES DE PERFORMANCE
-- ============================================================
-- Distância (em metros) máxima de outro jogador para que ele apareça
-- como "online" em apps que dependem de proximidade (ex.: descobrir
-- número de quem está perto). 0 = desabilitado.
Config.NearbyRadius = 0

-- Quantos itens carregar por página em listagens longas (Instagram feed,
-- WhatsApp histórico, OLX, etc). Evita estourar o NUI com 5000 rows.
Config.PageSize = 25

-- ============================================================
-- BANCO (NÃO MEXER NOS NOMES — vêm do dump legado)
-- ============================================================
-- Mantemos os nomes originais smartphone_* para reaproveitar os dados
-- existentes do servidor antigo. Se um dia migrar tudo, só trocar aqui.
Config.Tables = {
    bank_statements   = 'smartbank_statements',
    bank_invoices     = 'smartphone_bank_invoices',
    blocks            = 'smartphone_blocks',
    calls             = 'smartphone_calls',
    casino            = 'smartphone_casino',
    contacts          = 'smartphone_contacts',
    gallery           = 'smartphone_gallery',
    ifood_orders      = 'smartphone_ifood_orders',
    instagram         = 'smartphone_instagram',
    ig_followers      = 'smartphone_instagram_followers',
    ig_likes          = 'smartphone_instagram_likes',
    ig_notifications  = 'smartphone_instagram_notifications',
    ig_posts          = 'smartphone_instagram_posts',
    olx               = 'smartphone_olx',
    paypal            = 'smartphone_paypal_transactions',
    tinder            = 'smartphone_tinder',
    tinder_messages   = 'smartphone_tinder_messages',
    tinder_rating     = 'smartphone_tinder_rating',
    tor_messages      = 'smartphone_tor_messages',
    tor_payments      = 'smartphone_tor_payments',
    twitter_followers = 'smartphone_twitter_followers',
    twitter_likes     = 'smartphone_twitter_likes',
    twitter_profiles  = 'smartphone_twitter_profiles',
    twitter_tweets    = 'smartphone_twitter_tweets',
    uber_trips        = 'smartphone_uber_trips',
    weazel            = 'smartphone_weazel',
    whatsapp          = 'smartphone_whatsapp',
    wpp_channels      = 'smartphone_whatsapp_channels',
    wpp_groups        = 'smartphone_whatsapp_groups',
    wpp_messages      = 'smartphone_whatsapp_messages',
}

-- ============================================================
-- WEBHOOKS DISCORD (auditoria)
-- ============================================================
-- Deixe vazio "" para desabilitar. NUNCA comite URLs reais no git.
Config.Webhooks = {
    general   = '',  -- eventos gerais (abrir telefone, comprar item)
    financial = '',  -- transferências bancárias, pix
    moderation = '', -- denúncias, bloqueios, posts deletados
}

-- ============================================================
-- DEBUG
-- ============================================================
-- Quando true, imprime logs verbosos no console F8/server.log.
-- Manter false em produção.
Config.Debug = false
