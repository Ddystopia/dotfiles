# custom
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Media/Music"
export XDG_PICTURES_DIR="$HOME/Media/Pictures"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_VIDEOS_DIR="$HOME/Media/Videos"

export PATH="$XDG_CONFIG_HOME/cargo/bin:$HOME/.local/bin:$HOME/bin:$PATH"
export EDITOR=/usr/bin/nvim
export BROWSER=/usr/bin/qutebrowser
export TERM=/usr/bin/alacritty
export WALLPAPERS_DIR=/home/ddystopia/Media/wallpapers
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export LESSHISTFILE=-
export LD="mold"

export MANPAGER='nvim +Man!'
export MANWIDTH=200

export RUSTC_WRAPPER=/path/to/sccache
export CARGO_HOME="$XDG_CONFIG_HOME/cargo"
export MOZ_HOME="$HOME/.config/mozilla"

export _JAVA_AWT_WM_NONREPARENTING=1

# export LIBGL_ALWAYS_SOFTWARE=1

export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export GTK2_RC_FILES="$HOME/.local/share/themes/Kripton/gtk-2.0/gtkrc"
export GTK_THEME="Kripton"
