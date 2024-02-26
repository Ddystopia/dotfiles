{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [

  noto-fonts noto-fonts-emoji

  clang typescript racket nodejs npm python python3 lua
  rustup

  python-pip ccls cmake luarocks luajit lua-language-server
  bash-language-server yaml-language-server

  neovim btop mpv qutebrowser foliate zathura-pdf-mupdf zathura
  keepassxc tree-sitter copyq flameshot rofi rofi-calc rofi-pass
  thunar alacritty flameshot pdfjs pavucontrol libreoffice-fresh

  bspwm picom sxhkd xcape

  linux-headers

  exa acpilight fd ripgrep xclip zsh playerctl pacman-contrib
  ffmpeg fzf zsh-autosuggestions xdo cron feh thefuck
  neofetch cowsay highlight inotify-tools inetutils tor git
  ranger gvfs gvfs-mtp unrar rsync pipewire pipewire-media-session
  pipewire-pulse bluez-utils yt-dlp openssh redshift gdb
  gtk3 gtk4 gtk2 openssl hunspell hunspell-en_US
  ascii ueberzug # attention
  ];

  shellHook = ''
    rustup default stable
  '';
}

