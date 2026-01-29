# Palette Gruvbox (sans bleu)
local FG_RED="#fb4934"
local FG_YELLOW="#fabd2f"
local FG_ORANGE="#fe8019"
local FG_GREEN="#8ec07c"
local FG_LIGHT_GREEN="#b8bb26"
local FG_PINK="#d3869b"
local FG_TEAL="#83a598"
local FG_LIGHT_GRAY="#ebdbb2"
local FG_PURPLE="#b16286"
local FG_AQUA="#689d6a"
local FG_BROWN="#d79921"
local FG_DARK_RED="#cc241d"

# Highlighters activés
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern regexp)

# Styles principaux
ZSH_HIGHLIGHT_STYLES[default]="fg=${FG_LIGHT_GRAY}"
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=${FG_RED} bold"
ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=${FG_YELLOW}"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=${FG_GREEN}"
ZSH_HIGHLIGHT_STYLES[function]="fg=${FG_GREEN}"
ZSH_HIGHLIGHT_STYLES[command]="fg=${FG_LIGHT_GREEN}"
ZSH_HIGHLIGHT_STYLES[precommand]="fg=${FG_ORANGE}"
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=${FG_LIGHT_GRAY}"
ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=${FG_GREEN}"

# Alias
ZSH_HIGHLIGHT_STYLES[alias]="fg=${FG_PINK}"
ZSH_HIGHLIGHT_STYLES[suffix-alias]="fg=${FG_PINK}"
ZSH_HIGHLIGHT_STYLES[global-alias]="fg=${FG_PINK}"

# Arguments et chemins
ZSH_HIGHLIGHT_STYLES[path]="fg=${FG_TEAL} underline"
ZSH_HIGHLIGHT_STYLES[path_prefix]="fg=${FG_TEAL}"
ZSH_HIGHLIGHT_STYLES[path_pathseparator]="fg=${FG_LIGHT_GRAY}"
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]="fg=${FG_LIGHT_GRAY}"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=${FG_PINK}"
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=${FG_TEAL}"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=${FG_ORANGE}"

# Quotes et expansions
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=${FG_GREEN}"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=${FG_LIGHT_GREEN}"
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="fg=${FG_GREEN}"
ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=${FG_RED}"
ZSH_HIGHLIGHT_STYLES[command-substitution]="fg=${FG_GREEN}"
ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]="fg=${FG_GREEN}"
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]="fg=${FG_GREEN}"
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]="fg=${FG_LIGHT_GRAY}"
ZSH_HIGHLIGHT_STYLES[process-substitution]="fg=${FG_GREEN}"
ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]="fg=${FG_PINK}"

# Redirections, assignations, commentaires
ZSH_HIGHLIGHT_STYLES[assign]="fg=${FG_RED}"
ZSH_HIGHLIGHT_STYLES[redirection]="fg=${FG_RED}"
ZSH_HIGHLIGHT_STYLES[comment]="fg=${FG_LIGHT_GRAY}"

# File descriptors
ZSH_HIGHLIGHT_STYLES[named-fd]="fg=${FG_YELLOW}"
ZSH_HIGHLIGHT_STYLES[numeric-fd]="fg=${FG_YELLOW}"

# Paramètres et valeurs
ZSH_HIGHLIGHT_STYLES[arg0]="fg=${FG_LIGHT_GRAY}"
ZSH_HIGHLIGHT_STYLES[parameter]="fg=${FG_BROWN}"

# Brackets (remplacement du bleu)
ZSH_HIGHLIGHT_STYLES[bracket-error]="fg=${FG_DARK_RED} bold"
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]="fg=${FG_LIGHT_GREEN} bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-1]="fg=${FG_PINK} bold"    # Était bleu -> rose
ZSH_HIGHLIGHT_STYLES[bracket-level-2]="fg=${FG_BROWN} bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-3]="fg=${FG_PURPLE} bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-4]="fg=${FG_AQUA} bold"

# Patterns personnalisés dangereux
typeset -A ZSH_HIGHLIGHT_REGEXP
ZSH_HIGHLIGHT_REGEXP=()
# sudo rm
ZSH_HIGHLIGHT_REGEXP+=('^\s*sudo\s+rm(\s|$)' "fg=${FG_LIGHT_GRAY} bold bg=${FG_RED}")
# rm -rf / ou rm -rf .*
ZSH_HIGHLIGHT_REGEXP+=('^\s*rm\s+-rf(\s+/\s*|\s+\.\.\.?)?' "fg=${FG_LIGHT_GRAY} bold bg=${FG_RED}")
# rm *
ZSH_HIGHLIGHT_REGEXP+=('^\s*rm\s+.+$' "fg=${FG_YELLOW} bg=${FG_RED}")
# sudo ou su en solo
ZSH_HIGHLIGHT_REGEXP+=('\bsudo\b' "fg=${FG_YELLOW} bold underline")
ZSH_HIGHLIGHT_REGEXP+=('\bsu\b' "fg=${FG_YELLOW} bold underline")

# Patterns personnalisés à adapter
typeset -A ZSH_HIGHLIGHT_PATTERNS
ZSH_HIGHLIGHT_PATTERNS=()
