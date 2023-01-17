#! /bin/bash
sudo dnf update -y
sudo dnf install epel-release -y
sudo dnf install nginx -y
sudo dnf install git -y
sudo systemctl enable nginx
sudo systemctl start nginx