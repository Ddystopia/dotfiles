# nozomi
# hitomi
# Томас Лиготти
# Наяль Давье
# Everywhere at the end of time

# Mirrors
# sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
# sudo curl -o /etc/pacman.d/mirrorlist "https://archlinux.org/mirrorlist/?country=SK&protocol=http&protocol=https&ip_version=4&ip_version=6"

# pv

# Write iso
# sudo dd bs=4M if=~/Downloads/manjaro.iso of=/dev/sdg status=progress oflag=sync

# Swap Caps Lock and Esc
# localectl --no-convert set-x11-keymap us,ru,ua,sk "" ",,,qwerty" caps:escape,grp_led:scroll

# Enable magic SysRq key
# su -c "echo 1 > /proc/sys/kernel/sysrq"

dependencies=(
  "copyq" "python-pip" "noto-fonts-emoji" "flameshot" "zsh" "xfce4-power-manager"
  "ffmpeg" "bpytop" "ccls" "clang" "cmake" "fzf" "zsh-autosuggestions"
  "qutebrowser" "mpv" "linux-headers" "bspwm" "sxhkd" "rofi" "inetutils"
  "rofi-calc" "rofi-pass" "xclip" "xdo" "cron" "nitrogen" "filelight" "zathura"
  "thefuck" "neofetch" "cowsay" "pandoc" "pulsemixer" "ueberzug" "highlight"
  "typescript" "racket" "foliate" "discord" "nodejs" "npm" "dino" "zathura-pdf-mupdf"
  "python" "python3" "vscode" "lua" "luarocks" "tree-sitter" "luajit" "keepassxc"
  "tor" "thunar" "git" "alacritty" "ranger" "gvfs" "gvfs-mtp" "unrar" "rsync"
  "bash-language-server" "pipewire" "pipewire-audio-client-libraries" "pipewire-media-session"
  "flameshot" "filelight" "inkscape" "sassc" "bluez-utils" "yt-dlp" "noto-fonts-emoji"
  "pdfjs" "pavucontrol" "compton" "android-tools" "usbtools" "lua-language-server"
)

sudo pacman -Suyy ${dependencies[@]}

sudo npm -g i typescript-language-server yarn vscode-langservers-extracted emmet-ls
sudo pip install black python-language-server pylsp pykeepass pynacl
yay -S splatmoji ttf-dejavu-sans-mono-powerline-git xkb xkb-switch \
  compton-tryone-git unipicker ttf-nerd-fonts-symbols nerd-fonts-mononoki \
  ttf-meslo-nerd-font-powerlevel10k nerd-fonts-fira-code tex-gyre-math-fonts \
  ttf-cm-unicode android-completion android-bash-completion
luarocks install --server=https://luarocks.org/dev luaformatter

if [ ! -g ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
  git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi
