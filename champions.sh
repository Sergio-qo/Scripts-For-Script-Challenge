rm todos.csv
touch todos.csv
lineas=`cat games.csv | wc -l`
lineas=$((lineas - 1))
x=2
while read games; do
	if [ `cat games.csv | head -$x | tail -1 | awk -F"," '{print $5}'` -eq 1 ]; then
		for i in `seq 12 17`; do
			for j in `seq 12 17`; do
				c1=`cat games.csv | head -$x | tail -1 | awk -F"," -v var="$i" '{print $var}'`
				c2=`cat games.csv | head -$x | tail -1 | awk -F"," -v var="$j" '{print $var}'`
				
				lresult=`cat todos.csv | wc -l`
				if [ $lresult -eq 0 ]; then
					esta=0
				else
					t=1
					while read todos; do
						t1=`cat todos.csv | head -$t | tail -1 | awk -F"," '{print $1}'`
						t2=`cat todos.csv | head -$t | tail -1 | awk -F"," '{print $2}'`
						if [ $t1 -eq $c1 ] || [ $t1 -eq $c2 ] || [ $t2 -eq $c1 ] || [ $t2 -eq $c2 ]; then
							esta=1
						else
							esta=0
						fi
						t=$((t + 1))
					done < todos.csv
				fi
				
				if [ $c1 != $c2 ] && [ $esta -eq 0 ]; then
					echo "$c1,$c2,0" | tr -d '[[:space:]]' >> todos.csv
					echo "" >> todos.csv
				else
					val=`cat todos.csv | head -$x | tail -1 | awk -F"," '{print $3}'`
					val=$((val + 1))
					sed -i "$x"d"" todos.csv
					echo "$c1,$c2,$val" | tr -d '[[:space:]]' >> todos.csv
					echo "" >> todos.csv
				fi
			done		
		done
	fi

	if [ `cat games.csv | head -$x | tail -1 | awk -F"," '{print $5}'` -eq 2 ]; then
		for i in `seq 18 23`; do
			for j in `seq 18 23`; do
				c1=`cat games.csv | head -$x | tail -1 | awk -F"," -v var="$i" '{print $var}'`
				c2=`cat games.csv | head -$x | tail -1 | awk -F"," -v var="$j" '{print $var}'`
				
				lresult=`cat todos.csv | wc -l`
				if [ $lresult -eq 0 ]; then
					esta=0
				else
					t=1
					while read todos; do
						t1=`cat todos.csv | head -$t | tail -1 | awk -F"," '{print $1}'`
						t2=`cat todos.csv | head -$t | tail -1 | awk -F"," '{print $2}'`
						if [ $t1 -eq $c1 ] || [ $t1 -eq $c2 ] || [ $t2 -eq $c1 ] || [ $t2 -eq $c2 ]; then
							esta=1
						else
							esta=0
						fi
						t=$((t + 1))
					done < todos.csv
				fi
				
				if [ $c1 != $c2 ] && [ $esta -eq 0 ]; then
					echo "$c1,$c2,0" | tr -d '[[:space:]]' >> todos.csv
					echo "" >> todos.csv
				else
					val=`cat todos.csv | head -$x | tail -1 | awk -F"," '{print $3}'`
					val=$((val + 1))
					sed -i "$x"d"" todos.csv
					echo "$c1,$c2,$val" | tr -d '[[:space:]]' >> todos.csv
					echo "" >> todos.csv
				fi
			done		
		done
	fi
	x=$((x + 1))
done < games.csv
