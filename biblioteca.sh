salir=0
function selecciontarea()
{
	if [ $salir -eq 0 ]; then
		echo "Elija una opción: "
		echo "1.Gestión de libros"
		echo "2.Gestión de usuarios"
		echo "3.Gestión de préstamos"
		echo "4.Salir"
		read -p "" opcionprincipal

		while [ $opcionprincipal != 1 ] && [ $opcionprincipal != 2 ] && [ $opcionprincipal != 3 ] && [ $opcionprincipal != 4 ]; do
			echo "Número incorrecto, elija una opción: "
			echo "1.Gestión de libros"
			echo "2.Gestión de usuarios"
			echo "3.Gestión de préstamos"
			echo "4.Salir"
			read -p "" opcionprincipal
		done
		if [ $opcionprincipal -eq 1 ]; then
			gestionlibros
		fi
		if [ $opcionprincipal -eq 2 ]; then
			gestionusuarios
		fi
		if [ $opcionprincipal -eq 3 ]; then
			gestionprestamos
		fi
		if [ $opcionprincipal -eq 4 ]; then
			exit
		fi
	fi
}

function altalibro()
{
	read -p "Introduzca el título del libro: " titulo
	read -p "Introduzca el autor del libro: " autor
	read -p "Introduzca el género del libro: " genero
	read -p "Introduzca el año del libro: " anyo
	read -p "Introduzca la estantería donde se guardará el libro: " estanteria
	prestado=0
	lineas=`cat libros.bd | wc -l`
	idlmg=0

	for i in `seq 1 $lineas`; do
		if [ `cat libros.bd | head -$lineas | tail -1 | awk -F"," '{print $1}'` -gt $idlmg ]; then
			idlmg=`cat libros.bd | head -$lineas | tail -1 | awk -F"," '{print $1}'`
		fi
	done
	id=$((idlmg + 1))
	
	echo "$id,$titulo,$autor,$genero,$anyo,$estanteria,$prestado" >> libros.bd
}

function altausuario()
{
	prestamos=0
	read -p "Introduzca el nombre de usuario: " nombre
	read -p "Introduzca el primer apellido del usuario: " ape1
	read -p "Introduzca el segundo apellido del usuario: " ape2
	read -p "Introduzca el curso del usuario: " curso
	prestado=0
	lineas=`cat usuarios.bd | wc -l`
	idlmg=0

	for i in `seq 1 $lineas`; do
		if [ `cat usuarios.bd | head -$lineas | tail -1 | awk -F"," '{print $1}'` -gt $idlmg ]; then
			idlmg=`cat usuarios.bd | head -$lineas | tail -1 | awk -F"," '{print $1}'`
		fi
	done
	id=$((idlmg + 1))
	
	echo "$id,$nombre,$ape1,$ape2,$curso,$prestamos" >> usuarios.bd
}

function altaprestamo()
{
	lineas=`cat libros.bd | wc -l`
	idlmg=0
	if [ `cat prestamos.bd | wc -l` -le 0 ]; then
		idlmg=0
	else
		for i in `seq 1 $lineas`; do
			if [ `cat prestamos.bd | head -$i | tail -1 | awk -F"," '{print $1}'` -gt $idlmg ]; then
				idlmg=`cat prestamos.bd | head -$i | tail -1 | awk -F"," '{print $1}'`
			fi
		done
	fi
	id=$((idlmg + 1))
	echo "Libros:"
	for i in `seq 1 $lineas`; do
		linea=`cat libros.bd | head -$i | tail -1 | awk -F"," '{print "Id."$1 " " $2}'`
		echo $linea
	done
	read -p "Escriba el id del libro: " idl
	lineas=`cat usuarios.bd | wc -l`
	echo ""
	echo "Usuarios:"
	for i in `seq 1 $lineas`; do
		linea=`cat libros.bd | head -$i | tail -1 | awk -F"," '{print "Id."$1 " " $2}'`
		echo $linea
	done
	read -p "Escriba el id del usuario: " idu
	if [ `cat libros.bd | head -$idl | tail -1 | awk -F"," '{print $7}'` -gt 0 ]; then
		echo "El libro ya está prestado"
	else
		echo $id,$idl,$idu >> prestamos.bd
		posicionlibro=`cat libros.bd | grep -nw "$idl" | awk -F":" '{print $1}'`
		nuevalinea=`cat libros.bd | head -$posicionlibro | tail -1 | awk -F"," '{print $1","$2","$3","$4","$5","$6","1}'`
		sed -i "$posicionlibro"d"" libros.bd
		echo $nuevalinea >> libros.bd
		posicionusuario=`cat usuarios.bd | grep -nw "$idu" | awk -F":" '{print $1}'`
		prestamos=`cat usuarios.bd | head -$posicionusuario | tail -1 | awk -F"," '{print $6}'`
		prestamosn=$((prestamos + 1))
		nuevalinea=`cat usuarios.bd | head -$posicionusuario | tail -1 | awk -F"," '{print $1","$2","$3","$4","$5}'`
		nuevalinea="$nuevalinea,$prestamosn"
		sed -i "$posicionusuario"d"" usuarios.bd
		echo $nuevalinea >> usuarios.bd
	fi
}

function bajaprestamo()
{
	lineas=`cat libros.bd | wc -l`
	idlmg=0
	for i in `seq 1 $lineas`; do
		if [ `cat libros.bd | head -$i | tail -1 | awk -F"," '{print $1}'` -gt $idlmg ]; then
			idlmg=`cat libros.bd | head -$i | tail -1 | awk -F"," '{print $1}'`
		fi
	done
	id=$((idlmg + 1))
	if [ `cat libros.bd | head -$idl | tail -1 | awk -F"," '{print $7}'` -le 0 ]; then
		echo "El libro no esta prestado"
	else
		if [ `cat usuarios.bd | head -$idu | tail -1 | awk -F"," '{print $6}'` -le 0 ]; then
			echo "El usuario no tiene prestamos pendientes"
		else
			read -p "Id del prestamo a borrar: " idp
			posicionprestamo=`cat prestamos.bd | grep -nw "$idp" | awk -F":" '{print $1}'`
			sed -i "$posicionprestamo"d"" prestamos.bd
			
			idl=`cat prestamos.bd | grep -w "$idp" | awk -F"," '{print $2}'`
			idu=`cat prestamos.bd | grep -w "$idp" | awk -F"," '{print $3}'`

			posicionlibro=`cat libros.bd | grep -nw "$idl" | awk -F":" '{print $1}'`
			nuevalinea=`cat libros.bd | head -$posicionlibro | tail -1 | awk -F"," '{print $1","$2","$3","$4","$5","$6","0}'`
			sed -i "$posicionlibro"d"" libros.bd
			echo $nuevalinea >> libros.bd

			posicionusuario=`cat usuarios.bd | grep -nw "$idu" | awk -F":" '{print $1}'`
			prestamos=`cat usuarios.bd | head -$posicionusuario | tail -1 | awk -F"," '{print $6}'`
			prestamosn=$((prestamos - 1))
			nuevalinea=`cat usuarios.bd | head -$posicionusuario | tail -1 | awk -F"," '{print $1","$2","$3","$4","$5}'`
			nuevalinea="$nuevalinea,$prestamosn"
			sed -i "$posicionusuario"d"" usuarios.bd
			echo $nuevalinea >> usuarios.bd
		fi
	fi
}

function bajalibro()
{
	read -p "Id del libro a borrar: " idb
	if [ `cat libros.bd | grep "$idb" | awk -F"," '{print $7}'` -eq 1 ]; then
		echo -e "No se puede dar de baja, el libro está prestado"
	else
		posicionlibro=`cat libros.bd | grep -nw "$idb" | awk -F":" '{print $1}'`
		sed -i "$idb"d"" libros.bd
	fi
}

function bajausuario()
{
	read -p "Id del usuario a borrar: " idb
	if [ `cat usuarios.bd | grep "$idb" | awk -F"," '{print $6}'` -gt 0 ]; then
		echo "No se puede dar de baja, el usuario tiene préstamos pendientes"
	else
		posicionusuario=`cat libros.bd | grep -nw "$idb" | awk -F":" '{print $1}'`
		sed -i "$idb"d"" usuarios.bd
	fi
}

function consultalibro()
{
	if [ $lineas -le 0 ]; then
		echo "No hay libros"
	else
		lineas=`cat libros.bd | wc -l`
		read -p "Introduzca el id o el nombre del libro: " infolibro
		for i in `seq 1 $lineas`; do
			if [ `cat libros.bd | head -$i | tail -1 | awk -F"," '{print $1}'` = $infolibro ] || [ `cat libros.bd | head -$i | tail -1 | awk -F"," '{print $2}'` = $infolibro ]; then
				echo `cat libros.bd | head -$i | tail -1`
			fi
		done
	fi
}

function consultausuario()
{
	lineas=`cat usuarios.bd | wc -l`
	if [ $lineas -le 0 ]; then
		echo "No hay usuarios"
	else
		read -p "Introduzca el id o el nombre de usuario: " infousuarios
		for i in `seq 1 $lineas`; do
			if [ `cat usuarios.bd | head -$i | tail -1 | awk -F"," '{print $1}'` = $infousuario ] || [ `cat usuarios.bd | head -$i | tail -1 | awk -F"," '{print $2}'` = $infousuario ]; then
				echo `cat usuarios.bd | head -$i | tail -1`
			fi
		done	
	fi
}

function consultaprestamo()
{
	lineas=`cat prestamos.bd | wc -l`
	read -p "Introduzca el id del prestamo: " idp
	if [ $lineas -le 0 ]; then
		echo "No hay préstamos"
	else
		for i in `seq 1 $lineas`; do
			if [ `cat prestamos.bd | head -$i | tail -1 | awk -F"," '{print $1}'` = $infousuario ]; then
				echo `cat prestamos.bd | head -$i | tail -1`
			fi
		done
	fi
}

function listadoprestamos()
{
	cat prestamos.bd
}

function menulibros()
{
	echo "Elija una opción: "
	echo "1.Alta de libro"
	echo "2.Baja de libro"
	echo "3.Consulta por libro"
	echo "4.Salir"
	read -p "" opcionlibros

	while [ $opcionlibros != 1 ] && [ $opcionlibros != 2 ] && [ $opcionlibros != 3 ] && [ $opcionlibros != 4 ]; do
		echo "Elija una opción: "
		echo "1.Alta de libro"
		echo "2.Baja de libro"
		echo "3.Consulta por libro"
		echo "4.Salir"
		read -p "" opcionlibros
	done

	if [ $opcionlibros -eq 1 ]; then
		altalibro
	fi
	if [ $opcionlibros -eq 2 ]; then
		bajalibro
	fi
	if [ $opcionlibros -eq 3 ]; then
		consultalibro
	fi
	if [ $opcionlibros -eq 4 ]; then
		salir=1
	fi
	selecciontarea
}

function menuusuarios()
{
	echo "Elija una opción: "
	echo "1.Alta de usuario"
	echo "2.Baja de usuario"
	echo "3.Consulta de usuario"
	echo "4.Salir"
	read -p "" opcionusuarios

	while [ $opcionusuarios != 1 ] && [ $opcionusuarios != 2 ] && [ $opcionusuarios != 3 ]; do
		echo "Elija una opción: "
		echo "1.Alta de usuario"
		echo "2.Baja de usuario"
		echo "3.Consulta de usuario"
		echo "4.Salir"
		read -p "" opcionusuarios
	done

	if [ $opcionusuarios -eq 1 ]; then
		altausuario
	fi
	if [ $opcionusuarios -eq 2 ]; then
		bajausuario
	fi
	if [ $opcionusuarios -eq 3 ]; then
		consultausuario
	fi
	if [ $opcionusuarios -eq 4 ]; then
		consultausuario
	fi
	selecciontarea
}

function menuprestamos()
{
	echo "Elija una opción: "
	echo "1.Alta de préstamo"
	echo "2.Baja de préstamo"
	echo "3.Listado de préstamos"
	echo "4.Consulta de préstamos"
	echo "5.Salir"
	read -p "" opcionprestamos

	while [ $opcionprestamos != 1 ] && [ $opcionprestamos != 2 ] && [ $opcionprestamos != 3 ] && [ $opcionprestamos != 4 ] && [ $opcionprestamos != 5 ]; do
		echo "Elija una opción: "
		echo "1.Alta de préstamo"
		echo "2.Baja de préstamo"
		echo "3.Listado de préstamos"
		echo "4.Consulta de préstamos"
		echo "5.Salir"
		read -p "" opcionprestamos
	done

	if [ $opcionprestamos -eq 1 ]; then
		altaprestamo
	fi
	if [ $opcionprestamos -eq 2 ]; then
		bajaprestamo
	fi
	if [ $opcionprestamos -eq 3 ]; then
		listadoprestamos
	fi
	if [ $opcionprestamos -eq 4 ]; then
		consultaprestamo
	fi
	if [ $opcionprestamos -eq 5 ]; then
		salir=1
	fi
	selecciontarea
}

function gestionlibros()
{
	if [ `ls -l | grep libros.bd | wc -l` -eq 1 ]; then
		menulibros
	else
		touch libros.bd
		menulibros
	fi
}

function gestionusuarios()
{
	if [ `ls -l | grep usuarios.bd | wc -l` -eq 1 ]; then
		menuusuarios
	else
		touch usuarios.bd
		menuusuarios
	fi
}

function gestionprestamos()
{
	if [ `ls -l | grep prestamos.bd | wc -l` -eq 1 ]; then
		menuprestamos
	else
		touch prestamos.bd
		menuprestamos
	fi
}

selecciontarea
