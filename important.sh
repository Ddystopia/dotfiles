# nozomi
# hitomi
# Томас Лиготти
# Наяль Давье
# Everywhere at the end of time

# Mirrors
# sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
# sudo curl -o /etc/pacman.d/mirrorlist "https://archlinux.org/mirrorlist/?country=UA&protocol=http&protocol=https&ip_version=4&ip_version=6"

# pv

# Write iso
# sudo dd bs=4M if=~/Downloads/manjaro.iso of=/dev/sdg status=progress oflag=sync

# Swap Caps Lock and Esc
localectl --no-convert set-x11-keymap us,ru,ua,sk "" ",,,qwerty" caps:escape,grp_led:scroll

# Enable magic SysRq key
# su -c "echo 1 > /proc/sys/kernel/sysrq"

dependencies=(
  "copyq" "python-pip" "noto-fonts-emoji" "flameshot" "zsh"
  "ffmpeg" "bpytop" "ccls" "clang" "cmake" "fzf" "zsh-autosuggestions"
  "qutebrowser" "mpv" "linux-headers" "bspwm" "sxhkd" "rofi"
  "rofi-calc" "rofi-pass" "xclip" "xdo" "cron" "nitrogen" "filelight"
  "thefuck" "neofetch" "cowsay" "pandoc" "pulsemixer" "ueberzug" "highlight"
  "typescript" "racket" "foliate" "discord" "nodejs" "npm" "timeshift"
  "python" "python3" "vscode" "lua" "luarocks" "tree-sitter" "luajit" "keepassxc"
  "tor" "thunar"
)

sudo pacman -Syy ${dependencies[@]}

sudo npm -g i typescript-language-server yarn vscode-langservers-extracted emmet-ls
sudo pip install black python-language-server pylsp pykeepass yt-dlp
yay -S splatmoji ttf-dejavu-sans-mono-powerline-git xkb xkb-switch compton-tryone-git unipicker
luarocks install --server=https://luarocks.org/dev luaformatter
