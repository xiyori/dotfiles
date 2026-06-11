#!/bin/bash

systemctl is-active --quiet fancontrol.service || echo "{\"text\":\" \",\"tooltip\":\"Fancontrol is not running\"}"
