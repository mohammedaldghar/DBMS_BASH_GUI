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
#loop while table name is exist
while true; do
	#check for table name validation
	tableExist=0
	if [[ $tableName =~ $valid && $tableName != *' '* && $tableName != $re ]]; then
		if ! [ -f $tableName ]; then
			zenity --error \
				--title "Not found" \
				--width 500 \
				--height 100 \
				--text "Table is not exist"
			tableExist=1
			#break and return to the previous menu if table name is not exist
			if [[ $tableExist == 1 ]]; then
				break
			fi
		fi
	fi
	#menu for delete options
	choice=$(zenity --list \
		--column "Select your choice" \
		--width 500 \
		--height 300 \
		DeleteByColumnName \
		DeleteAll \
		Back)
	#table is found
	if (($tableExist == 0)); then
		colNames=($(sed -n -e "s/:/ /g" -e "1p" ~/DataBase/$DBName/$tableName)) #array to store columns name
		declare -i colLength=${#colNames[@]} #variable to store length of colNames
	fi
	#choose option for the menu
	case $choice in
	DeleteByColumnName)
		colName=$(zenity --entry \
			--width 500 \
			--title "Column name" \
			--text "Enter column name")

		for ((i = 0; i < $colLength; i++)); do
			if [[ $colName == ${colNames[$i]} ]]; then
				flag=1 #flag to check column name existence in the file
				colNumber=$i
				break
			fi
		done
		if (($flag == 0)); then
			zenity --error \
				--title "Can't find" \
				--width 500 \
				--height 100 \
				--text "this column is not exist"
		
		else
			colNumber=$colNumber+1

			colData=($(sed -n '3,$p' ./$tableName | cut -d: -f$colNumber)) #Data for chosed column

			echo "colData : " "${colData[@]}"

			declare -i colDataLength=${#colData[@]}

			echo "colDataLength : " $colDataLength #number of records in colmn

			declare -i tmp
			counter=0
			data=$(zenity --entry \
				--width 500 \
				--title "Data" \
				--text "Enter data you want to delete")
			

			for ((i = 0; i < $colDataLength; i++)); do

				if [[ ${colData[$i]} == $data ]]; then

					echo "col data : " ${colData[$i]}
					tmp=0

					tmp=$i+3 #get line number of chosen data (add 3 because of meta data)

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
			# delete from the end of file because of last line problem
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
		break
		;;
	esac
	flag=0
done
