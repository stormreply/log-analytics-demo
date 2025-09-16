#!/bin/bash

echo "BEGIN -- 03-install-apache-fake-log-gen.sh"

sudo pip install numpy
sudo pip install faker
sudo pip install tzlocal

python3 apache-fake-log-gen.py -n 600 &

sleep 1

echo "END ---- 03-install-apache-fake-log-gen.sh"
