#!/usr/bin/bash

print_help () {
    echo "Usage: $0 [TARGET] [OPTION]"
    echo
    echo "Install xiyori's dotfiles."
    echo
    echo "TARGETS:"
    echo "  essential             install essential packages"
    echo "  optional              install optional programs"
    echo "  symlinks              create symlinks for dotfiles"
    echo "  all                   all of the above"
    echo "    if no target is given, display the help screen"
    echo
    echo "OPTIONS:"
    echo "  -h, --help            display this help screen and exit"
}

install_essential () {
    echo "installing essential packages"

}

install_optional () {
    echo "installing optional packages"
}

_create_symlink() {
    mkdir -p "$(dirname ~/"$1")"
    
    # Remove existing symlink, directory, or file at the target location
    [ -L ~/"$1" ] && { rm ~/"$1"; echo -n "old symlink removed, "; }
    [ -d ~/"$1" ] && { rm -rf ~/"$1"; echo -n "old directory removed, "; }
    [ -f ~/"$1" ] && { rm ~/"$1"; echo -n "old file removed, "; }
    
    # Create new symlink
    ln -s "$(pwd)/$1" ~/"$1"
    echo "created symlink ~/$1"
}

create_symlinks () {
    _create_symlink .scripts
    _create_symlink .xserverrc
    _create_symlink .bash_profile
    _create_symlink .bashrc
    _create_symlink .gtkrc-2.0
    _create_symlink .vimrc
    _create_symlink .config/alacritty/alacritty.toml
    _create_symlink .config/btop/btop.conf
    _create_symlink .config/calcurse/conf
    _create_symlink .config/calcurse/keys
    _create_symlink .config/cava/config
    _create_symlink .config/fish/config.fish
    _create_symlink .config/fontconfig/fonts.conf
    _create_symlink .config/gtk-3.0/settings.ini
    _create_symlink .config/hypr
    _create_symlink .config/neofetch
    _create_symlink .config/nvim
    # _create_symlink .config/powerline
    _create_symlink .config/waybar
    _create_symlink .config/wlogout
    _create_symlink .config/wofi
    _create_symlink .config/chromium-flags.conf
    _create_symlink .config/code-flags.conf
    _create_symlink .config/electron-flags.conf
    _create_symlink .config/mimeapps.list
}


if [[ "$#" > 2 ]]; then
    echo "ERROR: too many arguments"
    echo
    print_help
    exit 1
fi

case "$1" in
    essential)
        install_essential
    ;;
    optional)
        install_optional
    ;;
    symlinks)
        create_symlinks
    ;;
    all)
        install_essential
        install_optional
        create_symlinks
    ;;
    ""|-h|--help)
        print_help
        exit 0
    ;;
    *)
        echo "ERROR: '$1' is not a valid option"
        echo
        print_help
        exit 1
    ;;
esac
