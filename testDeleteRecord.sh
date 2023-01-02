#!/usr/bin/bash

export LC_COLLATE=C
shopt -s extglob
declare -a colData
declare -a colNames
declare -i colNumber
declare -a deleteLine
declare -i counter
declare -i tableExist=0
re='^[0-9]+$'
valid='^[a-zA-Z]+'
flag=0

tableName=$(zenity --entry \
	--width 500 \
	--title "Check table exist" \
	--text "Enter table name")
#read -p "Enter table name : " tableName
while true; do
	choice=$(zenity --list \
		--column "Select your choice" \
		DeleteByColumnName \
		DeleteAll \
		Back)

	#select choice in DeleteByColumnName DeleteAll Back; do

	if [[ $tableExist == 1 ]]; then
		break
	fi

	tableExist=0
	if [[ $tableName =~ $valid && $tableName != *' '* && $tableName != $re ]]; then
		if ! [ -f $tableName ]; then
			zenity --error \
				--title "Not found" \
				--width 500 \
				--height 100 \
				--text "Table is not exist"
			#echo "Table is not exist"
			tableExist=1
		else
			zenity --info \
				--title "Successfully" \
				--width 500 \
				--height 100 \
				--text "Table Found"
			#echo "Table Found"
		fi
	else
		zenity --error \
			--title "Invalid" \
			--width 500 \
			--height 100 \
			--text "Wrong Format..."
		#echo "Wrong Format..."
		tableExist=1
	fi

	if (($tableExist == 0)); then
		colNames=($(sed -n -e "s/:/ /g" -e "1p" ~/DataBase/$DBName/$tableName))
		declare -i colLength=${#colNames[@]}
		echo "${!colNames[@]}"
		echo "${colNames[@]}"
	fi
	if (($tableExist == 1)); then
		break
	fi

	case $choice in
	DeleteByColumnName)
		colName=$(zenity --entry \
			--width 500 \
			--title "Column name" \
			--text "Enter column name")
		#read -p "Enter column name: " colName
		for ((i = 0; i < $colLength; i++)); do
			if [[ $colName == ${colNames[$i]} ]]; then
				flag=1
				colNumber=$i
				echo $colNumber
				break
			fi
		done
		if (($flag == 0)); then
			zenity --error \
				--title "Can't find" \
				--width 500 \
				--height 100 \
				--text "this column is not exist"
			#echo "this column is not exist"
		else
			colNumber=$colNumber+1

			colData=($(sed -n '3,$p' ./$tableName | cut -d: -f$colNumber))

			echo "colData : " "${colData[@]}"

			declare -i colDataLength=${#colData[@]}

			echo "colDataLength : " $colDataLength

			declare -i tmp
			counter=0
			data=$(zenity --entry \
				--width 500 \
				--title "Data" \
				--text "Enter data you want to delete")
			#read -p "Enter data you want to delete: " data

			for ((i = 0; i < $colDataLength; i++)); do

				if [[ ${colData[$i]} == $data ]]; then

					echo "col data : " ${colData[$i]}
					tmp=0

					tmp=$i+3

					if ! [[ $data =~ $re ]]; then
						echo "CHARACTERS"
						sed -i ''/"$data"/d'' ./$tableName

					else
						deleteLine[$counter]=$tmp
						((counter = $counter + 1))
						echo "counter "$counter
						echo "Temp : "$tmp
						echo "INTERGER"
					fi
				else
					echo "Not Found"
				fi
			done
			echo "array lines " "${deleteLine[@]}"
			for ((i = $counter - 1; i >= 0; i--)); do
				sed -i "${deleteLine[$i]} d" ./$tableName
			done
		fi
		;;
	DeleteAll)
		sed -i '3,$d' ./$tableName
		break
		;;
	Back)
		break
		;;
	*)
		#zenity --error \
		#	--title "Error input" \
		#	--width 500 \
		#	--height 100 \
		#	--text "It's not option"
		#echo "It's not option"
break
		;;
	esac
	flag=0
	#echo "1)DeleteByColumnName         2)DeleteAll         3)Back"
done

