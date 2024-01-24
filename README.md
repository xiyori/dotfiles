# xiyori's dotfiles

*TODO: here are exampes of rice*

Initial scripts and configs are from

https://github.com/PROxZIMA/.dotfiles

https://github.com/AmitGolden/dotfiles

https://github.com/rustybucketz30/dotfiles

Look up the exact attribution in the dotfiles.

## Before installation

Please, check the install script before running it. The script is intended for clean base systems, installing it in a working setup is **not** recommended!

If you wish to install optional packages, edit your `/etc/pacman.conf` to include `multilib` repo:

```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

## Installation

Run `./install.sh` from the repo directory. Minimum requirements are `base`, `base-devel`.

## Touhou

To play Touhou games, install

`pacman -S wine-staging winetricks wine-mono lib32-mesa-libgl lib32-gnutls lib32-alsa-plugins lib32-libpulse lib32-openal vulkan-radeon lib32-vulkan-radeon gamescope`

and use `th` script to run your games.
