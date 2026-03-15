
# Palette Gruvbox (Dark)
local FG_DARK_RED="#cc241d"
local FG_RED="#fb4934"
local FG_GREEN="#98971a"
local FG_LIGHT_GREEN="#b8bb26"
local FG_YELLOW="#d79921"
local FG_BROWN="#d65d0e"
local FG_BLUE="#458588"
local FG_PURPLE="#b16286"
local FG_PINK="#d3869b"
local FG_AQUA="#689d6a"
local FG_TEAL="#83a598"
local FG_ORANGE="#fe8019"
local FG_LIGHT_GRAY="#ebdbb2"
local FG_DARK_GRAY="#a89984"

# Highlighters
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
ZSH_HIGHLIGHT_STYLES[autodirectory]="fg=${FG_BLUE}"
ZSH_HIGHLIGHT_STYLES[assign]="fg=${FG_RED}"
ZSH_HIGHLIGHT_STYLES[comment]="fg=${FG_DARK_GRAY} italic"
ZSH_HIGHLIGHT_STYLES[redirection]="fg=${FG_DARK_RED}"

# Alias
ZSH_HIGHLIGHT_STYLES[alias]="fg=${FG_PINK}"
ZSH_HIGHLIGHT_STYLES[suffix-alias]="fg=${FG_PINK}"
ZSH_HIGHLIGHT_STYLES[global-alias]="fg=${FG_PINK}"

# Arguments et chemins
ZSH_HIGHLIGHT_STYLES[path]="fg=${FG_BLUE} underline"
ZSH_HIGHLIGHT_STYLES[path_prefix]="fg=${FG_BLUE}"
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
ZSH_HIGHLIGHT_STYLES[command-substitution]="fg=${FG_BLUE}"
ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]="fg=${FG_BLUE}"
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]="fg=${FG_BLUE}"
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]="fg=${FG_LIGHT_GRAY}"
ZSH_HIGHLIGHT_STYLES[process-substitution]="fg=${FG_BLUE}"
ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]="fg=${FG_PINK}"

# File descriptors et variables
ZSH_HIGHLIGHT_STYLES[named-fd]="fg=${FG_YELLOW}"
ZSH_HIGHLIGHT_STYLES[numeric-fd]="fg=${FG_YELLOW}"
ZSH_HIGHLIGHT_STYLES[parameter]="fg=${FG_BROWN}"
ZSH_HIGHLIGHT_STYLES[arg0]="fg=${FG_LIGHT_GRAY}"

# Brackets
ZSH_HIGHLIGHT_STYLES[bracket-error]="fg=${FG_DARK_RED} bold"
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]="fg=${FG_LIGHT_GREEN} bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-1]="fg=${FG_PINK} bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-2]="fg=${FG_BLUE} bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-3]="fg=${FG_PURPLE} bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-4]="fg=${FG_AQUA} bold"

# Expressions régulières
typeset -A ZSH_HIGHLIGHT_REGEXP
ZSH_HIGHLIGHT_REGEXP=()
ZSH_HIGHLIGHT_REGEXP+=('^\s*sudo\s+rm(\s|$)' "fg=${FG_LIGHT_GRAY} bold bg=${FG_RED}")
ZSH_HIGHLIGHT_REGEXP+=('^\s*rm\s+-rf(\s+/\s*|\s+\.\.\.?)?' "fg=${FG_LIGHT_GRAY} bold bg=${FG_RED}")
ZSH_HIGHLIGHT_REGEXP+=('^\s*rm\s+.+$' "fg=${FG_YELLOW} bg=${FG_RED}")
ZSH_HIGHLIGHT_REGEXP+=('\bsudo\b' "fg=${FG_YELLOW} bold underline")
ZSH_HIGHLIGHT_REGEXP+=('\bsu\b' "fg=${FG_YELLOW} bold underline")

# Patterns personnalisés
typeset -A ZSH_HIGHLIGHT_PATTERNS
ZSH_HIGHLIGHT_PATTERNS=()
ZSH_HIGHLIGHT_PATTERNS[git]="fg=${FG_PURPLE}"
ZSH_HIGHLIGHT_PATTERNS[make]="fg=${FG_GREEN}"
ZSH_HIGHLIGHT_PATTERNS[ssh]="fg=${FG_TEAL} underline"
ZSH_HIGHLIGHT_PATTERNS[exit]="fg=${FG_ORANGE} bold"

