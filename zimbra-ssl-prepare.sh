#!/bin/sh

#made with love

apt install snapd

snap install core
snap refresh core

snap install --classic certbot
