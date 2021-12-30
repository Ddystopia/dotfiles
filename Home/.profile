# custom
[ -z ${XDG_CONFIG_HOME} ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z ${XDG_CACHE_HOME} ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z ${XDG_DATA_HOME} ] && export XDG_DATA_HOME="$HOME/.local/share"

export PATH="/home/ddystopia/.local/bin:/home/ddystopia/bin:$PATH"
export EDITOR=/usr/bin/nvim
export BROWSER=/usr/bin/qutebrowser
export TERM=/usr/bin/alacritty
export WALLPAPERS_DIR=/home/ddystopia/Media/wallpapers
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# export LIBGL_ALWAYS_SOFTWARE=1

# system
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export GTK_THEME="Kripton"
# source "$HOME/.cargo/env"
