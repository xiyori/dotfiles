# xiyori's dotfiles

-- here are exampes of rice

## Before installation

Check the install script, it deletes files like `.bashrc` and `.bash_profile`!!! The script is intended for clean base systems, installing it in a working setup is **not** recommended!

If you wish to install optional packages, edit your `/etc/pacman.conf` to include `multilib` repo.

`
[multilib]
Include = /etc/pacman.d/mirrorlist
`
For the proper starting of terminal apps from GTK, you may symlink

`sudo ln -s "$(pwd)/xdg-terminal-exec" "/usr/bin/xdg-terminal-exec"`

## Installation

Run `./install.sh` from the repo directory.
