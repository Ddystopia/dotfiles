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
# localectl --no-convert set-x11-keymap us,ru,ua,sk "" ",,,qwerty" caps:escape,grp_led:scroll

# Enable magic SysRq key
# su -c "echo 1 > /proc/sys/kernel/sysrq"

# Sync time
# udo ntpd -qg

# man-pages anbox

# disable while typing
# syndaemon -i 1.0 -K -t -d

set -e

sudo pacman -S --needed git base-devel linux-headers &&
  git clone https://aur.archlinux.org/paru.git &&
  cd paru &&
  makepkg -si

# pandoc xfce4-power-manager

dependencies=(
  "noto-fonts" "noto-fonts-emoji" "exa" "acpilight" "fd" "ripgrep"
  "copyq" "python-pip" "flameshot" "zsh" "playerctl" "pacman-contrib"
  "ffmpeg" "btop" "ccls" "clang" "cmake" "fzf" "zsh-autosuggestions"
  "qutebrowser" "mpv" "linux-headers" "bspwm" "sxhkd" "rofi" "inetutils"
  "rofi-calc" "rofi-pass" "xclip" "xdo" "cron" "feh" "filelight" "zathura"
  "thefuck" "neofetch" "cowsay" "pulsemixer" "highlight" "inotify-tools"
  "typescript" "racket" "foliate" "discord" "nodejs" "npm" "zathura-pdf-mupdf"
  "python" "python3" "vscode" "lua" "luarocks" "tree-sitter" "luajit" "keepassxc"
  "tor" "thunar" "git" "alacritty" "ranger" "gvfs" "gvfs-mtp" "unrar" "rsync"
  "bash-language-server" "pipewire" "pipewire-audio-client-libraries" "pipewire-media-session"
  "flameshot" "inkscape" "sassc" "bluez-utils" "yt-dlp" "mariadb"
  "pdfjs" "pavucontrol" "android-tools" "usbtools" "lua-language-server" "picom"
  "openssh" "redshift" "inkscape" "pdfplots" "gdb" "gtk3" "gtk4" "gtk2" "openssl"
  "wine" "libreoffice-fresh" "texlife-most" "hunspell" "hunspell-en_US"
  "i2pd" "yggdrasil"  "yaml-language-server" "exfat-utils" "virtualbox"
  "virtualbox-host-modules-arch" "virtualbox-guest-utils" "aria2" "ascii"
  "ueberzug" # attention
)

sudo pacman -Suyy --needed ${dependencies[@]}

sudo npm -g i typescript-language-server yarn vscode-langservers-extracted emmet-ls
sudo pip install black python-language-server pykeepass pynacl
paru -S splatmoji ttf-dejavu-sans-mono-powerline-git xkb-switch \
  unipicker nerd-fonts-mononoki \
  ttf-meslo-nerd-font-powerlevel10k tex-gyre-math-fonts \
  ttf-cm-unicode android-completion xwinwrap
luarocks install --server=https://luarocks.org/dev luaformatter

# android-completion and android-bash-completion 

if [[ ! -e ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]]; then
  git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi
