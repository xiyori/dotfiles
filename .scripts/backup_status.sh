#!/bin/bash

if [[ "$(systemctl is-active proxmox-backup.service)" != "inactive" ]] ; then
  echo "{\"text\": \" \",\"tooltip\":\"Backup in progress\nShutdown inhibited\"}"
else
  echo ""
fi
