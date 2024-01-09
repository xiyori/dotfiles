if status is-interactive
    # Commands to run in interactive sessions can go here

    set PATH "$PATH:/home/sergej/.cargo/bin"

    set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
    source /usr/share/powerline/bindings/fish/powerline-setup.fish
    powerline-setup

    set fish_greeting
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/sergej/anaconda3/bin/conda
    eval /home/sergej/anaconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

