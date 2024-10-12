if status is-interactive
    # Commands to run in interactive sessions can go here

    set PATH "$PATH:$HOME/.cargo/bin"

    set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
    source /usr/share/powerline/bindings/fish/powerline-setup.fish
    powerline-setup

    set fish_greeting

    set VIRTUAL_ENV_DISABLE_PROMPT 1

    bind \b 'backward-kill-word'
end
