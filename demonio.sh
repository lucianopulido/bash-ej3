#!/bin/bash

#---------------------------------------Inicio Encabezado---------------------------------------------------------##
# Nombre Script: "demonio.sh"
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

dirsave="$1"
dirback="$2"
tiempo="$3"

echo $$ > ./parametros.txt   #creo un archivo txt, con el pid del demonio, para poder pasarle señales.
echo $dirback >> ./parametros.txt

chmod 777 ./parametros.txt


trap SIGUSR1 #si recibe la señal de stop, termina

trap ' ((num++)); rsync -a "$dirsave" "$dirback/$num" ' SIGUSR2 #si recibe la señal de play, crea el backup en ese momento

num=0

while true
do
rsync -a "$dirsave" "$dirback/$num"

	cont=0
	while [[ "$cont" -lt "4*$tiempo" ]]
	do
		sleep 0.25
		((cont++))
	done

((num++))
done

exit