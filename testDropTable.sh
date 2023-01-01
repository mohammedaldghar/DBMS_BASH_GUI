#!/usr/bin/bash

export LC_COLLATE=C
shopt -s extglob

tableName=$(zenity --entry \
	--width 500 \
	--title "Check table name" \
	--text "Enter table name")
#read -r -p "Enter table name: " tableName

if [[ -f $tableName ]]; then
	rm "$tableName"
	zenity --info \
		--title "Successfully" \
		--width 500 \
		--height 100 \
		--text "Deleted Successfully"
	#echo "Deleted Successfully"
else
	zenity --error \
		--title "Can't find" \
		--width 500 \
		--height 100 \
		--text "Table is not Exist"
	#echo "Table is not Exist"
fi

