#
# Author: David Oniani
#
#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|
#

# Functions {{{

# Change directory on quit
nnn_autocd() {
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        printf "nnn is already running\n"
        return
    fi
  
    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
  
    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef
  
    nnn "$@"
  
    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# Print the color map
function colormap() {
    for i in {0..255}; do
        print -Pn "%${i}F${(l:3::0:)i}%f " ${${(M)$((i%8)):#7}:+$'\n'};
    done
}

# }}}

# Aliases {{{

# Core commands
alias :q="exit"
alias grep="grep --color=auto"
alias l="ls -A"
alias ll="ls -Ahl"
alias icat="kitty +kitten icat"

# Interactive
alias e="nvim"
alias m="ncmpcpp --quiet"
alias news="newsboat --quiet"
alias ssh="kitty +kitten ssh"

# Safer commands
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# }}}

# Z Shell Settings {{{

# Set the prompt
PS1="%F{#bd93f9}%c %F{#e2637f}$%F{reset_color} "

# Load and enable colors
autoload -Uz colors && colors

# Load and enable completion
autoload -Uz compinit && compinit -d \
  "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump_$ZSH_VERSION"

# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

# Completion settings
zstyle ":completion:*" accept-exact-dirs true
zstyle ":completion:*" insert-tab false
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ":completion:*" list-dirs-first true
zstyle ":completion:*" menu select

# Case/hyphen-insensitive autocompletion (à la Oh My Zsh)
zstyle ":completion:*" matcher-list "m:{a-zA-Z-_}={A-Za-z_-}" "r:|=*" "l:|=* r:|=*"

# Complete aliases
setopt COMPLETE_ALIASES

# Complete dotfiles
setopt GLOBDOTS

# History settings
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt EXTENDED_HISTORY        # Add timestamps
setopt HIST_EXPIRE_DUPS_FIRST  # Remove duplicates first if over HISTSIZE
setopt INC_APPEND_HISTORY      # Save commands in the order of execution

# }}}

# Z Shell Vi Mode and Widgets {{{

# Enable Vi mode on the commmand line
bindkey -v

# Add missing Vim hotkeys
# Confer http://zshwiki.org/home/zle/vi-mode
bindkey -a u undo                  # u for undo
bindkey -a "^r" redo               # CTRL + r to redo
bindkey "^?" backward-delete-char  # Backspace

# History search in Vi mode
# Adapted from the following link
# http://zshwiki.org./home/zle/bindkeys#why_isn_t_control-r_working_anymore
# CTRL + h to search history
bindkey -M vicmd "^h" history-incremental-search-backward
bindkey -M viins "^h" history-incremental-search-backward

# No delay entering normal mode
# Confer https://coderwall.com/p/h63etq
# Confer https://github.com/pda/dotzsh/blob/master/keyboard.zsh#L10
#
# The time the shell waits, in hundredths of seconds, for another key
# to be pressed when reading bound multi-character sequences.
#
# Set to shortest possible delay is 1/100 second (10ms).
# This allows escape sequences like cursor/arrow keys to work,
# while eliminating the delay exiting Vi insert mode.
KEYTIMEOUT=1

# Use Vi keys in tab complete menu
zmodload zsh/complist
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "j" vi-down-line-or-history
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char

# Edit command in Vim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^e" edit-command-line
bindkey -M viins "^e" edit-command-line

# Change cursor shape based on the Vi mode
zle-keymap-select() {
    case $KEYMAP in
        # Normal mode
        vicmd) echo -ne "\e[1 q";;

        # Insert mode
        viins|main) echo -ne "\e[5 q";;
    esac
}

zle-line-init() {
    # Initiate `vi insert` as keymap
    # NOTE: Can be removed if `bindkey -V` has been set elsewhere
    zle -K viins
    echo -ne "\e[5 q"
}

zle -N zle-keymap-select
zle -N zle-line-init

# }}}

# Key Bindings {{{

# Key binding for nnn
bindkey -s "^f" "nnn_autocd\n"

# Key binding for IPython
bindkey -s "^p" "ipython\n"

# Key binding for fg
bindkey -s "^z" "fg\n"

# }}}

# Sourcing {{{

# Source Fish-like autocompletions for activation
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugin/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Source zsh syntax highlighting for activation
source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugin/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# }}}
