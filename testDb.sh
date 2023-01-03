#!/usr/bin/bash

export LC_COLLATE=C
shopt -s extglob
#change cursur shape
export PS3='>>> '
valid='^[a-zA-Z]+'
regex='^[!@#$%^&*:;.()_-+=/)]*$'
#export Database name to other files
export DBName

if [ -d ~/DataBase ]; then
	cd ~/DataBase || exit
else
	mkdir ~/DataBase
	cd ~/DataBase || exit
fi

#List some options to create database
while true; do
	choice=$(zenity --list \
		--column "Choose your option" \
		--width 500 \
		--height 300 \
		CreateDB \
		ListDB \
		DropDB \
		ConnectToDB \
		Exit)

	cd ~/DataBase/ || exit
	case $choice in
	CreateDB)
		DBName=$(zenity --entry \
			--width 500 \
			--height 300 --title "Create DB" \
			--text "Enter DataBase Name")

		if [[ $DBName =~ $valid && $DBName != *' '* && $DBName != $regex ]]; then
			if [ -d $DBName ]; then
				zenity --error \
					--title "Error Message" \
					--width 500 \
					--height 100 \
					--text "DataBase Name Already Exist !!!"
			else
				mkdir ./$DBName
				zenity --info \
					--title "Successful" \
					--width 500 \
					--height 100 \
					--text "DataBase Created Successfully !!!"
			fi
		else
			zenity --error \
				--title "Error Message" \
				--width 500 \
				--height 100 \
				--text "Wrong Input Format."
		fi
		;;
	ListDB)
		zenity --info \
			--title "Successful" \
			--width 500 \
			--height 200 \
			--text "$(ls -F ~/DataBase | grep /)"
		;;
	DropDB)
		DBName=$(zenity --entry \
			--width 500 \
			--title "Drop DB" \
			--text "Enter DataBase Name")
		if [ -d $DBName ]; then
			zenity --info \
				--title "DB Found" \
				--width 500 \
				--height 100 \
				--text "DataBase Found"
			rm -r $DBName
			zenity --info \
				--title "DB Removed" \
				--width 500 \
				--height 100 \
				--text "DataBase Removed Successfully"
		else
			zenity --error \
				--title "DB not found" \
				--width 500 \
				--height 100 \
				--text "DataBase Name Is Not Exist !!!"
		fi
		;;
	ConnectToDB)
		DBName=$(zenity --entry \
			--width 500 \
			--title "Connect to DB" \
			--text "Enter DataBase Name")

		if ! [[ $DBName =~ $valid ]]; then
			zenity --error \
				--title "Not valid" \
				--width 500 \
				--height 100 \
				--text "Name Can't be empty !!!"
			continue
		fi
		if [ -d $DBName ]; then
			zenity --info \
				--title "Connected" \
				--width 500 \
				--height 100 \
				--text "DataBase Found"
			cd ~/DataBase/$DBName || exit
			zenity --info \
				--title "Connected" \
				--width 500 \
				--height 100 \
				--text "DataBase Connected Successfully to $DBName"
			pwd
			bash ~/DBMS_BASH_GUI/testTableMenu
		else

			zenity --error \
				--title "Not Found" \
				--width 500 \
				--height 100 \
				--text "DataBase Name Is Not Exist !!!"
		fi
		;;
	Exit)
		zenity --info \
			--title "Bye" \
			--width 500 \
			--height 100 \
			--text "Bye... :("
		break
		;;
	*)
		zenity --info \
			--title "Bye" \
			--width 500 \
			--height 100 \
			--text "Bye... :("
		break
		;;
	esac

done
