__cwd() {
    local cwd
    cwd=$(pwd)

    # replace $HOME with ~
    if [[ "$cwd" == "$HOME"* ]]; then
        cwd="~${cwd#"$HOME"}"
    fi

    # wrap cwd segments that have spaces with ''
    echo "$cwd" | awk -F/ '{ for (i=1; i<=NF; i++) { if ($i ~ / /) $i="'\''"$i"'\''" } print $0 }' OFS=/
}

__misc_ps1() {
    local result=''
    if [[ -n $IN_NIX_SHELL ]]; then 
        local result="${result}|nix"
    fi 
    if [[ $(jobs | grep vi) ]]; then
        local result="${result}|vi"
    fi
    if [[ -n $result ]]; then
        echo "(${result}) " | sed 's/|//'
    fi
}

set_env() {
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export EDITOR=vi
    export GIT_PS1_SHOWDIRTYSTATE=1
    export NIX_SHELL_PRESERVE_PROMPT=1 # used to preserve PS1 in nix-shell
    export PASSWD_FILE=~/workspace/secret/passwd.txt
    export PATH=~/workspace/script:$PATH
    export PATH=~/.local/share/nvim_nightly/bin:$PATH
    export PATH=".:$PATH"

    # home-manager stopped exporting JAVA_HOME for unknown reason
    local java_home
    java_home=$(readlink "$(which java)")
    java_home=$(dirname "$java_home")
    java_home=$(dirname "$java_home")
    java_home="${java_home}/zulu-23.jdk/Contents/Home"
    export JAVA_HOME=$java_home

    local files=(
        /etc/bashrc
        ~/.git-completion.bash 
        ~/.git-prompt.sh 
        ~/.nix-profile/etc/profile.d/hm-session-vars.sh # source nix session vars
        ~/.nix-profile/etc/profile.d/nix.sh
        ~/nix/var/nix/profiles/default/etc/profile.d/nix.sh
    )
    for f in in "${files[@]}"; do
        if [[ -e $f ]]; then
            . "$f"
        fi
    done

    PS1="\[$(tput setaf 10)\]\u@\h \[$(tput setaf 12)\]\$(__cwd) \[$(tput setaf 11)\]\$(__git_ps1 '(%s) ')\\[$(tput setaf 8)\]\$(__misc_ps1)\\[$(tput setaf 13)\]>>\[$(tput sgr0)\] "
}

set_aliases() {
    alias darwin-rebuild-switch='darwin-rebuild switch --flake ~/code/dotfiles/nix && launchctl stop org.nixos.skhd && launchctl start org.nixos.skhd'
    alias gradlew='PATH="/usr/bin:$PATH" ./gradlew'
    alias ls='/usr/bin/env ls --color --group-directories-first'
    alias nvim='NVIM_APPNAME=nvim_nightly nvim'
    alias vi=nvim
    alias vim=nvim
}

main() {
    # if not interactive then do nothing
    if [[ ! $- == *i* ]]; then
        return
    fi
    set_env
    set_aliases
}

main "$@"

