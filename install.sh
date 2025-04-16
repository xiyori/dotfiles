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
        git clone https://aur.archlinux.org/yay.git yay
        cd yay
        makepkg -si
        cd ..
        echo "yay has been installed"
        echo
    fi
}

install () {
    yay -S --needed $*
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
        "neovim-catppuccin"
        
        # Launchers & Notifications
        "rofi-lbonn-wayland-git" # for launching applications
        "xfce4-notifyd" # for notifications
        
        # Desktop Customization
        "swww" # for wallpapers
        "lxappearance-gtk3" # for theming
        "catppuccin-gtk-theme-mocha" # for theming
        "bibata-cursor-theme" # for theming
        "papirus-icon-theme" # for theming
        "papirus-folders" # for theming
        
        # File Management & Utilities
        "thunar"
        "xfce4-settings"
        "catfish"
        "gvfs"
        "tumbler"
        "thunar-volman"
        "thunar-archive-plugin"
        "thunar-media-tags-plugin"
        "engrampa"
        
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
        "mpris-proxy-service"
        "carla" # equal loudness system volume
        "lsp-plugins-lv2"
        "alsa-utils"
        "jq" # for waybar json scripting
        "bc" # for auto gain scripting
        
        # Desktop Integration
        "xdg-desktop-portal-gtk" # needed for theming
        "xdg-desktop-portal-wlr" # needed for theming

        # Screenshot
        "grim"
        "slurp"
        "wl-clipboard"
        "wl-clip-persist"
        "cliphist"

        # System
        "brightnessctl" # screen brightness
        "wlogout" # power menu
        "wlsunset" # night light (redshift)
        "socat" # for hyprland socket scripts
        "python-requests" # for wttr script
        "polkit-gnome" # auth dialogs
        "hyprlock" # lock screen
        "hypridle" # turn off screen
        "xorg-xrdb" # for .Xresources
        "xorg-xsetroot" # for cursor size stability

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
    )
    install "${packages[@]}"

    # Symlinks
    echo "creating symlinks"

    _create_symlink .scripts
    _create_symlink .gtkrc-2.0
    _create_symlink .vimrc
    _create_symlink .Xresources
    _create_symlink .config/alacritty/alacritty.toml
    _create_symlink .config/fish/config.fish
    _create_symlink .config/fontconfig/fonts.conf
    _create_symlink .config/gtk-3.0/settings.ini
    _create_symlink .config/hypr
    _create_symlink .config/myeffects
    _create_symlink .config/nvim
    _create_symlink .config/pipewire
    _create_symlink .config/powerline
    _create_symlink .config/waybar
    _create_symlink .config/wlogout
    _create_symlink .config/rofi
    _create_symlink .config/chromium-flags.conf
    _create_symlink .config/code-flags.conf
    _create_symlink .config/electron-flags.conf
    _create_symlink .config/mimeapps.list
    _create_symlink .config/systemd/user/auto-monitor.service
    _create_symlink .config/systemd/user/switch-out-from-empty.service

    ln -s "$(pwd)/assets/hrir_hesuvi" ~/hrir_hesuvi

    echo "setting up packages"

    # For MIDI loudness control
    echo "snd-virmidi" | sudo tee -a /etc/modules-load.d/virmidi.conf > /dev/null

    # For the proper starting of terminal apps from GTK
    sudo ln -s "$(pwd)/.scripts/xdg-terminal-exec" /usr/bin/xdg-terminal-exec
    
    # gsettings
    gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-mauve-standard+default-dark'
    gsettings set org.gnome.desktop.interface font-name 'Noto Sans 11'
    gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans 11'
    gsettings set org.gnome.desktop.interface monospace-font-name 'Noto Sans Mono 11'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'

    # App themes
    papirus-folders -C violet --theme Papirus-Dark
    
    # We use Alacritty's default Linux config directory as our storage location here.
    mkdir -p ~/.config/alacritty/themes
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

    git clone https://github.com/catppuccin/rofi
    mkdir -p ~/.local/share/rofi/themes/
    cp rofi/basic/.local/share/rofi/themes/* ~/.local/share/rofi/themes/

    # Services
    sudo cp configs/monitor-temp.service /usr/lib/systemd/system/monitor-temp.service
    sudo ln -s "$(pwd)/.scripts/monitor-temp.sh" /usr/local/bin/monitor-temp.sh
    sudo systemctl enable monitor-temp.service

    sudo ufw enable
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable ufw.service
    sudo systemctl enable bluetooth.service
    sudo systemctl enable systemd-timesyncd.service
    systemctl --user enable pipewire pipewire-pulse wireplumber
    systemctl --user enable mpris-proxy.service
    systemctl --user enable auto-monitor.service
    systemctl --user enable switch-out-from-empty.service
}

install_optional () {
    echo "installing optional packages"
    packages=(
        # System Info Display
        "fastfetch" # to flex
        "cmatrix-git" # for fun
        "btop" # for performance monitoring
        "bat" # cat with the looks
        "ristretto" # image viewer
        "qimgv-git" # image viewer
        "rofi-emoji-git" # emoji picker
        "noto-fonts-emoji" # emoji font
        "hyprpicker" # color picker
        "imagemagick" # for color picker script
        "tty-clock" # to flex
        "calcurse" # to plan while flexing
        "cmus" # musical flex
        "cava" # saem
        "qalculate-gtk" # calculator
        "lsd" # next gen ls
    )
    install "${packages[@]}"

    # Symlinks
    echo "creating symlinks"

    _create_symlink .config/btop/btop.conf
    _create_symlink .config/calcurse/conf
    _create_symlink .config/calcurse/keys
    _create_symlink .config/cava/config

    echo "setting up packages"
    
    # Cmus status
    mkdir -p ~/.local/state/cmus_status/cover
    mkdir -p ~/.local/share/icons
    ln -s "$(pwd)/assets/placeholder.png" ~/.local/state/cmus_status/placeholder.png
    ln -s "$(pwd)/assets/cmus.svg" ~/.local/share/icons/cmus.svg
    desktop-file-install --dir=$HOME/.local/share/applications configs/cmus.desktop

    # App themes
    git clone https://github.com/catppuccin/bat.git "$(bat --config-dir)"
    bat cache --build

    git clone https://github.com/catppuccin/btop.git
    sudo cp btop/themes/* /usr/share/btop/themes/

    git clone https://github.com/Sekki21956/cmus.git
    sudo cp cmus/catppuccin.theme /usr/share/cmus/
}

install_extra () {
    echo "installing extra packages"
    packages=(
        "font-manager"
        "firefox"
        "telegram-desktop"
        "gimp"
        "mpv"
        "mpv-mpris"
        "openssh"
        "sshfs"
        "libreoffice-still"
        "libreoffice-still-ru"
        "networkmanager-openconnect"
        "code"
        "code-features"
        "wireguard-tools"
        "systemd-resolvconf"
        "android-file-transfer"
        "noto-fonts-cjk"
        "dconf-editor"
        "vim-commentary"
        "vim-supertab"
        "vim-jedi"
        "vim-suda-git"
        "python-pynvim"
        "pavucontrol"
        "wev"
        "torbrowser-launcher"
        "obfs4proxy"
        "dbus-glib"
        "tldr"
        "greetd"
        "obs-studio"
        "cups"
        "cups-pdf"
        "system-config-printer"
        "nss-mdns"
        "joplin-appimage"
        "rnote"
        "rsync"
    )
    install "${packages[@]}"

    # Symlinks
    echo "creating symlinks"

    _create_symlink .config/GIMP/2.10/gimprc
    _create_symlink .config/GIMP/2.10/menurc
    _create_symlink .config/GIMP/2.10/sessionrc
    _create_symlink .config/GIMP/2.10/toolrc

    sudo rm /etc/greetd/config.toml
    sudo ln -s "$(pwd)/configs/config.toml" /etc/greetd/config.toml
    
    sudo mkdir /etc/systemd/resolved.conf.d
    sudo cp configs/20-dns-servers.conf /etc/systemd/resolved.conf.d/

    sudo rm /etc/resolv.conf
    sudo ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
    
    sudo ln -s "$(pwd)/configs/90-dns-over-tls.conf" /etc/NetworkManager/conf.d/90-dns-over-tls.conf

    # Services
    sudo systemctl enable greetd.service
    sudo systemctl enable systemd-resolved.service
    sudo systemctl enable cups.socket
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
