#!/usr/bin/env bash

mkdir -p $HOME/src
wget http://selenium-release.storage.googleapis.com/2.48/selenium-server-standalone-2.48.2.jar
nohup java -jar selenium-server-standalone-2.48.2.jar &
echo "Running with Selenium..."
sleep 10
