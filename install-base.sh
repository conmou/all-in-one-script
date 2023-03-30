#!/usr/bin/env bash
export NEEDRESTART_MODE=a

# Text Color Variables
GREEN='\033[32m'    # Green
YELLOW='\033[33m'   # YELLOW
BLUE='\033[34m'     # BLUE
CYAN='\033[36m'     # CYAN
WHITE='\033[37m'    # WHITE
BOLD='\033[1m'      # BOLD
CLEAR='\033[0m'     # Clear color and formatting

# Startup
echo -e "${BLUE}${BOLD}=> ${WHITE}Install Basic Tool${CLEAR}"

# Activate sudo permission
echo -e "\n${BLUE}${BOLD}=> ${WHITE}Check for sudo permission${CLEAR}"
sudo -v

do-system-upgrade() {
    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Update software list${CLEAR}"
    sudo apt -y update
}

install-basic-tools() {
    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Git & GPG${CLEAR}"
    sudo apt-get install ssh

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Git & GPG${CLEAR}"
    sudo -E apt -y install git gpg

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Curl & Wget${CLEAR}"
    sudo -E apt -y install curl wget
    
    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Nano${CLEAR}"
    sudo apt install nano

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Htop${CLEAR}"
    sudo -E apt -y install htop

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Z-Shell${CLEAR}"
    sudo -E apt -y install zsh

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}net-tool${CLEAR}"
    sudo apt-get install net-tools
}

setup-basic-config() {
    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Git user config${CLEAR}"
    git config --global user.email "rock12365477@gmail.com"
    git config --global user.name "conmou"

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Set default branch${CLEAR}"
    git config --global init.defaultBranch main

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Setup ssh${CLEAR}"
    if [ -f "conmoukey" ]; then
        echo -e "${CYAN}${BOLD}CHECK ${BLUE}=> ${GREEN}SSH private key exists!${CLEAR}"

        echo -e "\n${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Make .ssh directory${CLEAR}"
        mkdir -p ~/.ssh

        echo -e "\n${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Import SSH private key${CLEAR}"
        cp conmoukey ~/.ssh
        chmod 600 ~/.ssh/conmoukey

        if [ -f "conmoukey" ]; then
            echo -e "${CYAN}${BOLD}CHECK ${BLUE}=> ${GREEN}Paired SSH public key exists!${CLEAR}"

            echo -e "\n${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Import SSH public key${CLEAR}"
            cp conmoukey.pub ~/.ssh
            chmod 644 ~/.ssh/conmoukey.pub
        fi
    else
        echo -e "${CYAN}${BOLD}CHECK ${BLUE}=> ${YELLOW}SSH private key not exist!${CLEAR}"

        echo -e "\n${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Make .ssh directory${CLEAR}"
        mkdir -p ~/.ssh

        echo -e "\n${CYAN}${BOLD}STEP ${BLUE}=> ${WHITE}Generate a new conmoukey key pair${CLEAR}"
        ssh-keygen -t rsa -f ~/.ssh/ -N ""
    fi
}

install-vscode() {
    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install package${CLEAR}"
    curl -L https://aka.ms/linux-arm64-deb > code_arm64.deb
    chmod 600 ./code_arm64.deb
    sudo apt install ./code_arm64.deb
}

# install-docker(){
#     echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install docker${CLEAR}"
#     sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
#     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#     sudo apt-key fingerprint 0EBFCD88
#     sudo echo "deb https://download.docker.com/linux/ubuntu zesty edge" > /etc/apt/sources.list.d/docker.list
#     sudo apt-get update
#     sudo apt-get install docker-ce
# }

setup-zsh() {
    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install oh-my-zsh${CLEAR}"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Set Z-Shell to default shell${CLEAR}"
    sudo chsh -s $(which zsh) $(whoami)

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Setup oh-my-zsh${CLEAR}"

    echo -e "${CYAN}${BOLD}THEME ${BLUE}=> ${WHITE}powerlevel10k${CLEAR}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"cloud"/' ~/.zshrc

    echo -e "${CYAN}${BOLD}PLUGIN ${BLUE}=> ${WHITE}zsh-completions${CLEAR}"
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
    sed -i 's/source $ZSH\/oh-my-zsh.sh/fpath\+=\${ZSH_CUSTOM\:-\${ZSH\:-~\/.oh-my-zsh}\/custom}\/plugins\/zsh-completions\/src\nsource $ZSH\/oh-my-zsh.sh/' ~/.zshrc
    
    echo -e "${CYAN}${BOLD}PLUGIN ${BLUE}=> ${WHITE}zsh-syntax-highlighting${CLEAR}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    sed -i 's/plugins=(git/plugins=(git zsh-syntax-highlighting/' ~/.zshrc
}

install-node() {
    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install nvm${CLEAR}"
    export NVM_DIR="$HOME/.nvm" && (
        git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
        cd "$NVM_DIR"
        git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && \. "$NVM_DIR/nvm.sh"

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install latest lts version${CLEAR}"
    nvm install --lts

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Enable corepack for yarn and pnpm${CLEAR}"
    corepack enable

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install zsh-nvm plugin for oh-my-zsh${CLEAR}"
    git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
    sed -i 's/plugins=(git/plugins=(git zsh-nvm/' ~/.zshrc

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install default node npm nvm yarn plugin for oh-my-zsh${CLEAR}"
    sed -i 's/plugins=(git/plugins=(git node npm nvm yarn/' ~/.zshrc
}

install-python() {
    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install pip for python3${CLEAR}"
    sudo -E apt -y install python3-pip
}

install-php() {
    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install php-cli and all requirements for laravel${CLEAR}"
    sudo -E apt -y install php-cli openssl php-common php-curl php-json php-mbstring php-mysql php-xml php-zip

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install Composer${CLEAR}"
    EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
    then
        echo -e "${CYAN}${BOLD}CHECK ${BLUE}=> ${YELLOW}Installer checksum failed! Composer installation skipped!${CLEAR}"
    else
        php composer-setup.php
    fi

    rm composer-setup.php
    sudo mv composer.phar /usr/local/bin/composer

    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Install default composer and laravel plugin for oh-my-zsh${CLEAR}"
    sed -i '' 's/plugins=(git/plugins=(git composer laravel laravel5/' ~/.zshrc
}

install-laravel() {
    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install Tasksel${CLEAR}"
    sudo apt install tasksel -y

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Use Tasksel to install lamp-server${CLEAR}"
    sudo tasksel install lamp-server

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Update${CLEAR}"
    sudo apt update

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install Apache${CLEAR}"
    sudo apt install apache2 

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install MySQL${CLEAR}"
    sudo apt install mysql-server

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Install composer${CLEAR}"
    curl -sS https://getcomposer.org/installer | php

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Move composer file${CLEAR}"
    sudo mv composer.phar /usr/local/bin/composer

    echo -e "\n${YELLOW}${BOLD}SOFTWARE ${BLUE}=> ${WHITE}Assign execute permission${CLEAR}"
    sudo chmod +x /usr/local/bin/composer
}

clean-up() {
    echo -e "\n${YELLOW}${BOLD}STEP ${BLUE}=> ${WHITE}Clean up apt packages${CLEAR}"
    sudo -E apt -y --purge autoremove
    sudo -E apt clean
    sudo -E apt autoclean
}

install-all() {
    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Update the system${CLEAR}"
    do-system-upgrade

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install basic tools${CLEAR}"
    install-basic-tools

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Setup basic config${CLEAR}"
    setup-basic-config

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install vscode${CLEAR}"
    install-vscode

    # echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install docker${CLEAR}"
    # install-docker

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Setup Z-Shell${CLEAR}"
    setup-zsh

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install Node.js${CLEAR}"
    install-node

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install Python${CLEAR}"
    install-python

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install PHP${CLEAR}"
    install-php

    echo -e "\n${GREEN}${BOLD}SETUP ${BLUE}=> ${CYAN}Install Laravel${CLEAR}"
    install-laravel

    echo -e "\n${GREEN}${BOLD}POST SETUP ${BLUE}=> ${CYAN}Clean-Up${CLEAR}"
    clean-up
}

install-all

echo -e "\n${BLUE}${BOLD}=> ${WHITE}Basic Tool Install Complete!${CLEAR}\n"

if [ "$1" != "--called-from-another" ]; then
    echo -e "\n${BLUE}${BOLD}=> ${WHITE}Install Complete! Restart your computer to continue!${CLEAR}"
fi