# nozomi
# hitomi
# Томас Лиготти
# Наяль Давье
# Everywhere at the end of time

# Mirrors
# sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
# sudo curl -o /etc/pacman.d/mirrorlist "https://archlinux.org/mirrorlist/?country=SK&protocol=http&protocol=https&ip_version=4&ip_version=6"

# pv

# gdb --batch-silent -ex "attach $$" -ex 'set bind_variable("dte", "$dte", 0)'

# Write iso
# sudo dd bs=4M if=~/Downloads/manjaro.iso of=/dev/sdg status=progress oflag=sync

# Swap Caps Lock and Esc
# localectl --no-convert set-x11-keymap us,ru,ua,sk "" ",,,qwerty" caps:escape,grp_led:scroll,altwin:menu_super

# Enable magic SysRq key
# su -c "echo 1 > /proc/sys/kernel/sysrq"

# Sync time
# udo ntpd -qg

# man-pages anbox

# disable while typing
# syndaemon -i 1.0 -K -t -d

set -e

dependencies=(
  "noto-fonts" "noto-fonts-emoji"

  "clang" "typescript" "racket" "nodejs" "npm" "python" "python3" "lua"
  "rustup"

  "python-pip" "ccls" "cmake" "luarocks" "luajit" "lua-language-server"
  "bash-language-server" "yaml-language-server"

  "neovim" "btop" "mpv" "qutebrowser" "foliate""zathura-pdf-mupdf" "zathura"
  "keepassxc" "tree-sitter" "copyq" "flameshot" "rofi" "rofi-calc" "rofi-pass"
  "thunar" "alacritty" "flameshot" "pdfjs" "pavucontrol" "libreoffice-fresh"

  "bspwm" "picom" "sxhkd" "xcape"

  "linux-headers"  

  "exa" "acpilight" "fd" "ripgrep" "xclip" "zsh" "playerctl" "pacman-contrib"
  "ffmpeg"   "fzf" "zsh-autosuggestions" "xdo" "cron" "feh" "thefuck"
  "neofetch" "cowsay" "highlight" "inotify-tools" "inetutils" "tor" "git"
  "ranger" "gvfs" "gvfs-mtp" "unrar" "rsync" "pipewire" "pipewire-media-session"
  "pipewire-pulse" "bluez-utils" "yt-dlp" "openssh" "redshift" "gdb"
  "gtk3" "gtk4" "gtk2" "openssl" "hunspell" "hunspell-en_US"
  "ascii" "ueberzug" # attention
)

maybe=(
  "i2pd" "yggdrasil" "exfat-utils"
)

rustup default stable

sudo pacman -Suyy --needed ${dependencies[@]}

sudo pacman -S --needed git base-devel linux-headers &&
  git clone https://aur.archlinux.org/paru.git &&
  cd paru &&
  makepkg -si

sudo npm -g i typescript-language-server yarn vscode-langservers-extracted
sudo pip install black python-language-server pykeepass
paru -S splatmoji ttf-dejavu-sans-mono-powerline-git xkb-switch \
  unipicker nerd-fonts \
  ttf-meslo-nerd-font-powerlevel10k tex-gyre-math-fonts \
  ttf-cm-unicode xwinwrap
sudo luarocks install --server=https://luarocks.org/dev luaformatter

# android-completion and android-bash-completion 
