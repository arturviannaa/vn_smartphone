--[[
    vn_smartphone — Smartphone iPhone-like para vRPex
    ---------------------------------------------------
    Manifesto principal do resource. Declara:
      • Dependência da framework vrp (utils + Tunnel/Proxy)
      • Ordem de carregamento dos arquivos modulares (shared → server → client)
      • Página NUI (index.html buildado pelo Vite na pasta html/)

    REGRA: a ordem dos scripts é importante. prepares ANTES de functions,
    functions ANTES de tunnels, e tunnels ANTES de main — porque main pode
    consumir qualquer função declarada nas camadas anteriores.
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author       'VN Scripts'
description  'Smartphone iPhone-like para vRPex (vn_smartphone)'
version      '0.1.0'

-- Página NUI servida ao client. Após buildar a NUI, o Vite gera html/index.html.
ui_page 'html/index.html'

-- Shared (config + utilitários do vrp)
shared_scripts {
    '@vrp/lib/utils.lua',
    'shared-side/config.lua'
}

-- Server (ordem importa: prepares → functions → tunnels → commands → main)
server_scripts {
    'server-side/prepares.lua',
    'server-side/functions.lua',
    'server-side/tunnels.lua',
    'server-side/commands.lua',
    'server-side/main.lua'
}

-- Client (functions antes de tunnels e main)
client_scripts {
    'client-side/functions.lua',
    'client-side/tunnels.lua',
    'client-side/main.lua'
}

-- Arquivos servidos para a NUI. O glob assets/* pega tudo que o Vite gera
-- (JS, CSS, imagens, fonts) dentro de html/assets/.
files {
    'html/index.html',
    'html/assets/*',
    'html/assets/**/*'
}
