# prompt
PROMPT=" %F{14}%}%~ %{%F{9}%}%  %{%F{15}%}% "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# history
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="/home/evie/.histfile"
setopt inc_append_history

# preload aliases/shortcuts
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutenvrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutenvrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' '^ulfcd\n'

bindkey -s '^a' '^ubc -lq\n'

bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

# edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

alias :wq="exit"
alias :q="exit"
alias fetch="fastfetch --logo-color-1 red --logo-color-2 white"
alias untar="bsdtar -xvf"
alias unzip="bsdtar -xvf"
alias ls="ls --color=auto"
alias la="ls -a --color=auto"
alias ll="ls -l --color=auto"
alias lal="ls -al --color=auto"
alias start="start.sh"
alias iscreen="iscreenshot.sh"
alias xin="sudo xbps-install -S"
alias xre="sudo xbps-remove -R"
alias xup="sudo xbps-install -Su"
alias xclean="sudo xbps-remove -o"
alias xqu="xbps-query"
alias cfg="/home/evie/.config"
alias mc="musikcube"
alias temacs="emacs -nw"
alias scripts="/home/evie/scripts"
alias sign="sudo sbctl sign --save"
alias installgrub="sudo grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id='grub' --recheck --modules="tpm" --disable-shim-lock"
alias configgrub="grub-mkconfig -o /boot/grub/grub.cfg"
alias zshrc="nvim /home/evie/.zshrc"
alias bashrc="nvim /home/evie/.bashrc"
alias nvcfg="nvim /home/evie/.config/nvim/init.lua"
alias reload="exec $SHELL"
alias iscreen="iscreenshot.sh"
alias vpnoff="sudo wg-quick down wg0"
alias vpn="sudo wg-quick up wg0"


export EDITOR=nvim
export VISUAL="$EDITOR"
export PATH=$PATH:/home/evie/scripts/

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# load syntax highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
