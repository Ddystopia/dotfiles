# nozomi
# hitomi
# Томас Лиготти
# Everywhere at the end of time

# Mirrors
# sudo cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
# sudo curl -o /etc/pacman.d/mirrorlist "https://archlinux.org/mirrorlist/?country=UA&protocol=http&protocol=https&ip_version=4&ip_version=6"

# Music
# youtube-dl --extract-audio --audio-quality 0 --audio-format mp3 --yes-playlist -i { URL }

# Write iso
# sudo dd bs=4M if=~/Downloads/manjaro.iso of=/dev/sdg status=progress oflag=sync

# Swap Caps Lock and Esc
localectl --no-convert set-x11-keymap us,ru "" "" caps:escape,grp_led:scroll

# Enable magic SysRq key
su -c "echo 1 > /proc/sys/kernel/sysrq"

dependensies=(
  "copyq" "python-pip" "noto-fonts-emoji" "flameshot" "zsh"
  "ffmpeg" "bpytop" "ccls" "clang" "cmake" "fzf" "zsh-autosuggestions"
  "qutebrowser" "mpv" "linux-headers" "bspwm" "sxhkd" "rofi" "python-adblock"
  "rofi-calc" "rofi-pass" "xclip" "xdo" "cron" "nitrogen" "filelight"
  "thefuck" "neofetch" "cowsay" "pandoc" "pulsemixer" "ueberzug" "highlight"
  "typescript" "youtube-dl" "racket" "atril" "foliate" "discord" "nodejs" "npm" 
  "python" "python3" "vscode" "lua" "luarocks" "tree-sitter" "luajit"
)

sudo pacman -S ${dependensies[@]}

pip install black python-language-server pylsp
sudo npm -g i typescript-language-server yarn
yay -S splatmoji ttf-dejavu-sans-mono-powerline-git xkb xkb-switch compton-tryone-git unipicker
luarocks install --server=https://luarocks.org/dev luaformatter
