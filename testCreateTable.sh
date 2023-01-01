#!/usr/bin/bash

export LC_COLLATE=C
shopt -s extglob
typeset -i numberOfCol
declare -a colNames
typeset -i IsExist
IsExist=0
numberOfCol=0
declare -i tableExist=0
valid='^[a-zA-Z]+'
regex='^[!@#$%^&*:;.()_-+=/)]*$'

tableName=$(zenity --entry \
	--width 500 \
	--title "Create table" \
	--text "Enter table name")
#read -p "Enter table name: " tableName

if [[ $tableName =~ $valid && $tableName != *' '* && $tableName != $regex ]]; then
	if [ -f $tableName ]; then
		zenity --error \
			--title "Already Exist" \
			--width 500 \
			--height 100 \
			--text "Table is already exist"
		#echo "Table is already exist";
		tableExist=1
	else
		touch $tableName
		zenity --info \
			--title "Created" \
			--width 500 \
			--height 100 \
			--text "Table Created successfully"
		#echo "Table Created successfully"
	fi
else
	zenity --error \
		--title "Can't create" \
		--width 500 \
		--height 100 \
		--text "Wrong Format..."
	#echo "Wrong Format..."
	tableExist=1
fi

while true; do
	if (($tableExist == 1)); then
		break
	fi
	col=$(zenity --entry \
		--width 500 \
		--title "Add column" \
		--text "column name if you finish enter -1")
	#read -p "column name if you finish enter -1 : " col
	if (($col == -1)); then
		echo >>./$tableName
		break
	else

		IsExist=0
		for ((i = 0; i < $numberOfCol; i++)); do
			if [[ $col = ${colNames[$i]} ]]; then
				zenity --error \
					--title "Can't add column" \
					--width 500 \
					--height 100 \
					--text "Column Exist"
				#echo " Column Exist "
				IsExist=1
				break
			fi
		done
		if [[ $numberOfCol != 0 ]]; then
			if [[ $IsExist == 0 ]]; then
				echo -n ":" >>$tableName
			fi
		fi
		if ((IsExist == 0)); then
			colNames[$numberOfCol]=$col
			echo -n $col >>$tableName
			numberOfCol=$numberOfCol+1
		fi

	fi
done
for ((i = 0; i < $numberOfCol; i++)); do
	if [[ $i == 0 ]]; then
		colData=$(zenity --entry \
			--width 500 \
			--title "Enter data" \
			--text "Enter ${colNames[$i]}(PK) data type")
		#read -p "Enter ${colNames[$i]}(PK) data type: " colData
	else
		colData=$(zenity --entry \
			--width 500 \
			--title "Enter data" \
			--text "Enter ${colNames[$i]} data type")
		#read -p "Enter ${colNames[$i]} data type: " colData
	fi
	if (($i != 0)) && (($i != $numberOfCol)); then
		echo -n ":" >>$tableName
	fi
	colMetaData[$i]=$colData
	if (($i == 0)); then
		echo -n $colData >>$tableName
	else
		echo -n $colData >>$tableName
	fi
	if (($i + 1 == $numberOfCol)); then
		echo >>./$tableName
	fi
done

