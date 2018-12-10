
# Dean's tmux.aliases.sh v1.0.0
#
# Installation:
#
#   curl https://raw.githubusercontent.com/deanrather/dotfiles/master/tmux.aliases.sh >> ~/.bash_aliases
#

alias tns="tmux new-session -s"  # requires session-name
alias tls="tmux list-sessions"
alias tas="tmux attach -t"       # requires session-name
alias tds="tmux detach-client"   # detach this client from session
alias tks="tmux kill-session -t" # requires session-name
alias tmux-help="grep -Pzo '# Summary(.|\n)*\n# Config' ~/.tmux.conf | head -n -2 | sed 's/^#//g' | sed 's/^ //g'"


# Completions
function _autocomplete_tmux_sessions() {
    options="$(tmux list-sessions | cut -d ':' -f 1)"

    local cur
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
}

complete -F _autocomplete_tmux_sessions tas
complete -F _autocomplete_tmux_sessions tks
