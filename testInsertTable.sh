#!/usr/bin/bash
export LC_COLLATE=C
shopt -s extglob
declare -a inpElements
declare -a colNames
declare -i numberOfLines
declare -a firstField
declare -i fieldIterator
declare -i flagForTableExistence
flagForTableExistence=0


tName=$(zenity --entry \
	--width 500 \
	--title "Check table name" \
	--text "Enter Table Name")

#echeck for table existence
if ! [[ -f $tName ]]; then
	zenity --error \
		--title "Not found" \
		--width 500 \
		--height 100 \
		--text "Table is not Exist"
	flagForTableExistence=1
fi

if [[ $flagForTableExistence == 0 ]]; then
	invalid=0 # check validation of data value
	regex='^[0-9]+$'
	regexChar='^[a-zA-Z]+[0-9]*$'
	#number of rows (records)
	numberOfLines=$(sed -n '3,$p' ~/DataBase/$DBName/$tName | wc -l)
	fieldIterator=3  #insert data in each column
	for ((i = 0; i < $numberOfLines; i++)); do
		firstField[$i]=$(sed -n "$fieldIterator"p ~/DataBase/$DBName/$tName | cut -d: -f1) # array of column you have selected
		fieldIterator=$fieldIterator+1
	done

	colNames=($(sed -n -e "s/:/ /g" -e "1p" ~/DataBase/$DBName/$tName)) 

	declare -i colNamesLenght=${#colNames[@]}
	zenity --info \
		--title "Columns names" \
		--width 500 \
		--height 100 \
		--text "col length : $colNamesLenght"

	for ((i = 0; i < $colNamesLenght; i++)); do

		inp=$(zenity --entry \
			--width 500 \
			--title "Data" \
			--text "Enter value ${colNames[$i]}")

		if (($i == 0)); then
			if [[ $inp =~ $regex || $inp =~ $regexChar ]]; then #check doublicate pk for first column (any data type)
				echo "Integers"
				flag=0 # input is valid 
				for ((j = 0; j < $numberOfLines; j++)); do
					if [[ $inp == "${firstField[$j]}" ]]; then
						zenity --error \
							--title "Duplicate primaey key" \
							--width 500 \
							--height 100 \
							--text "${colNames[$i]} $inp  Already Exist"
						flag=1 # Dublicate data
						break
					fi
				done
				if [[ $flag == 0 ]]; then
					inpElements[$i]=$inp
				else
					invalid=1
					break
				fi
			fi
		else
			if [[ $inp =~ $regexChar ]]; then
				echo "Characters"
				inpElements[$i]=$inp
			elif [[ $inp =~ $regex ]]; then
				echo "Integers"
				inpElements[$i]=$inp
			else
				invalid=1
				zenity --error \
					--title "Error" \
					--width 500 \
					--height 100 \
					--text "not valid input"
			fi
		fi
	done

	declare -i inpElementsLength=${#inpElements[@]}

	for ((i = 0; i < $inpElementsLength; i++)); do
		if [[ $invalid == 1 ]]; then
			break
		fi
		if [[ $i != 0 ]]; then
			echo -n ":" >>~/DataBase/$DBName/$tName
		fi

		echo -n ${inpElements[$i]} >>~/DataBase/$DBName/$tName

		if (($i + 1 == $inpElementsLength)); then
			echo >>~/DataBase/$DBName/$tName
		fi
	done

	if [[ $invalid == 0 ]]; then
		declare -a stColumn #array of sorting data in file
		stColumn=($(sed -n '3,$p' ~/DataBase/$DBName/$tName | cut -d: -f1))
		if [[ ${stColumn[0]} =~ $regex ]]; then
			sort -n -t: -k1 -o ~/DataBase/$DBName/$tName ~/DataBase/$DBName/$tName
		else
			sort -t: -k1 -o ~/DataBase/$DBName/$tName ~/DataBase/$DBName/$tName
		fi
	fi
fi

