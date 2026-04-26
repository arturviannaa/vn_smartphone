# 📱 vn_smartphone

> Smartphone com aparência e UX de **iPhone 17 Pro Max** para FiveM, construído sobre o framework **vRPex**.

Resource modular VN: backend Lua estritamente dividido em camadas (shared / server / client) e frontend NUI em **React + TypeScript + TailwindCSS + Zustand**, empacotado com **Vite**.

---

## 📑 Índice

1. [Status](#-status-do-projeto)
2. [Arquitetura](#%EF%B8%8F-arquitetura)
3. [Instalação](#-instalação)
4. [Configuração](#%EF%B8%8F-configuração)
5. [Banco de Dados](#-banco-de-dados)
6. [Comandos & Comunicação](#-comandos--comunicação-rpc)
7. [Apps Planejados](#-apps-planejados)
8. [Identidade Visual](#-identidade-visual)
9. [Convenções de Código](#-convenções-de-código)
10. [Roadmap](#%EF%B8%8F-roadmap)

---

## 🚦 Status do Projeto

| Camada | Status |
|---|---|
| Estrutura de pastas | ✅ Criada |
| `fxmanifest.lua` | ✅ |
| `shared-side/config.lua` | ✅ |
| `server-side/prepares.lua` | ⏳ Próximo passo |
| `server-side/functions.lua` | ⏳ |
| `server-side/tunnels.lua` | ⏳ |
| `server-side/commands.lua` | ⏳ |
| `server-side/main.lua` | ⏳ |
| `client-side/functions.lua` | ⏳ |
| `client-side/tunnels.lua` | ⏳ |
| `client-side/main.lua` | ⏳ |
| NUI (Vite + React) | ⏳ |
| Tela de Lock | ⏳ |
| Home Screen + Dock | ⏳ |
| Dynamic Island | ⏳ |
| App: Telefone | ⏳ |
| App: Mensagens (WhatsApp) | ⏳ |
| App: Banco | ⏳ |
| App: Câmera/Fotos | ⏳ |
| App: Instagram | ⏳ |
| App: Tinder | ⏳ |
| App: TOR (DarkChat) | ⏳ |
| App: OLX | ⏳ |
| App: Uber | ⏳ |
| App: iFood | ⏳ |
| App: Weazel News | ⏳ |
| App: Cassino | ⏳ |

---

## 🏛️ Arquitetura

```
vn_smartphone/
├── fxmanifest.lua              # Manifesto FiveM
├── README.md                   # Este arquivo
│
├── shared-side/
│   └── config.lua              # Toda configuração (item, tecla, tabelas, webhooks)
│
├── server-side/
│   ├── prepares.lua            # vRP._prepare de TODAS as queries SQL
│   ├── functions.lua           # vnServer.* (regras de negócio)
│   ├── tunnels.lua             # RPC client→server (entrada validada)
│   ├── commands.lua            # RegisterCommand (admin/dev)
│   └── main.lua                # Eventos vRP, threads de manutenção
│
├── client-side/
│   ├── functions.lua           # vnClient.* (helpers visuais)
│   ├── tunnels.lua             # RPC server→client (NUI updates)
│   └── main.lua                # Loop de tecla, abrir/fechar NUI
│
├── html/                       # ⚠️ Build do Vite cai aqui (NÃO editar à mão)
│   ├── index.html
│   └── assets/
│
└── nui/                        # 🎨 Projeto React/Vite (fonte da NUI)
    ├── src/
    │   ├── main.tsx
    │   ├── App.tsx
    │   ├── components/         # Phone, StatusBar, DynamicIsland, Dock...
    │   ├── apps/               # Cada app é uma pasta isolada
    │   ├── hooks/              # useNuiEvent, useNuiCallback, useTime
    │   ├── store/              # Zustand (estado global do telefone)
    │   ├── styles/             # globals.css, design tokens
    │   ├── utils/              # nui.ts (fetch wrapper), formatters
    │   └── types/              # Tipos compartilhados (DTOs do Lua)
    ├── public/
    ├── index.html
    ├── vite.config.ts
    ├── tailwind.config.js
    ├── tsconfig.json
    ├── package.json
    └── .gitignore
```

### Por que essa separação?

- **`nui/`** é o **código-fonte** da interface. Você desenvolve dentro dela.
- **`html/`** é o **resultado compilado** que o FiveM serve. Nunca edite manualmente.
- O `vite.config.ts` aponta `outDir: '../html'` para que `npm run build` despeje o resultado direto no lugar certo.

---

## 📥 Instalação

1. **Clone o resource** dentro de `resources/[vn]/vn_smartphone` (ou onde sua suíte VN viva).
2. **Adicione ao `server.cfg`:**
   ```cfg
   ensure vn_smartphone
   ```
3. **Cadastre o item `celular`** no banco do vRP (`vrp_items`) ou no arquivo de itens da sua framework.
4. **Build da NUI** (instruções em [`nui/README.md`](nui/README.md)):
   ```bash
   cd nui
   npm install
   npm run build
   ```
5. **Reinicie o resource:** `restart vn_smartphone`.

---

## ⚙️ Configuração

Todas as configurações vivem em [`shared-side/config.lua`](shared-side/config.lua).

| Campo | Descrição | Padrão |
|---|---|---|
| `Config.Item` | Nome do item no inventário | `'celular'` |
| `Config.OpenKey` | Código da tecla para abrir | `288` (F1) |
| `Config.OpenKeyLabel` | Label exibido em mensagens | `'F1'` |
| `Config.RequireItem` | Exige item no inventário? | `true` |
| `Config.PageSize` | Itens por página em listas | `25` |
| `Config.Webhooks.*` | URLs de webhook Discord | `''` |
| `Config.Debug` | Logs verbosos | `false` |

### Trocando a tecla de abertura

Edite `Config.OpenKey` com o código do FiveM controls. Exemplos:

| Tecla | Código |
|---|---|
| F1 | 288 |
| F3 | 170 |
| K | 311 |
| G | 47 |
| M | 244 |

Lista completa: <https://docs.fivem.net/docs/game-references/controls/>

---

## 🗄️ Banco de Dados

Reutilizamos o schema legado (prefixo `smartphone_*` + `smartbank_*`). Nenhuma tabela é renomeada — apenas estendida com colunas que precisarmos via `ALTER TABLE IF NOT EXISTS`.

Mapeamento centralizado em `Config.Tables`:

```lua
Config.Tables.contacts -- 'smartphone_contacts'
Config.Tables.calls    -- 'smartphone_calls'
-- etc.
```

> Sempre referencie tabelas via `Config.Tables.*` nas queries — nunca hardcode nomes.

---

## 📡 Comandos & Comunicação RPC

A definir conforme implementarmos. Todos os tunnels expostos vão respeitar:

- **Prefixo `vn_`** em callbacks NUI.
- **Validação no servidor** de todo input vindo do client/NUI.
- **Nunca confiar em valores numéricos** (preços, quantidades) enviados pela NUI.

---

## 🧩 Apps Planejados

Cada app vai viver isolado em `nui/src/apps/<nome>/` com seus próprios componentes, hooks e tipos. Todos partilham a casca (`PhoneFrame`, `StatusBar`, `DynamicIsland`).

| App | Tabelas envolvidas |
|---|---|
| Telefone | `smartphone_calls`, `smartphone_contacts`, `smartphone_blocks` |
| Mensagens (WhatsApp) | `smartphone_whatsapp*` |
| Banco | `smartbank_statements`, `smartphone_bank_invoices` |
| Câmera / Fotos | `smartphone_gallery` |
| Instagram | `smartphone_instagram*` |
| Tinder | `smartphone_tinder*` |
| TOR (DarkChat) | `smartphone_tor_messages`, `smartphone_tor_payments` |
| OLX | `smartphone_olx` |
| Uber | `smartphone_uber_trips` |
| iFood | `smartphone_ifood_orders` |
| Weazel News | `smartphone_weazel` |
| Twitter | `smartphone_twitter*` |
| Cassino | `smartphone_casino` |
| PayPal | `smartphone_paypal_transactions` |
| Configurações | (estado local) |

---

## 🎨 Identidade Visual

**Inspiração:** iPhone 17 Pro Max + iOS 18.

**Tokens-base** (a serem definidos no Tailwind):

- Fundo do device: gradiente preto vidro (Titanium Black)
- Frame do device: prata escuro com brilho sutil
- Aplicações: vidro fosco (backdrop-blur), bordas arredondadas 24px
- Acento VN: variável CSS `--vn-primary` (default: violeta `#6366F1`)
- Tipografia: `SF Pro Display` (fallback `Inter` → `system-ui`)
- Animações: spring physics via Framer Motion (transições nativas iOS)

**Características de iPhone 17 Pro Max:**
- Dynamic Island (área de notificações animada no topo)
- Status Bar com hora, sinal, bateria, wifi
- Home Screen com grid 4×6 de ícones + dock fixo de 4 apps
- Page indicator (pontinhos de paginação)
- Control Center (swipe down do canto superior direito)
- App Switcher (gesto de fechar swipe up)
- Lock screen com relógio gigante e notificações empilhadas

---

## 📐 Convenções de Código

### Lua

- Tabela global por camada: `vnServer` (server) e `vnClient` (client).
- Nomes de prepare em `snake_case` com namespace: `vn_smartphone/select_contacts`.
- Sempre `local source = source` no início de tunnels (evita shadowing).
- Nunca `RegisterNetEvent` exposto sem necessidade — use Tunnel.

### React / TypeScript

- Componentes em `PascalCase.tsx`.
- Hooks em `camelCase.ts` com prefixo `use`.
- Tipos compartilhados em `src/types/`.
- Acesso ao Lua sempre via `utils/nui.ts` → `fetchNui<T>(callback, payload)`.
- Eventos do Lua sempre via hook `useNuiEvent(action, handler)`.
- Estado global apenas em Zustand — evite prop drilling.

---

## 🛣️ Roadmap

### Fase 1 — Esqueleto (atual)
- [x] Estrutura de pastas
- [x] `fxmanifest.lua` + `config.lua`
- [ ] Camada server completa (prepares, functions, tunnels, commands, main)
- [ ] Camada client completa (functions, tunnels, main)
- [ ] Bootstrap do projeto NUI (Vite + React + TS + Tailwind + Zustand)

### Fase 2 — Casca do iPhone
- [ ] PhoneFrame (moldura do device com Dynamic Island)
- [ ] StatusBar (relógio, bateria, sinal)
- [ ] LockScreen (desbloqueio por swipe)
- [ ] HomeScreen + AppGrid + Dock
- [ ] Sistema de roteamento entre apps (sem react-router — gerenciado por store)
- [ ] Animações de abrir/fechar app (escala + opacity, mola iOS)

### Fase 3 — Apps essenciais
- [ ] Telefone (chamadas + contatos)
- [ ] Mensagens (WhatsApp)
- [ ] Banco (saldo + extrato + pix)
- [ ] Câmera + Fotos

### Fase 4 — Apps sociais
- [ ] Instagram (feed, post, perfis)
- [ ] Tinder
- [ ] Twitter
- [ ] Weazel News

### Fase 5 — Serviços
- [ ] Uber, iFood, OLX, TOR, Cassino, PayPal

### Fase 6 — Polimento
- [ ] Control Center
- [ ] Notificações empilhadas
- [ ] Som / haptics simulados
- [ ] Tema claro / escuro
- [ ] Wallpaper customizável

---

## 📜 Licença

VN Scripts — uso interno.
