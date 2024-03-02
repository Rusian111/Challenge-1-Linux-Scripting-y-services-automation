#!/bin/bash

if [ "$#" -ne 8 ]; then
	echo "uso: $0 Nombre_SO Tipo_SO Num_CPUs Memoria_RAM(GB) Tamano_disco(GB) Nombre_SATA Nombre_IDE"
	exit 1
fi

nombre_vm=$1
tipo_so=$2
num_cpus=$3
memoria_ram=$4
vram=$5
tam_disco=$6
nombre_sata=$7
nombre_ide=$8

#crear maquina virtual
VBoxManage create --name "$nombre_vm" --ostype $tipo_so --register

#configurar maquina virtual
VBoxManage modifyvm "$nombre_vm" --cpus $num_cppus --memory $((memoria_ram*1024)) --vram $((vram*1024))

#crear un disco duro vitual
VBoxManage createmedium disk --filename "$nombre_vm.vdi" --size $tam_disco

#crear controlador SATA
VBoxManage storagectl "$nombre_vm" --name $nombre_sata --add sata

#asociar el disco duro virtual al controlador sata
VBoxManage storagettach "$nombre_vm" --storagectl $nombre_sata --port 0 --device 0 --type hdd --medium "$nombre_vm.vdi"

#crear controlador IDE
VBoxManage storagectl "$nombre_vm" --name $nombre_ide --add ide

#imprimir configuracion
echo "Configuracion de la maquina virtual $nombre_vm:"
VBoxManage showvminfo "$nombre_vm" | grep -E 'Name:|CPUs:|Memory size:|VRAM size:|SATA Controller|IDE Controller'
