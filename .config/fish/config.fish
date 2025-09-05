if status is-interactive
    # Commands to run in interactive sessions can go here

    set PATH "$PATH:$HOME/.cargo/bin"

    set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
    source /usr/share/powerline/bindings/fish/powerline-setup.fish
    powerline-setup

    set fish_greeting ""
    # set fish_greeting "$(systemctl is-active --quiet fancontrol.service || printf '\033[0;31m##########################\nATTENTION! Fancontrol is not running\n##########################\033[0m')"

    set -x SYSTEMD_EDITOR nvim

    set VIRTUAL_ENV_DISABLE_PROMPT 1
end
