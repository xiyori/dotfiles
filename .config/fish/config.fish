if status is-interactive
    # Commands to run in interactive sessions can go here

    set PATH "$PATH:$HOME/.cargo/bin"

    set --global fish_key_bindings fish_default_key_bindings

    set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
    source /usr/share/powerline/bindings/fish/powerline-setup.fish
    powerline-setup

    set fish_greeting ""
    # set fish_greeting "$(systemctl is-active --quiet fancontrol.service || printf '\033[0;31m##########################\nATTENTION! Fancontrol is not running\n##########################\033[0m')"

    bind ctrl-w backward-kill-word
    bind ctrl-left backward-word
    bind ctrl-right forward-word

    alias docker="sudo /usr/bin/docker"
    set -x SYSTEMD_EDITOR nvim

    set VIRTUAL_ENV_DISABLE_PROMPT 1
    set fish_color_command blue

    # Add pyenv executable to PATH by running
    # the following interactively:

    # set -Ux PYENV_ROOT /mnt/data/.pyenv
    # set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

    # Load pyenv automatically by appending
    # the following to ~/.config/fish/config.fish:

    # pyenv init - fish | source
end
