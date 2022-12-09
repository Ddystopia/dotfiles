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

set -e

sudo pacman -S --needed git base-devel linux-headers &&
  git clone https://aur.archlinux.org/paru.git &&
  cd paru &&
  makepkg -si

# "pandoc" "xfce4-power-manager"

dependencies=(
  "noto-fonts" "noto-fonts-emoji"
  "copyq" "python-pip" "flameshot" "zsh" 
  "ffmpeg" "btop" "ccls" "clang" "cmake" "fzf" "zsh-autosuggestions"
  "qutebrowser" "mpv" "linux-headers" "bspwm" "sxhkd" "rofi" "inetutils"
  "rofi-calc" "rofi-pass" "xclip" "xdo" "cron" "nitrogen" "filelight" "zathura"
  "thefuck" "neofetch" "cowsay" "pulsemixer" "ueberzug" "highlight"
  "typescript" "racket" "foliate" "discord" "nodejs" "npm" "dino" "zathura-pdf-mupdf"
  "python" "python3" "vscode" "lua" "luarocks" "tree-sitter" "luajit" "keepassxc"
  "tor" "thunar" "git" "alacritty" "ranger" "gvfs" "gvfs-mtp" "unrar" "rsync"
  "bash-language-server" "pipewire" "pipewire-audio-client-libraries" "pipewire-media-session"
  "flameshot" "filelight" "inkscape" "sassc" "bluez-utils" "yt-dlp" "mariadb"
  "pdfjs" "pavucontrol" "android-tools" "usbtools" "lua-language-server" "picom"
  "openssh" "redshift" "inkscape" "pdfplots" "gdb" "gtk3" "gtk4" "gtk2" "openssl"
  "wine" "libreoffice-fresh" "texlife-most" "hunspell" "hunspell-en_US"
  "i2pd" "yggdrasil" "tinyproxy" "yaml-language-server" "exfat-utils" "virtualbox"
  "virtualbox-host-modules-arch" "virtualbox-guest-utils" "aria2" "ascii"
)

sudo pacman -Suyy --needed ${dependencies[@]}

sudo npm -g i typescript-language-server yarn vscode-langservers-extracted emmet-ls
sudo pip install black python-language-server pylsp pykeepass pynacl
paru -S splatmoji ttf-dejavu-sans-mono-powerline-git xkb xkb-switch \
  unipicker ttf-nerd-fonts-symbols nerd-fonts-mononoki \
  ttf-meslo-nerd-font-powerlevel10k nerd-fonts-fira-code tex-gyre-math-fonts \
  ttf-cm-unicode android-completion android-bash-completion xwinwrap
luarocks install --server=https://luarocks.org/dev luaformatter

if [[ ! -e ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]]; then
  git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi
