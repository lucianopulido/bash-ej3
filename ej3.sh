#!/bin/bash

#---------------------------------------Inicio Encabezado---------------------------------------------------------##
# Nombre Script: "ej3.sh"
# Numero Trabajo Practico: 1
# Numero Ejercicio: 3
# Tipo: 1º Entrega
# Integrantes: 
#		Nombre y Apellido			DNI
#
#		Agustin Barrientos			40306406
#		Lautaro Marino				39457789
#		Nicolas Pompeo				37276705
#		Luciano Pulido				40137604
#		Daniel Varela				40388978
#
##--------------------------------------Fin del Encabezado--------------------------------------------------------##

mostrar_ayuda() {
	echo "Descripcion: "
	echo "El script ej3.sh administra la ejecucion de un demonio, el cual tiene de objetivo crear backup de un directorio, cada cierto tiempo ingresado."
	echo "Modo de ejecutar el script: ./ej3.sh [opcion]"
	echo "Las distintas opciones son las siguientes: "
	echo "1) -h, -?, -help : esta opcion mostrara ayuda y descripcion del script."
	echo "2) start : esta opcion, inicia la ejecucion del demonio. si coloca start, ademas debera colocar, el directorio a salvar, seguido de un espacio, el directorio de backup, seguido de espacio, y el intervalo de tiempo entre backups (expresado en segundos)"
	echo "3) stop : finaliza la ejecucion del demonio"
	echo "4) count : cuenta la cantidad de archivos de backup que hay en el directorio de destino, en ese momento"
	echo "5) clear : esta opcion elimina archivos de backup del directorio. si coloca esta opcion, ademas debera ingresar la cantidad de archivos de backup que desea guardar, siendo estas las ultimas generadas. si no se coloca ninguna cantidad, se eliminaran todos los archivos"
	echo "6) play : el demonio crea el backup en ese instante"
	echo "Tenga en cuenta que solo se podra ejecutar un demonio a la vez"
	exit 0
}

if [[ $# -eq 0 ]]; then
	echo "Error. No se colocaron parametros en el script."
	exit 1
fi

if test $1 = "-h" || test $1 = "-?" || test $1 = "-help"; then
        mostrar_ayuda
	exit 0
fi

if [[ $1 == "start" ]]; then
	if [[ -f 'parametros.txt' ]]; then
		echo "El demonio ya esta ejecutandose."
		exit 1
	fi

	if [[ $# -eq 2 ]]
	then
		echo "Error, faltan 2 parametro para iniciar el demonio, consulte la ayuda"
		exit 1
	fi

	if [[ $# -eq 3 ]]
	then
		echo "Error, falta un parametro para iniciar el demonio, consulte la ayuda"
		exit 1
	fi

	if ! [[ -d "$2" ]]; then
		echo "directorio a guardar no valido"
		exit 1
	fi

	if ! [[ -d "$3" ]]; then
		echo "directorio de backup no valido"
		exit 1
	fi

	diraguardar="$2"
	dirdebackup="$3"
	tiempodebackup="$4"

	./demonio.sh "$diraguardar" "$dirdebackup" "$tiempodebackup" &#le paso los parametros y lo ejecuto en background
	exit 0
fi

if [[ $1 == "stop" ]]; then
	if ! [[ -f 'parametros.txt' ]]; then
		echo "El demonio no fue inicidado. Puede consultar la ayuda con -help"
		exit 1
	fi

	archivo=($(cat ./parametros.txt))
	IFS="$(echo -e "\n\r")"

	contador=0
	pid=""

	for file in ${archivo[@]}; do
		((contador++))
		if [[ $contador -eq 1 ]]; then
			pid=$file
		fi

	done

	kill -10 "$pid"
	rm ./parametros.txt
	exit 0
fi

if [[ $1 == "count" ]]; then
	if ! [[ -f 'parametros.txt' ]]; then
		echo "El demonio no fue inicidado. Puede consultar la ayuda con -help"
		exit 1
	fi

	archivo=($(cat ./parametros.txt))
	IFS="$(echo -e "\n\r")"

	contador=0
	direc=""

	for file in ${archivo[@]}; do
		((contador++))
		if [[ $contador -eq 2 ]]; then
			direc=$file
		fi

	done

	cd $direc
	cant=$(find $direc -maxdepth 1 -type d | wc -l)
	((cant--)) #le resto uno, para que no me cuente la carpeta actual
	echo "la cantidad de archivos de backup en el directorio es: $cant"
	exit 0
fi

if	[[ $1 == "clear" ]]
then

	if ! [[ -f 'parametros.txt' ]]; then
		echo "El demonio no fue inicidado. Puede consultar la ayuda con -help"
		exit 1
	fi

	archivo=(`cat ./parametros.txt`)
	IFS="$(echo -e "\n\r")"
	
	contador=0
	direc=""

	for file in ${archivo[@]}; 
	do
		((contador++))
		if [[ $contador -eq 2 ]]; then
			direc=$file
		fi

	done

	cd $direc


	if [[ $# -eq 1 ]]; then
		archord=$(ls -t) #guardo lista de archivos en forma descendente y la guardo en un array
		IFS="$(echo -e "\n\r")"
		for file in ${archord[*]}; do
			if [[ -d "$file" ]]; then #como puso clear solo, no guardo ningun backup
				rm -r --dir "$file"
			fi
		done
	fi

	if [[ $# -eq 2 ]]; then
		archord=$(ls -t)        #guardo lista de archivos en forma descendente y la guardo en un array
		IFS="$(echo -e "\n\r")" #cambio el separador del array
		i=0
		for file in ${archord[*]}; do #recorro array
			if [[ "$i" -ge $2 ]]; then #solo entra si la variable i es mayor al numero del parametros
				if [[ -d "$file" ]]; then #si el directorio existe, lo elimina
					rm -r --dir "$file"
				fi
			fi
			((i++))
		done
	fi
	exit 0
fi

if [[ $1 == "play" ]]; then
	if ! [[ -f 'parametros.txt' ]]; then
		echo "El demonio no fue inicidado. Puede consultar la ayuda con -help"
		exit 1
	fi
	
	archivo=($(cat ./parametros.txt))
	IFS="$(echo -e "\n\r")"

	contador=0
	pid=""

	for file in ${archivo[@]}; do
		((contador++))
		if [[ $contador -eq 1 ]]; then
			pid=$file
		fi

	done

	kill -12 "$pid"
	exit 0
fi

#FIN
