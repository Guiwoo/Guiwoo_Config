#!/usr/bin/env zsh

autoload -U colors && colors
autoload -U promptinit; promptinit
autoload -U compinit; compinit
autoload -U vcs_info

setopt prompt_subst

local -a precmd_functions
local reset="%{${reset_color}%}"
local white="%{$fg_bold[white]%}"
local grey="%{$fg_bold[black]%}"
local green="%{$fg_bold[green]%}"
local blue="%{$fg_no_bold[blue]%}"
local red="%{$fg[red]%}"
local yellow="%{$fg[yellow]%}"
local magenta="%{$fg[magenta]%}"
local FG178="%{[38;5;178m%}"

local cyan_on_black="${reset}%F{cyan}"
local red_on_black="${reset}%F{red}"
local yellow_on_black="${reset}%F{yellow}"
local magenta_on_black="${reset}%F{magenta}"

local -aU symbol_status_guard
#symbol_status_guard=( "【" "】" )
#local symbol_status_stash="龎"
#local symbol_status_untrack="鬒"
#local symbol_status_add="頋"
#local symbol_status_add_desc="추가"
#local symbol_status_modify="龜"
#local symbol_status_modify_desc="수정"
#local symbol_status_del="頻"
#local symbol_status_del_desc="삭제"
#local symbol_status_ready_commit="𢡊"
#local symbol_tag="𥉉 "
#local symbol_rebase="𥳐"
#local symbol_push="齃"
#local symbol_fastforward="䀹"
#local symbol_diverge="䀘"
#local symbol_local_branch="㮝"
#local symbol_detach_branch="𣏕"
#local symbol_track="𧻓"

symbol_status_guard=( "\u3010" "\u3011" )
local symbol_status_stash="\u2744"
local symbol_status_untrack="\u267a " #"\u29bf"
local symbol_status_add="\u271c" 
local symbol_status_add_desc="\ucd94\uac00" # 추가
local symbol_status_modify="\u270e"
local symbol_status_modify_desc="\uc218\uc815" # 수정
local symbol_status_del="\u2718"
local symbol_status_del_desc="\uc0ad\uc81c" # 삭제
local symbol_status_ready_commit="\u2600"
local symbol_tag="\u2e19"
local symbol_rebase="\u2608"
local symbol_push="\u2601"
local symbol_fastforward="\u2601"
local symbol_ahead="\u21b6"
local symbol_behind="\u21b7"
local symbol_diverge="\u2695"
local symbol_local_branch="\u2328 "
local symbol_detach_branch="\u236f"
local symbol_track="\u260d"
local symbol_task="✓"

precmd_functions+=( precmd_prompt_left precmd_prompt_right )
#precmd_functions+=( precmd_prompt_left )

# Set prompt options
local -A pr_com
local -a pr_llines pr_rlines

zstyle ':pr_variable:*' hooks_left pwd usr task venv jobs prompt
zstyle ':pr_variable:*' hooks_right vcs
zstyle ':pr_variable:*' pwd "[%3~]"
zstyle ':pr_variable:*' usr "%n"
zstyle ':pr_variable:*' host "%m"

# Set vcs_info options
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true
zstyle ':vcs_info:git*+set-message:*' hooks git-stash git-status git-remote 

zstyle ':vcs_info:git*' formats "${magenta_on_black}${symbol_status_guard[1]}%m%c%a${magenta_on_black} ${symbol_status_guard[2]}${reset}${yellow}%b${reset} ${white}[${red}%7.7i${white}]${reset}" # hash changes branch misc
zstyle ':vcs_info:git*' actionformats "(${magenta_on_black}${symbol_status_guard[1]}%m%c%a${magenta_on_black} ${symbol_status_guard[2]}${reset}${yellow}%b${reset} ${white}[${red}%7.7i${white}]${reset}"
zstyle ':vcs_info:git*' branchformat "${yellow}%b%m${reset}" # only show branch

zstyle ':vcs_info:git*:*' unstagedstr "${symbol_status_untrack}"
zstyle ':vcs_info:git*:*' stagedstr "${cyan_on_black}${symbol_status_add}${symbol_status_add_desc}${symbol_status_modify}${symbol_status_modify_desc}${symbol_status_del}${symbol_status_del_desc}${symbol_status_modify}${symbol_status_del}${symbol_status_ready_commit}${reset}"

# prompt functions ############################################################

# Run all the prompt hook functions
# (stolen, wholesale, from the excellent hook system in vcs_info)
function pr_run_hooks() {
    local hook func
    local -a hooks

    zstyle -g hooks ":pr_variable:*" $1

    (( ${#hooks} == 0 )) && return 0

    for hook in ${hooks} ; do
        func="+pr-${hook}"
        if (( ${+functions[$func]} == 0 )); then
            continue
        fi
        true
        ${func} "$@"
        case $? in
            (0)
                ;;
            (*)
                break
                ;;
        esac
    done
}

function +pr-left() {
    pr_llines=("${pr_com[usr]}")

    if [[ -n ${pr_com[task]} ]]; then
        pr_llines[1]=("${pr_llines[1]} ${pr_com[task]}")
    fi
    if [[ -n ${pr_com[venv]} ]]; then
        pr_llines[1]=( "${pr_llines[1]} ${pr_com[pwd]} ${pr_com[venv]} ${pr_com[prompt]}" )
    else
        pr_llines[1]=( "${pr_llines[1]} ${pr_com[pwd]} ${pr_com[prompt]}" )
    fi
}

function +pr-right() {

    zstyle ':vcs_info:git*+set-message:*' hooks git-stash git-status git-remote 

    pr_rlines=()

    if [[ -n ${pr_com[vcs]} ]]; then
        pr_rlines[1]=( "${pr_rlines[1]} ${pr_com[vcs]}" )
    else
        pr_rlines[1]=( "${pr_rlines[1]} %{$fg_bold[green]%}[%w %*]%{$reset_color%}" )
    fi
}

# Show the cwd in green if writable, yellow otherwise
function +pr-pwd() {
    local -a v_pwd i_pwd
    zstyle -g i_pwd ":pr_variable:*" pwd

    [[ -w $PWD ]] && v_pwd+=( ${blue} ) || v_pwd+=( ${yellow} )
    v_pwd+=( ${i_pwd} )
    v_pwd+=( ${reset} )
    pr_com[pwd]=${(j::)v_pwd}
}

# Show the current user, also show the host if SSH'ed in from somewhere
function +pr-usr() {
    local -a v_usr i_usr i_host
    zstyle -g i_usr ":pr_variable:*" usr
    zstyle -g i_host ":pr_variable:*" host

    v_usr+=( ${green} )
    v_usr+=( ${i_usr} )
    [[ -n $SSH_CLIENT ]] && v_usr+=( "${white}@%{$FG178%}${i_host}" )

    pr_com[usr]=${(j::)v_usr}
}

function +pr-task() {
    local -a v_task

    [[ ! -n ${TASK_SECTION} ]] && return

    if [[ "${PS_LEFT}" = "detail" ]]; then
        v_task=(
            ${yellow_on_black}
            "$(basename ${TASK_SECTION})"
            ${reset}
        )
    else
        v_task=(
            ${yellow_on_black}
            ${symbol_task}
            ${reset}
        )
    fi

    pr_com[task]=${(j::)v_task}
}

# Show info collected from vcs_info
function +pr-vcs() {
    local -a v_vcs

    if [[ -n ${vcs_info_msg_0_} ]]; then
       v_vcs=( ${vcs_info_msg_0_} )
    fi

    pr_com[vcs]="${(j::)v_vcs}"
}

# Show virtualenv information
# TODO: possible to visually overlay this info with pwd if they overlap?
function +pr-venv() {
    local -a v_venv

    [[ -n ${VIRTUAL_ENV} ]] && v_venv=(
        ${grey}
        "($(basename ${VIRTUAL_ENV}))"
        ${reset}
    )

    pr_com[venv]=${(j::)v_venv}
}

# Show number of background jobs, or hide if none
function +pr-jobs() {
    local v_jobs="%j"
    local n_jobs=${(%)v_jobs}
    local -a v_vjobs

    [[ n_jobs -gt 0 ]] && v_vjobs=(
        ${magenta}
        "Jobs "
        "${white}[${red}${n_jobs}${white}]"
        ${reset}
    )

    pr_com[jobs]=${(j::)v_vjobs}
}

# Show the shell prompt, red if the last exit code was non-zero
function +pr-prompt() {
    local -a v_prompt
    v_prompt=(
        "%(0?.${yellow}.${red})➦ "
        ${reset}
    )
    pr_com[prompt]=${(j::)v_prompt}
}

# vcs_info functions ##########################################################

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-remote() {
    local ahead behind remote
    local -a gitremote

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name --abbrev-ref 2>/dev/null)}

    if [[ -n ${remote} ]] ; then
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l | sed 's/^[ \t]*//;s/[ \t]*$//')
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l | sed 's/^[ \t]*//;s/[ \t]*$//')

        if [[ $ahead -gt 0 && $behind -gt 0 ]]; then
            gitremote+=( "${white}${ahead}${symbol_ahead} ${red}${symbol_diverge} ${white}${symbol_behind}${behind}${reset}" )
        elif [[ $ahead -gt 0 ]]; then
            gitremote+=( "${white}${ahead}${symbol_ahead} ${red}${symbol_push} ${white}${symbol_behind}-${reset}" )
        elif [[ $behind -gt 0 ]]; then
            gitremote+=( "${white}-${symbol_ahead} ${red}${symbol_fastforward} ${white}${symbol_behind}${behind}${reset}" )
        fi

        if [[ -n ${gitremote} ]]; then
            hook_com[branch]="${gitremote} ${yellow}${hook_com[branch]} ${symbol_track} ${remote//\/${hook_com[branch]}/}"
        else
            hook_com[branch]="${yellow}${hook_com[branch]} ${symbol_track} ${remote//\/${hook_com[branch]}/}"
        fi
    elif [[ ${hook_com[branch]} =~ '^tags\/' ]] ; then
        hook_com[branch]="${red}${symbol_tag}${white}${hook_com[branch]}"
    else
        hook_com[branch]="${yellow}${remote}${symbol_local_branch} ${hook_com[branch]}"
    fi
}

# Show count of stashed changes
function +vi-git-stash() {
    if [[ -s $(git rev-parse --git-dir)/refs/stash ]] ; then
        hook_com[misc]="${yellow_on_black}${symbol_status_stash}${reset}${hook_com[misc]}"
    else
        hook_com[misc]="${cyan_on_black}${symbol_status_stash}${reset}${hook_com[misc]}"
    fi
}

function +vi-git-status() {
    local git_status="$(git status --porcelain 2> /dev/null)"
    local -a stagedstr

    if [[ "${PS_RIGHT}" = "detail" ]]; then
        stagedstr=( 
            "${cyan_on_black}"
            "${symbol_status_untrack}"
            "${symbol_status_add}${symbol_status_add_desc}" 
            "${symbol_status_modify}${symbol_status_modify_desc}" 
            "${symbol_status_del}${symbol_status_del_desc}" 
            "${symbol_status_modify}" 
            "${symbol_status_del}" 
            "${symbol_status_ready_commit}" 
            ${reset}
        )
    else
        stagedstr=( 
            "${cyan_on_black}"
            "${symbol_status_untrack}"
            "${symbol_status_add}" 
            "${symbol_status_modify}" 
            "${symbol_status_del}" 
            "${symbol_status_modify}" 
            "${symbol_status_del}" 
            "${symbol_status_ready_commit}" 
            ${reset}
        )
    fi

    if [[ $(\grep -c "^??" <<< "${git_status}") -gt 0 ]]; then stagedstr[2]="${red_on_black}${stagedstr[2]}${cyan_on_black}"; fi
    if [[ $git_status =~ ($'\n'|^)A ]]; then stagedstr[3]="${red_on_black}${stagedstr[3]}${cyan_on_black}"; fi
    if [[ $git_status =~ ($'\n'|^).M ]]; then stagedstr[4]="${red_on_black}${stagedstr[4]}${cyan_on_black}"; fi
    if [[ $git_status =~ ($'\n'|^).D ]]; then stagedstr[5]="${red_on_black}${stagedstr[5]}${cyan_on_black}"; fi
    if [[ $git_status =~ ($'\n'|^)M ]]; then stagedstr[6]="${yellow_on_black}${stagedstr[6]}${cyan_on_black}"; fi
    if [[ $git_status =~ ($'\n'|^)D ]]; then stagedstr[7]="${yellow_on_black}${stagedstr[7]}${cyan_on_black}"; fi
    if [[ $git_status =~ ($'\n'|^)[MAD] && ! $git_status =~ ($'\n'|^).[MAD\?] ]]; then stagedstr[8]="${red_on_black}${stagedstr[8]}"; fi

    hook_com[staged]="${(j::)stagedstr}"
}

# execute the above prompt functions ##########################################

function precmd_prompt_left {
    local func

    # Clear out old values
    pr_com=()
    pr_llines=()

    pr_run_hooks "hooks_left"

    # Use the above data and build the prompt arrays
    func="+pr-left"
    ${func} "$@"

    # Set the prompts
    PROMPT='${(F)pr_llines}'
}

ASYNC_PROC=0
function precmd_prompt_right {

    RPROMPT=''
    [[ "${PS_RIGHT}" = "noinfo" ]] && return 0

    if [[ "${ASYNC_PROC}" != 0 ]]; then
        return 0
        #kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi

    function async() {
        local func
        local jobs_info=$1

        pr_rlines=()

        vcs_info
        +pr-vcs "$@"
        +pr-right "$@"

        print "$jobs_info${(F)pr_rlines}" > "${HOME}/.zsh_tmp_prompt"

        # send signal to parent
        kill -s USR1 $$
    }

    async ${pr_com[jobs]} &!
    ASYNC_PROC=$!
}

function TRAPUSR1() {
    RPROMPT="$(cat ${HOME}/.zsh_tmp_prompt)"
    ASYNC_PROC=0
    zle && zle .reset-prompt
}
