set -e

# select first option in paru -S firmware-manager

sudo pacman -S --needed git base-devel linux-headers

paru -S system76-firmware-daemon system76-firmware \
  firmware-manager system76-power gnome-shell-extension-system76-power-git \
  system76-driver system76-dkms system76-acpi-dkms system76-io-dkms \
  system76-acpi-oled

sudo systemctl enable --now system76-firmware-daemon
sudo gpasswd -a $USER adm

sudo systemctl enable --now com.system76.PowerDaemon.service
sudo gpasswd -a $USER adm

sudo systemctl enable --now system76
