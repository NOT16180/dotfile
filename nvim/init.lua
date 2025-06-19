-- Charge Lazy.nvim et la configuration de LazyVim
require("config.lazy")

-- Configuration générale pour l'indentation
vim.opt.autoindent = true -- Indentation automatique
vim.opt.smartindent = true -- Indentation intelligente selon la syntaxe
vim.opt.tabstop = 2 -- Largeur d'une tabulation
vim.opt.shiftwidth = 2 -- Largeur d'un niveau d'indentation
vim.opt.expandtab = true -- Convertit les tabulations en espaces
vim.opt.softtabstop = 2 -- Nombre d'espaces à insérer/supprimer avec Tab/Backspace
vim.opt.smarttab = true -- Tab intelligente selon le contexte
vim.opt.linebreak = true -- Coupe les lignes longues aux espaces
vim.opt.breakindent = true -- Indentation visuelle pour les lignes pliées

-- Options d'affichage améliorées
vim.opt.number = true -- Numéros de ligne
vim.opt.relativenumber = true -- Numéros de ligne relatifs
vim.opt.cursorline = true -- Surligne la ligne courante
vim.opt.signcolumn = "yes" -- Colonne des signes toujours visible
vim.opt.wrap = false -- Pas de retour à la ligne automatique
vim.opt.scrolloff = 8 -- Garde 8 lignes visibles au-dessus/en-dessous du curseur

-- Pour garder la mise en forme après un '=' de réindentation
vim.opt.preserveindent = true

-- Afficher un indicateur visuel au début des lignes repliées (utile avec breakindent)
vim.opt.showbreak = "↪ "

-- Améliore la gestion des espaces en fin de ligne (optionnel)
vim.opt.list = true -- Affiche les caractères invisibles (tabulations, espaces, etc.)
vim.opt.listchars = { tab = "→ ", trail = "·" }

-- Correcteur orthographique pour le français et l'anglais
vim.o.spell = true
vim.o.spelllang = "fr,en"

-- Suggestions de mappings pour indenter/désindenter visuellement
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Ajouter à votre init.lua pour mieux gérer les fichiers de swap

-- Configuration des fichiers de sauvegarde et de swap
vim.opt.swapfile = true -- Garde les fichiers de swap (recommandé pour la récupération)
vim.opt.backup = false -- Pas de fichiers de sauvegarde permanents
vim.opt.writebackup = false -- Pas de sauvegarde temporaire pendant l'écriture

-- Centraliser tous les fichiers temporaires dans des dossiers dédiés
local nvim_data = vim.fn.stdpath("data")
vim.opt.directory = nvim_data .. "/swap//" -- Fichiers de swap
vim.opt.backupdir = nvim_data .. "/backup//" -- Fichiers de sauvegarde
vim.opt.undodir = nvim_data .. "/undo//" -- Fichiers d'annulation

-- Créer les dossiers s'ils n'existent pas
local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

ensure_dir(nvim_data .. "/swap")
ensure_dir(nvim_data .. "/backup")
ensure_dir(nvim_data .. "/undo")

-- Activer l'historique d'annulation persistant
vim.opt.undofile = true

-- Gestion automatique des fichiers de swap en conflit
vim.api.nvim_create_autocmd("SwapExists", {
  callback = function()
    -- Options possibles :
    -- 'o' : ouvrir en lecture seule
    -- 'e' : éditer quand même (risqué)
    -- 'r' : récupérer les modifications depuis le swap
    -- 'q' : quitter
    -- 'd' : supprimer le fichier de swap

    -- Par défaut, ouvre en lecture seule pour éviter les conflits
    vim.v.swapchoice = "o"

    -- Afficher un message informatif
    vim.notify(
      "Fichier de swap détecté. Ouverture en lecture seule.\n"
        .. "Utilisez :recover pour récupérer ou :e! pour forcer l'édition.",
      vim.log.levels.WARN
    )
  end,
})

-- Commande pour nettoyer les anciens fichiers de swap
vim.api.nvim_create_user_command("CleanSwap", function()
  local swap_dir = nvim_data .. "/swap"
  local files = vim.fn.glob(swap_dir .. "/*", false, true)

  if #files == 0 then
    vim.notify("Aucun fichier de swap à nettoyer.", vim.log.levels.INFO)
    return
  end

  for _, file in ipairs(files) do
    vim.fn.delete(file)
  end

  vim.notify(string.format("Nettoyé %d fichier(s) de swap.", #files), vim.log.levels.INFO)
end, {
  desc = "Nettoie tous les anciens fichiers de swap",
})

-- Raccourci pour récupérer rapidement depuis un fichier de swap
vim.keymap.set("n", "<leader>sr", ":recover<CR>", {
  desc = "Récupérer depuis le fichier de swap",
})

-- Configuration pour afficher les messages d'erreur directement dans le code
-- À ajouter à votre init.lua

-- Configuration des diagnostics inline
vim.diagnostic.config({
  virtual_text = {
    enabled = true, -- Active le texte virtuel (messages inline)
    severity = nil, -- Affiche tous les niveaux de sévérité
    source = "if_many", -- Affiche la source si plusieurs sources sont disponibles
    format = nil, -- Utilise le format par défaut
    prefix = "●", -- Préfixe avant le message
    suffix = "", -- Suffixe après le message
    spacing = 4, -- Espacement entre le code et le message
  },
  signs = {
    enabled = true, -- Garde les signes dans la colonne de gauche
    priority = 20, -- Priorité des signes
  },
  underline = {
    enabled = true, -- Souligne les erreurs dans le code
    severity = { min = vim.diagnostic.severity.HINT }, -- Souligne tout
  },
  update_in_insert = false, -- Ne met pas à jour en mode insertion
  severity_sort = true, -- Trie par sévérité
  float = {
    enabled = true, -- Active les fenêtres flottantes pour plus de détails
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always", -- Toujours afficher la source
    header = "",
    prefix = "",
  },
})

-- Couleurs Gruvbox pour les diagnostics inline
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", {
  fg = "#fb4934", -- Rouge foncé (Gruvbox Red)
  italic = true,
})
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", {
  fg = "#fabd2f", -- Jaune doré (Gruvbox Yellow)
  italic = true,
})
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", {
  fg = "#83a598", -- Bleu-gris (Gruvbox Blue)
  italic = true,
})
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", {
  fg = "#b8bb26", -- Vert clair (Gruvbox Green)
  italic = true,
})

-- Raccourcis pour naviguer entre les erreurs
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
  desc = "Aller à l'erreur suivante",
})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
  desc = "Aller à l'erreur précédente",
})

-- Commandes pour basculer l'affichage des diagnostics inline
vim.api.nvim_create_user_command("DiagnosticsToggle", function()
  local current_config = vim.diagnostic.config()
  if current_config.virtual_text then
    vim.diagnostic.config({ virtual_text = false })
    vim.notify("Diagnostics inline désactivés", vim.log.levels.INFO)
  else
    vim.diagnostic.config({ virtual_text = true })
    vim.notify("Diagnostics inline activés", vim.log.levels.INFO)
  end
end, {
  desc = "Basculer l'affichage des diagnostics inline",
})

vim.api.nvim_create_user_command("DiagnosticsHide", function()
  vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false,
  })
  vim.notify("Tous les diagnostics masqués", vim.log.levels.INFO)
end, {
  desc = "Masquer tous les diagnostics",
})

vim.api.nvim_create_user_command("DiagnosticsShow", function()
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
  })
  vim.notify("Tous les diagnostics affichés", vim.log.levels.INFO)
end, {
  desc = "Afficher tous les diagnostics",
})

-- Raccourci pour basculer les diagnostics inline
vim.keymap.set("n", "<leader>dt", ":DiagnosticsToggle<CR>", {
  desc = "Basculer diagnostics inline",
})

-- Configuration spécifique pour certains types de fichiers
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "ocaml" },
  callback = function()
    -- Configuration plus agressive pour C/C++/OCaml

    local ns = vim.api.nvim_create_namespace("diagnostics_c_cpp_ocaml")
    vim.diagnostic.config({
      virtual_text = {
        enabled = true,
        spacing = 2,
        prefix = "▸",
      },
    }, ns)
  end,
})
