#!/bin/bash

# Настройка контроллера домена FreeIPA

# Отключение NetworkManager
for service in NetworkManager; do systemctl stop $service; systemctl disable $service; systemctl mask $service; done

# Настройка сетевых интерфейсов и рестарт сетевого сервиса
connections=$(ifconfig -s | awk '{print $1}')
static_interface=$(echo $connections | awk '{print $2}')
dynamic_interface=$(echo $connections | awk '{print $3}')
echo -e "\nauto $static_interface" "\niface $static_interface inet static" "\naddress 192.168.0.1" "\nnetmask 24" "\ndns-nameservers 127.0.0.1" "\ndns-search corp.test" | tee -a /etc/network/interfaces
echo -e "\nauto $dynamic_interface" "\niface $dynamic_interface inet dhcp" | tee -a /etc/network/interfaces
systemctl restart networking.service

# Обновление данных по необходимым репозиториям
sed -i '/deb cdrom/s/^/#/' /etc/apt/sources.list && sed -i '/\_x86-64\/repository-main/s/^#\+//' /etc/apt/sources.list && sed -i '/\_x86-64\/repository-update/s/^#\+//' /etc/apt/sources.list
apt update

# Настройка адреса для DNS и указание FQDN компьютера
echo -e "\nnameserver 127.0.0.1" "\nsearch corp.test" | tee -a /etc/resolv.conf
hostnamectl set-hostname dc1.corp.test

# Установка пакетов FreeIPA и настройка домена
DEBIAN_FRONTEND=noninteractive apt-get install -y -q astra-freeipa-server
astra-freeipa-server -n dc1 -d corp.test -ip 192.168.0.1 -p P@ssw0rd! -y

# Запрет файла /etc/resolv.conf на изменение
chattr +i /etc/resolv.conf

# Установка драйверов vmware и перезапуск компьютера
apt install open-vm-tools open-vm-tools-desktop -y
init 6
