sudo apt update && sudo apt upgrade -y

# get curl
sudo apt install curl -y

# install fonts
mkdir ~/.local/share/fonts/
cp -r fonts/* ~/.local/share/fonts/

# set up Obsidian Md
sudo mkdir ~/AppImages/
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.1.16/Obsidian-1.1.16.AppImage
chmod +x Obsidian-1.1.16.AppImage
mv Obsidian-1.1.16.AppImage ~/AppImages/
curl -o obsidian-md-logo.png https://avatars2.githubusercontent.com/u/65011256?s=280&v=4
mv obsidian-md-logo.png ~/AppImages/
cp obsidian.desktop ~/.local/share/applications/

# set up NextCloud
sudo snap install nextcloud 

# install nvidia driver
sudo apt install nvidia-driver-525 nvidia-dkms-525 nvidia-settings-525 -y

# install flatpak
sudo apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install filezilla
sudo apt install filezilla -y

# Neovim snap
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

# Steam snap
sudo snap install steam

# install git
sudo apt install git -y
git config --global user.name "Michael"
git config --global user.email "michaelmcconkie147010@gmail.com"

# generate ssh key for github
# Generate the SSH key pair
ssh-keygen -t ed25519 -C "your_email@example.com"

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add the SSH key to the agent
ssh-add ~/.ssh/id_ed25519

# Install xclip
sudo apt-get install -y xclip

# Copy the public key to a file
cp ~/.ssh/id_ed25519.pub public_key.txt

# Spotify snap
sudo snap install spotify

# Microsoft edge
curl -o microsoft-edge.deb https://go.microsoft.com/fwlink/?linkid=2124602&brand=M103
sudo dpkg -i microsoft-edge.deb
rm microsoft-edge.deb

# Timeshift

# Configure Timeshift to take daily snapshots
sudo timeshift --config --snapshot-device /dev/sdXY --snapshot-type RSYNC --schedule --schedule-hour 0 --schedule-min 0 --rsync-schedule daily

# Set the number of daily snapshots to keep
sudo timeshift --config --rsync-schedule-daily 3

# Include specific file patterns for the current user and root
current_user="$(whoami)"
sudo timeshift --config --rsync-include "/home/$current_user/**" --rsync-include "/root/**"

# Exclude the "Games" directory under the current user's home directory
sudo timeshift --config --rsync-exclude "/home/$current_user/Games"

sudo systemctl enable timeshift
sudo systemctl start timeshift

# Update .bashrc file to load .bash_profile
# This should already happen, but just in case
# Check if .bashrc already contains the lines to source .bash_profile
if ! grep -qF 'if [ -f "$HOME/.bash_profile" ]; then' "$HOME/.bashrc"; then
  # If not, append the lines to .bashrc
  echo -e "\n# Source .bash_profile if it exists" >> "$HOME/.bashrc"
  echo 'if [ -f "$HOME/.bash_profile" ]; then' >> "$HOME/.bashrc"
  echo '  . "$HOME/.bash_profile"' >> "$HOME/.bashrc"
  echo 'fi' >> "$HOME/.bashrc"
  echo "Lines to source .bash_profile were added to .bashrc"
else
  echo ".bashrc already sources .bash_profile"
fi

# add .bash_profile settings
# Specify the input encrypted file and output decrypted file
input_encrypted_file="bash_profile.enc"
output_decrypted_file="bash_profile.dec"

# Decrypt the encrypted .bash_profile
openssl enc -d -aes-256-cbc -in "$input_encrypted_file" -out "$output_decrypted_file"

# Check if the .bash_profile file exists in the current user's home directory
if [ -f "$HOME/.bash_profile" ]; then
  # If it exists, append the decrypted content to it
  cat "$output_decrypted_file" >> "$HOME/.bash_profile"
else
  # If it doesn't exist, create a new .bash_profile with the decrypted content
  mv "$output_decrypted_file" "$HOME/.bash_profile"
fi

# Remove the decrypted file
rm "$output_decrypted_file"

# Apply the changes to the current shell session
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


# Give the user the remaining steps
echo "The script is complete. You will need to manually complete the following steps:"
echo "1. Login to NextCloud"
echo "2. Login to Edge"
echo "3. Login to Spotify"
echo "4. Login to Steam"
echo "5. Login to CoPilot on Neovim"
echo "The SSH public key has been saved to the 'public_key.txt' file."
echo "Please add this key to your GitHub account."

((Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -and $_.DisplayVersion } | Select-Object DisplayName, DisplayVersion) + (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -and $_.DisplayVersion } | Select-Object DisplayName, DisplayVersion)) | Export-Csv -Path "InstalledSoftware.csv" -NoTypeInformation -Encoding UTF8

