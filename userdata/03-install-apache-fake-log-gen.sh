#!/bin/bash

echo "BEGIN -- 03-install-apache-fake-log-gen.sh"

sudo pip install pytz
sudo pip install numpy
sudo pip install faker
sudo pip install tzlocal

curl http://github.com/kiritbasu/Fake-Apache-Log-Generator/blob/master/apache-fake-log-gen.py \
   > apache-fake-log-gen.py

python3 apache-fake-log-gen.py -n 0 -o LOG -p /apache/logs/ &

sleep 1

echo "END ---- 03-install-apache-fake-log-gen.sh"
