#!/usr/bin/bash

export LC_COLLATE=C
shopt -s extglob

#number of columns user has entered
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
#check for table name regex
if [[ $tableName =~ $valid && $tableName != *' '* && $tableName != $regex ]]; then
#check for table name exist
	if [ -f $tableName ]; then
		zenity --error \
			--title "Already Exist" \
			--width 500 \
			--height 100 \
			--text "Table is already exist"
		tableExist=1
	else
		touch $tableName
		zenity --info \
			--title "Created" \
			--width 500 \
			--height 100 \
			--text "Table Created successfully"
	fi
else
	zenity --error \
		--title "Can't create" \
		--width 500 \
		--height 100 \
		--text "Wrong Format..."
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
	if (($col == -1)); then
		echo >>./$tableName
		break
	else
		IsExist=0
		# loop and get columns name
		for ((i = 0; i < $numberOfCol; i++)); do
			if [[ $col = ${colNames[$i]} ]]; then
				zenity --error \
					--title "Can't add column" \
					--width 500 \
					--height 100 \
					--text "Column Exist"
				IsExist=1
				break
			fi
		done
		#check for number of columns user has entered is not equal to 0
		if [[ $numberOfCol != 0 ]]; then
			#check for column name
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
#loop for entering data type for each column
for ((i = 0; i < $numberOfCol; i++)); do
	if [[ $i == 0 ]]; then
		colData=$(zenity --entry \
			--width 500 \
			--title "Enter data" \
			--text "Enter ${colNames[$i]}(PK) data type")
	else
		colData=$(zenity --entry \
			--width 500 \
			--title "Enter data" \
			--text "Enter ${colNames[$i]} data type")
	fi
	#check for i and number of column to add colon (:)
	if (($i != 0)) && (($i != $numberOfCol)); then
		echo -n ":" >>$tableName
	fi
	if (($i == 0)); then
		echo -n $colData >>$tableName
	else
		echo -n $colData >>$tableName
	fi
	if (($i + 1 == $numberOfCol)); then
		echo >>./$tableName
	fi
done
