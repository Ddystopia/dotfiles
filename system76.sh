set -e

# select first option in paru -S firmware-manager
# ^ sucks

sudo pacman -S --needed git linux-headers

paru -S system76-firmware-daemon system76-firmware \
  system76-power firmware-manager \
  system76-driver system76-dkms system76-acpi-dkms system76-io-dkms

sudo doas systemctl enable --now system76-firmware-daemon
sudo doas gpasswd -a $USER adm

sudo doas systemctl enable --now com.system76.PowerDaemon.service
sudo doas gpasswd -a $USER adm

sudo doas systemctl enable --now system76
