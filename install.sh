#!/usr/bin/bash

print_help () {
    echo "Usage: $0 [TARGET] [OPTION]"
    echo
    echo "Install xiyori's dotfiles."
    echo
    echo "TARGETS:"
    echo "  essential             install essential packages"
    echo "  optional              install optional programs from rice video"
    echo "  symlinks              create symlinks for dotfiles"
    echo "  all                   all of the above"
    echo "  extra                 install xiyori's personal apps"
    echo "    if no target is given, display the help screen"
    echo
    echo "OPTIONS:"
    echo "  -h, --help            display this help screen and exit"
}

install_yay () {
    if sudo pacman -Qs yay > /dev/null ; then
        echo "yay is installed"
    else
        echo "yay is not installed, installing now"
        git clone https://aur.archlinux.org/yay-git.git yay-git
        cd yay-git
        makepkg -si
        cd ..
        echo "yay has been installed"
        echo
    fi
}

install () {
    packages=$(printf " %s" "$1[@]")
    yay -S $packages
}

install_essential () {
    echo "installing essential packages"
    packages=(
        # Package Management & Utilities
        "pacman-contrib" # pacman utilities
        
        # Terminals & Shells
        "alacritty" # for terminal management
        "powerline" # for CLI customization
        
        # Text Editors
        "neovim"
        
        # Launchers & Notifications
        "wofi" # for launching applications
        "xfce4-notifyd" # for notifications
        
        # Desktop Customization
        "swww" # for wallpapers
        "lxappearance" # for theming
        "catppuccin-gtk-theme-mocha" # for theming
        "bibata-cursor-theme" # for theming
        
        # File Management & Utilities
        "thunar"
        "catfish"
        "gvfs"
        "tumbler"
        "thunar-volman"
        "thunar-archive-plugin"
        "thunar-media-tags-plugin"
        "file-roller"
        
        # Fonts
        "ttf-firacode-nerd"
        "noto-fonts"

        # Sound
        "pipewire"
        "pipewire-jack"
        "pipewire-alsa"
        "pipewire-pulse"
        "wireplumber"
        "playerctl"
        
        # Desktop Integration
        "xdg-desktop-portal-gtk" # needed for theming
        "xdg-desktop-portal-wlr" # needed for theming

        # Screenshot
        "grim"
        "slurp"
        "wl-clipboard"

        # System
        "brightnessctl" # screen brightness
        "wlogout" # power menu
        "socat" # for hyprland socket scripts
        "python-requests" # for wttr script
        "polkit-gnome" # auth dialogs
        "swaylock-effects" # lock screen

        # wifi - network management
        "networkmanager" # for network management
        "network-manager-applet" # the GUI network manager
        "ufw" # firewall

        # Bluetooth
        "blueman"
        "bluez"
        "bluez-utils"

        # Hyprland
        "hyprland" # window manager
        "waybar" # for status bar 
        "waybar-hyprland"
    )
    install "${packages[@]}"
    echo
    echo "setting up packages"

    # Services


    # For the proper starting of terminal apps from GTK
    sudo ln -s "$(pwd)/xdg-terminal-exec" "/usr/bin/xdg-terminal-exec"
    
    # gsettings
    gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Blue-Dark'
    # gsettings set org.gnome.desktop.interface font-name 'Noto Sans'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'

    # App themes
    # We use Alacritty's default Linux config directory as our storage location here.
    mkdir -p ~/.config/alacritty/themes
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

    mkdir -p "$(bat --config-dir)/themes"
    git clone https://github.com/catppuccin/bat.git "$(bat --config-dir)/themes"

    git clone https://github.com/catppuccin/btop.git
    sudo cp btop/themes/* /usr/share/btop/themes/


}

install_optional () {
    echo "installing optional packages"
    packages=(
        # System Info Display
        "neofetch" # to flex
        "cmatrix-git" # for fun
        "btop" # for performance monitoring
        "bat" # cat with the looks
        "ristretto" # image viewer
        "udev-block-notify" # filesystem notifications
        "wofi-emoji" # emoji picker
        "noto-fonts-emoji" # emoji font
        "hyprpicker" # color picker
        "imagemagick" # for color picker script
        "tty-clock" # to flex
        "calcurse" # to plan while flexing
        "cava" # musical flex
    )
    install "${packages[@]}"
}

install_extra () {
    echo "installing extra packages"
    packages=(
        "tigervnc"
        "font-manager"
        "firefox"
        "sshfs"
        "code"
        "code-features"
        "wireguard-tools"
        "android-file-transfer"
        "noto-fonts-cjk"
        "vim-commentary"
        "qalculate-gtk"
        "wev"
        "torbrowser-launcher"
        "libdbus-glib-1-2"
        "tldr"
        "greetd"
    )
    install "${packages[@]}"
}

_create_symlink () {
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
    echo "creating symlinks"
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
    _create_symlink .config/powerline
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
        install_yay
        install_essential
    ;;
    optional)
        install_yay
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
