#!/usr/bin/bash

print_help () {
    echo "Usage: $0 [TARGET] [OPTION]"
    echo
    echo "Install xiyori's dotfiles."
    echo
    echo "TARGETS:"
    echo "  essential             install essential packages"
    echo "  optional              install optional programs from rice video"
    echo "  extra                 install xiyori's personal apps"
    echo "  all                   all of the above"
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

install_essential () {
    echo "installing essential packages"
    packages=(
        # Package Management & Utilities
        "pacman-contrib" # pacman utilities
        
        # Terminals & Shells
        "alacritty" # for terminal management
        "fish" # friendly interactive shell
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

    # Symlinks
    echo "creating symlinks"

    _create_symlink .scripts
    _create_symlink .bash_profile
    _create_symlink .gtkrc-2.0
    _create_symlink .vimrc
    _create_symlink .config/alacritty/alacritty.toml
    _create_symlink .config/fish/config.fish
    _create_symlink .config/fontconfig/fonts.conf
    _create_symlink .config/gtk-3.0/settings.ini
    _create_symlink .config/hypr
    _create_symlink .config/nvim
    _create_symlink .config/powerline
    _create_symlink .config/waybar
    _create_symlink .config/wlogout
    _create_symlink .config/wofi
    _create_symlink .config/chromium-flags.conf
    _create_symlink .config/code-flags.conf
    _create_symlink .config/electron-flags.conf
    _create_symlink .config/mimeapps.list

    # For the proper starting of terminal apps from GTK
    sudo ln -s "$(pwd)/xdg-terminal-exec" /usr/bin/xdg-terminal-exec
    
    # gsettings
    gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Blue-Dark'
    # gsettings set org.gnome.desktop.interface font-name 'Noto Sans'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'

    # App themes
    # We use Alacritty's default Linux config directory as our storage location here.
    mkdir -p ~/.config/alacritty/themes
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

    # Services
    sudo systemctl enable bluetooth.service
    systemctl --user enable pipewire pipewire-pulse wireplumber
    systemctl --user enable xfce4-notifyd.service
    systemctl --user enable mpris-proxy.service
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
        "wofi-emoji" # emoji picker
        "noto-fonts-emoji" # emoji font
        "hyprpicker" # color picker
        "imagemagick" # for color picker script
        "tty-clock" # to flex
        "calcurse" # to plan while flexing
        "cmus" # musical flex
        "cava" # saem
    )
    install "${packages[@]}"

    # Symlinks
    echo "creating symlinks"

    _create_symlink .config/btop/btop.conf
    _create_symlink .config/calcurse/conf
    _create_symlink .config/calcurse/keys
    _create_symlink .config/cava/config
    _create_symlink .config/neofetch

    # App themes
    mkdir -p "$(bat --config-dir)/themes"
    git clone https://github.com/catppuccin/bat.git "$(bat --config-dir)/themes"

    git clone https://github.com/catppuccin/btop.git
    sudo cp btop/themes/* /usr/share/btop/themes/

    git clone https://github.com/Sekki21956/cmus.git
    sudo cp cmus/catppuccin.theme /usr/share/cmus/
}

install_extra () {
    echo "installing extra packages"
    packages=(
        "tigervnc"
        "font-manager"
        "firefox"
        "gimp"
        "mpv"
        "sshfs"
        "code"
        "code-features"
        "wireguard-tools"
        "android-file-transfer"
        "noto-fonts-cjk"
        "vim-commentary"
        "vim-jedi"
        "qalculate-gtk"
        "wev"
        "torbrowser-launcher"
        "libdbus-glib-1-2"
        "tldr"
        "greetd"
    )
    install "${packages[@]}"

    # Symlinks
    echo "creating symlinks"

    _create_symlink .config/GIMP/2.10/gimprc
    _create_symlink .config/GIMP/2.10/menurc
    _create_symlink .config/GIMP/2.10/sessionrc
    _create_symlink .config/GIMP/2.10/toolrc

    sudo ln -s "$(pwd)/config.toml" /etc/greetd/config.toml
    sudo ln -s "$(pwd)/resolved.conf" /etc/systemd/resolved.conf
    sudo ln -s /usr/bin/resolvectl /usr/local/bin/resolvconf

    # Services
    sudo systemctl enable greetd.service
    sudo systemctl enable systemd-resolved.service
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
    extra)
        install_yay
        install_extra
    ;;
    all)
        install_yay
        install_essential
        install_optional
        install_extra
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
