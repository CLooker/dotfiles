__bashrc_cwd() {
    local cwd
    cwd=$(pwd)

    # replace $HOME with ~
    if [[ "$cwd" == "$HOME"* ]]; then
        cwd="~${cwd#"$HOME"}"
    fi

    # wrap cwd segments that have spaces with ''
    echo "$cwd" | awk -F/ '{ for (i=1; i<=NF; i++) { if ($i ~ / /) $i="'\''"$i"'\''" } print $0 }' OFS=/
}

__bashrc_misc_ps1() {
    local result=''

    if [[ -n $IN_NIX_SHELL ]]; then
        result+="|nix"
    fi

    local job_pids
    job_pids=$(jobs -p)
    if [[ -n $job_pids ]]; then
        local pname_label_arr=("nvim|vi" "vi|vi" "vim|vi")
        local pname_label
        for pname_label in "${pname_label_arr[@]}"; do
            local pname="${pname_label%|*}"
            local label="${pname_label#*|}"
            for pid in $job_pids; do
                local comm
                comm=$(ps -o comm= -p "$pid" 2>/dev/null) || continue
                if [[ $comm == "$pname" ]]; then
                    result+="|$label"
                    break
                fi
            done
        done
    fi

    if [[ -n $result ]]; then
        echo "(${result#|}) "
    fi
}

__bashrc_set_env() {
    export EDITOR=vim
    export GIT_PS1_SHOWDIRTYSTATE=1
    export NIX_SHELL_PRESERVE_PROMPT=1 # used to preserve PS1 in nix-shell
    export PASSWD_FILE=~/workspace/secret/passwd.txt
    export PATH=~/workspace/script:$PATH
    #export PATH=~/.local/share/nvim_nightly/bin:$PATH
    export PATH=".:$PATH"

    local sourced_paths=(
        /etc/bashrc
        /etc/profiles/per-user/"$USER"/etc/profile.d/hm-session-vars.sh
        ~/.git-completion.bash
        ~/.git-prompt.sh
        ~/.nix-profile/etc/profile.d/hm-session-vars.sh
        ~/.nix-profile/etc/profile.d/nix.sh
        ~/nix/var/nix/profiles/default/etc/profile.d/nix.sh
    )
    for sp in "${sourced_paths[@]}"; do
        if [[ -e $sp ]]; then
            . "$sp"
        fi
    done

    PS1="\[$(tput setaf 10)\]\u@\h \[$(tput setaf 12)\]\$(__bashrc_cwd) \[$(tput setaf 11)\]\$(__git_ps1 '(%s) ')\\[$(tput setaf 8)\]\$(__bashrc_misc_ps1)\\[$(tput setaf 13)\]>>\[$(tput sgr0)\] "
}

__bashrc_set_aliases() {
    alias darwin-rebuild-switch='sudo darwin-rebuild switch --flake $HOME/code/dotfiles/nix/flake.nix && launchctl stop org.nixos.skhd && launchctl start org.nixos.skhd'
    alias gradlew='PATH="/usr/bin:$PATH" ./gradlew'
    alias gv='ffg vi'
    alias ls='/usr/bin/env ls --color=auto --group-directories-first -v1'
    #alias nvim='NVIM_APPNAME=nvim_nightly nvim'
    alias vi=nvim
    alias vim=nvim
}

__bashrc_use_vi() {
    bind 'set editing-mode vi'
    bind 'set keyseq-timeout 1'
    bind 'set show-mode-in-prompt on'
    bind 'set vi-ins-mode-string \1\e[5 q\2'
    bind 'set vi-cmd-mode-string \1\e[2 q\2'
    bind -m vi-command '"\e[A": history-search-backward'
    bind -m vi-command '"\e[B": history-search-forward'
    bind -m vi-insert '"\e[A": history-search-backward'
    bind -m vi-insert '"\e[B": history-search-forward'
    bind -m vi-command 'j: next-screen-line'
    bind -m vi-command 'k: previous-screen-line'
    bind -m vi-insert '"\C-l": clear-screen'
    bind -m vi-insert '"\C-[": vi-movement-mode'
}

# fast fg to fg a job matching a label
ffg() {
    local label=${1?"label arg is required, e.g., nvim"}
    local job_id
    job_id=$(jobs | grep "$label" | head -1 | cut -d '[' -f 2 | cut -d ']' -f 1)
    if [[ -n $job_id ]]; then
        fg %"$job_id"
    fi
}

main() {
    # if not interactive then do nothing
    if [[ ! $- == *i* ]]; then
        return
    fi
    __bashrc_set_env
    __bashrc_set_aliases
    __bashrc_use_vi
}

main "$@"
