#!/bin/bash

( systemctl is-active --quiet fancontrol.service && systemctl is-active --quiet monitor-temp.service ) || echo "{\"text\":\" \",\"tooltip\":\"Fancontrol is not running\"}"
