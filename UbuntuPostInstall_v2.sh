#!/bin/bash

# Update system
sudo apt update && sudo apt upgrade -y

# Install curl
sudo apt install curl -y

# Install fonts
mkdir ~/.local/share/fonts/
cp -r fonts/* ~/.local/share/fonts/

# Set up Obsidian Md
sudo mkdir ~/AppImages/
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.1.16/Obsidian-1.1.16.AppImage
chmod +x Obsidian-1.1.16.AppImage
mv Obsidian-1.1.16.AppImage ~/AppImages/
curl -o obsidian-md-logo.png https://avatars2.githubusercontent.com/u/65011256?s=280&v=4
mv obsidian-md-logo.png ~/AppImages/
cp obsidian.desktop ~/.local/share/applications/

# Set up NextCloud
sudo snap install nextcloud 

# Install Nvidia driver
sudo apt install nvidia-driver-525 nvidia-dkms-525 nvidia-settings-525 -y

# Install Flatpak
sudo apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Filezilla
sudo apt install filezilla -y

# Install Neovim snap
sudo snap install nvim --classic
mkdir ~/.config/nvim/
cp init.vim ~/.config/nvim/
nvim -c 'PlugInstall' -c 'qa'
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
sudo apt install exuberant-ctags -y
sudo apt install nodejs -y
sudo apt install npm -y
sudo npm install -g yarn
yarn install --cwd ~/.local/share/nvim/plugged/coc.nvim
nvim -c 'CocInstall coc-json coc-tsserver coc-html coc-css coc-vetur coc-prettier coc-eslint coc-yaml coc-python' -c 'qa'

# Install Steam snap
sudo snap install steam

# Install Git
sudo apt install git -y
git config --global user.name "Michael"
git config --global user.email "michaelmcconkie147010@gmail.com"

# Set up a global .gitignore file
git config --global core.excludesFile '~/.gitignore_global'

# Add 'venv' to the global .gitignore file
echo "venv/" >> ~/.gitignore_global

# Cache Git credentials for 1 hour (3600 seconds)
git config --global credential.helper 'cache --timeout=3600'

# Generate SSH key for GitHub
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
sudo apt-get install -y xclip
cp ~/.ssh/id_ed25519.pub public_key.txt

# Install Spotify snap
sudo snap install spotify

# Install Microsoft Edge
curl -o microsoft-edge.deb https://go.microsoft.com/fwlink/?linkid=2124602&brand=M103
sudo dpkg -i microsoft-edge.deb
rm microsoft-edge.deb

# Configure Timeshift
sudo timeshift --config --snapshot-device /dev/sdXY --snapshot-type RSYNC --schedule --schedule-hour 0 --schedule-min 0 --rsync-schedule daily
sudo timeshift --config --rsync-schedule-daily 3
current_user="$(whoami)"
sudo timeshift --config --rsync-include "/home/$current_user/**" --rsync-include "/root/**"
sudo timeshift --config --rsync-exclude "/home/$current_user/Games"
sudo systemctl enable timeshift
sudo systemctl start timeshift

# Update .bashrc to load .bash_profile
if ! grep -qF 'if [ -f "$HOME/.bash_profile" ]; then' "$HOME/.bashrc"; then
  echo -e "\n# Source .bash_profile if it exists" >> "$HOME/.bashrc"
  echo 'if [ -f "$HOME/.bash_profile" ]; then' >> "$HOME/.bashrc"
  echo '  . "$HOME/.bash_profile"' >> "$HOME/.bashrc"
  echo 'fi' >> "$HOME/.bashrc"
  echo "Lines to source .bash_profile were added to .bashrc"
else
  echo ".bashrc already sources .bash_profile"
fi

# Add .bash_profile settings
input_encrypted_file="bash_profile.enc"
output_decrypted_file="bash_profile.dec"
openssl enc -d -aes-256-cbc -in "$input_encrypted_file" -out "$output_decrypted_file"
if [ -f "$HOME/.bash_profile" ]; then
  cat "$output_decrypted_file" >> "$HOME/.bash_profile"
else
  mv "$output_decrypted_file" "$HOME/.bash_profile"
fi
rm "$output_decrypted_file"
source "$HOME/.bash_profile"

# Install Lutris
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt-get update
sudo apt-get install lutris

# Install Bottles
sudo apt install --install-recommends wine-development
sudo apt install --install-recommends wine64-development
sudo apt install --install-recommends wine32-development
wget https://github.com/bottlesdevs/Bottles/releases/download/v2022.12.14/bottles.flatpakref
flatpak install bottles.flatpakref
rm bottles.flatpakref

# Set sleep timeout to 15 minutes (900 seconds) when on battery
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 900

# Set sleep timeout to 15 minutes (900 seconds) when plugged in
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 900

# Display remaining steps for the user
echo "The script is complete. You will need to manually complete the following steps:"
echo "1. Login to NextCloud"
echo "2. Login to Edge"
echo "3. Login to Spotify"
echo "4. Login to Steam"
echo "5. Login to CoPilot on Neovim"
echo "The SSH public key has been saved to the 'public_key.txt' file."
echo "Please add this key to your GitHub account."
