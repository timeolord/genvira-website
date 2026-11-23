#! /bin/bash

cd ~/genvira/
git pull
hugo
sudo rm -r /var/www/html/*
sudo cp -ar public/* /var/www/html/
