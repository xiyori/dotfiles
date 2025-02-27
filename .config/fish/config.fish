if status is-interactive
    # Commands to run in interactive sessions can go here

    set PATH "$PATH:$HOME/.cargo/bin"

    set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
    source /usr/share/powerline/bindings/fish/powerline-setup.fish
    powerline-setup

    alias yay_tor="env https_proxy=socks5://127.0.0.1:9050 http_proxy=socks5h://127.0.0.1:9050 yay"

    #set fish_greeting "$(systemctl is-active --quiet fancontrol.service || printf '\033[0;31m##########################\nATTENTION! Fancontrol is not running\n##########################\033[0m')"

    set VIRTUAL_ENV_DISABLE_PROMPT 1
end
