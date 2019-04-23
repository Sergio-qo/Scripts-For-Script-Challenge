#variables
numcarta=1
esta=0

#crear baraja
for i in `seq 1 48`; do
	cartas[$i]=$numcarta
	numcarta=$((numcarta + 1))
	if [ $numcarta -ge 12 ]; then
		numcarta=1
	fi
done

#barajar cartas
for i in `seq 1 48`; do
	while [ $esta -eq 0 ]; do
		rndtemp=$RANDOM%47
		for j in `seq 0 ${#cartas[*]}`; do
			if [ ${cartas[$j]} -eq $rndtemp ]; then
				esta=1
			else
				esta=0
			fi
		done
	done
	cartas[$i]=${cartas[$rndtemp]}
done

#reparto de cartas
for i in `seq 0 6`; do
	cont=0
	cusuario[$i]=${cartas[$cont]}
	cartas[$cont]=0
	while [ ${cartas[$cont]} -eq 0 ]; do
		cusuario[$i]=${cartas[$cont]}
		cartas[$cont]=0
	done

	cmaquina[$i]=${cartas[$cont]}
	cartas[$cont]=0
	while [ ${cartas[$cont]} -eq 0 ]; do
		cmaquina[$i]=${cartas[$cont]}
		cartas[$cont]=0
	done
done

read -p "Solicita una carta: " peticionusuario

tienecartas=0

for for i in `seq 0 6`; do
	if [ ${cmaquina[$i]} -eq $peticionusuario ]; then
		for i in `seq 0 6`; do
			if [ ${cmaquina[$i]} -eq $peticionusuario ];then
				cusuario[${#cusuario[*]}]=${cmaquina[$i]}
				cmaquina[$i]=0
			fi
		done
		tienecartas=1
	fi
done

#jugadas
while [ $tienecartas -eq 1 ]; do
	read -p "Solicita una carta: " peticionusuario

	tienecartas=0

	for for i in `seq 0 6`; do
		if [ ${cmaquina[$i]} -eq $peticionusuario ]; then
			for i in `seq 0 6`; do
				if [ ${cmaquina[$i]} -eq $peticionusuario ];then
					cusuario[${#cusuario[*]}]=${cmaquina[$i]}
					cmaquina[$i]=0
				fi
			done
			tienecartas=1
		else
			tienecartas=0
		fi
	done
done

echo "A pescar!"

#Hata aquí me ha dado tiempo



