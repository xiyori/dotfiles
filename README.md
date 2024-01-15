# xiyori's dotfiles

-- here are exampes of rice

## Before installation

Check the install script, it **deletes** files like `.bashrc` and `.bash_profile`! The script is intended for clean base systems, installing it in a working setup is **not** recommended!

If you wish to install optional packages, edit your `/etc/pacman.conf` to include `multilib` repo:

```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

## Installation

Run `./install.sh` from the repo directory. Minimum requirements are `base`, `base-devel`.

remove user install: qt6-base qt6-wayland sdbus-cpp

## Touhou

To play Touhou games, install

`pacman -S wine-staging winetricks wine-mono lib32-mesa-libgl lib32-gnutls lib32-alsa-plugins lib32-libpulse lib32-openal vulkan-radeon lib32-vulkan-radeon gamescope`

and use `th` script to run your games.
