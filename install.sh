#!/usr/bin/env bash

set -Eeuo pipefail
trap exit ERR

MODE=${1-}

CODE_DIR=~/code
MODES=(home-manager nix-darwin)
OS=$(uname)
OSES=(Darwin Linux)

usage() {
cat << EOF
Usage: install.sh <MODE>

Install dotfiles

Options:
    -h, --help:     show this message and exit

Arguments:
    MODE:           one of: ${MODES[@]} 
EOF
}

check_args() {
    local arg
    local help_arg
    local help_args=("help" "-h" "--help")
    for arg in "$@"; do
        for help_arg in "${help_args[@]}"; do
            if [[ "$arg" == "$help_arg" ]]; then
                usage
                exit
            fi
        done
    done
    if [[ $# -eq 0 ]]; then
        usage >&2
        exit 2
    fi
    local it
    local modeValidated=false
    for it in "${MODES[@]}"; do
        if [[ "$it" == "$MODE" ]]; then
            modeValidated=true
            break
        fi
    done
    if [[ $modeValidated == false ]]; then
        echo "failed handling mode $MODE due to expected one of ${MODES[*]}" >&2
        exit 2
    fi
    local osValidated=false
    for it in "${OSES[@]}"; do
        if [[ "$it" == "$OS" ]]; then
            osValidated=true
            break
        fi
    done
    if [[ $osValidated == false ]]; then
        echo "failed handling OS $OS due to expected one of ${OSES[*]}" >&2
        exit 2
    fi
}

install_git_ssh_keys() {
    echo 'installing git ssh keys...' >&2
    local private_key_file=~/.ssh/id_rsa
    local public_key_file=$private_key_file.pub
    if [[ ! -e $private_key_file ]]; then
        ssh-keygen -t ed25519 -C "Chad.Looker@gmail.com" -N '' -f $private_key_file
        ssh-add $private_key_file
        echo "manually add the following public key to github"
        cat $public_key_file
        read -r -p "press enter when done"
    fi
    echo 'installing git ssh keys...done' >&2
}

install_packages() {
    echo 'installing packages...' >&2
    if [[ $OS == Darwin ]]; then
        if ! xcode-select -p &>/dev/null; then
            xcode-select --install
        fi
        if ! brew --version &>/dev/null; then
            /bin/bash -c 'curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
            echo 'installing packages...homebrew installed but running script again is required...done' >&1
            exit 1
        fi
        brew upgrade && brew install bash --force
    elif [[ $OS == Linux ]]; then
        # minimal packages for this script plus ui apps that nix doesn't manage well in linux
        pkgs=(
            anki
            curl
            git
            chromium-browser
            guvcview
        )
        sudo apt install -y "${pkgs[@]}"
    fi
    echo 'installing packages...done' >&2
}

install_dotfiles_repo() {
    echo 'installing dotfiles repo...' >&2
    mkdir -p "$CODE_DIR"
    cd "$CODE_DIR"
    if [[ ! -e dotfiles ]]; then
        git clone git@github.com:CLooker/dotfiles.git
    fi
    echo 'installing dotfiles repo...done' >&2
}

install_mode() {
    echo "installing $MODE..." >&2
    sudo rm -rf /etc/*backup-before-nix* || true
    sh <(curl -L https://nixos.org/nix/install)
    if [[ $OS == Darwin ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
    elif [[ $OS == Linux ]]; then
        # shellcheck source=/dev/null
        . ~/.nix-profile/etc/profile.d/nix.sh
    else
        echo "failed installing $MODE due to unhandled OS $OS" >&2
    fi
    if [[ $MODE == home-manager ]]; then
    	sudo rm -rf ~/.bashrc || true
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        nix-channel --update
        nix-shell '<home-manager>' -A install
        cd ~/.config
        rm -rf home-manager || true
        mkdir home-manager
        ln -s ~/code/dotfiles/nix/home.nix home-manager/home.nix
        home-manager switch
    elif [[ $MODE == nix-darwin ]]; then
        nix run nix-darwin -- switch --flake "$CODE_DIR"/dotfiles/nix
    else
        echo "failed installing $MODE due to unhandled mode $MODE" >&2
    fi
    echo "installing $MODE...succeeded...restart shell or reboot to definitely see all changes...done" >&2
}

main() {
    check_args "$@"
    install_git_ssh_keys
    install_packages
    install_dotfiles_repo
    install_mode
}

main "$@"

