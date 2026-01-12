if status is-interactive
    # Commands to run in interactive sessions can go here

    set PATH "$PATH:$HOME/.cargo/bin"

    set --global fish_key_bindings fish_default_key_bindings

    set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
    source /usr/share/powerline/bindings/fish/powerline-setup.fish
    powerline-setup

    set fish_greeting ""
    # set fish_greeting "$(systemctl is-active --quiet fancontrol.service || printf '\033[0;31m##########################\nATTENTION! Fancontrol is not running\n##########################\033[0m')"

    bind \cw backward-kill-word

    alias docker="sudo /usr/bin/docker"
    alias vim="nvim"

    set -x SYSTEMD_EDITOR nvim

    set VIRTUAL_ENV_DISABLE_PROMPT 1
    set fish_color_command blue
end
