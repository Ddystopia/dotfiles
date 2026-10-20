# custom
_envd_gen=/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator
if _envd_out=$("$_envd_gen"); then
    eval "$(printf '%s\n' "$_envd_out" | sed 's/^/export /')"
else
    _envd_msg="~/.profile: $_envd_gen failed (exit $?), environment.d not imported"
    echo "$_envd_msg" >&2
    logger -t profile -p user.warning "$_envd_msg" 2>/dev/null
fi
unset _envd_gen _envd_out _envd_msg

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:$PATH"
export EDITOR=/usr/bin/nvim
export BROWSER=/usr/bin/qutebrowser
export TERM=/usr/bin/alacritty
export WALLPAPERS_DIR=/home/ddystopia/Media/wallpapers
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export LESSHISTFILE=-
export LD="mold"

export CLAUDE_CODE_MAX_WEB_SEARCHES_PER_SESSION=1000

export MANPAGER='nvim +Man!'
export MANWIDTH=100

# export RUSTC_WRAPPER=/home/ddystopia/.cargo/bin/sccache
export MOZ_HOME="$HOME/.config/mozilla"

export _JAVA_AWT_WM_NONREPARENTING=1

# export LIBGL_ALWAYS_SOFTWARE=1

export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export GTK2_RC_FILES="$HOME/.local/share/themes/Kripton/gtk-2.0/gtkrc"
export GTK_THEME="Kripton"
