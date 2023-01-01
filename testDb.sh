#!/usr/bin/bash

export LC_COLLATE=C
shopt -s extglob
export PS3='>>> '
valid='^[a-zA-Z]+'
regex='^[!@#$%^&*:;.()_-+=/)]*$'
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
		CreateDB \
		ListDB \
		DropDB \
		ConnectToDB \
		Exit)
	echo $choice
	#select choice in CreateDB ListDB DropDB ConnectToDB Exit; do
	cd ~/DataBase/ || exit
	case $choice in
	CreateDB)
		DBName=$(zenity --entry \
			--width 500 \
			--title "Create DB" \
			--text "Enter DataBase Name")
		#read -r -p "Enter DataBase Name : " DBName
		if [[ $DBName =~ $valid && $DBName != *' '* && $DBName != $regex ]]; then
			if [ -d $DBName ]; then
				zenity --error \
					--title "Error Message" \
					--width 500 \
					--height 100 \
					--text "DataBase Name Already Exist !!!"

				#echo "DataBase Name Already Exist !!!"
			else
				mkdir ./$DBName
				zenity --info \
					--title "Successful" \
					--width 500 \
					--height 100 \
					--text "DataBase Created Successfully !!!"

				# echo "DataBase Created Successfully !!!"
			fi
		else
			zenity --error \
				--title "Error Message" \
				--width 500 \
				--height 100 \
				--text "Wrong Input Format."

			# echo "Wrong Input Format."
		fi
		;;
	ListDB)
		# echo "DataBase ListDB : "
		zenity --info \
			--title "Successful" \
			--width 500 \
			--height 100 \
			--text "$(ls -F ~/DataBase | grep /)"

		#ls -F ~/DataBase | grep /
		;;
	DropDB)
		#echo "DataBase DropDB"
		DBName=$(zenity --entry \
			--width 500 \
			--title "Drop DB" \
			--text "Enter DataBase Name")

		#read -r -p "Enter DataBase Name : " DBName
		if [ -d $DBName ]; then
			zenity --info \
				--title "DB Found" \
				--width 500 \
				--height 100 \
				--text "DataBase Found"

			#echo "DataBase Found"
			rm -r $DBName
			zenity --info \
				--title "DB Removed" \
				--width 500 \
				--height 100 \
				--text "DataBase Removed Successfully"

			#echo "DataBase Removed Successfully"
		else
			zenity --error \
				--title "DB not found" \
				--width 500 \
				--height 100 \
				--text "DataBase Name Is Not Exist !!!"
			#echo "DataBase Name Is Not Exist !!!"
		fi
		;;
	ConnectToDB)

		#zenity --info \
		#      --title "Connected" \
		#     --width 500 \
		#    --height 100 \
		#   --text "DataBase ConnectToDB"
		#echo "DataBase ConnectToDB"
		DBName=$(zenity --entry \
			--width 500 \
			--title "Connect to DB" \
			--text "Enter DataBase Name")

		#read -p "Enter DataBase Name : " DBName
		if ! [[ $DBName =~ $valid ]]; then
			zenity --error \
				--title "Not valid" \
				--width 500 \
				--height 100 \
				--text "Name Can't be empty !!!"
			#echo "Name Can't be empty !!!"
			continue
		fi
		if [ -d $DBName ]; then
			zenity --info \
				--title "Connected" \
				--width 500 \
				--height 100 \
				--text "DataBase Found"

			#echo "DataBase Found"
			cd ~/DataBase/$DBName || exit
			zenity --info \
				--title "Connected" \
				--width 500 \
				--height 100 \
				--text "DataBase Connected Successfully to $DBName"

			# echo "DataBase Connected Successfully to $DBName"
			pwd
			bash ~/TEST/testTableMenu			
		else

			zenity --error \
				--title "Not Found" \
				--width 500 \
				--height 100 \
				--text "DataBase Name Is Not Exist !!!"

			#  echo "DataBase Name Is Not Exist !!!"
		fi
		;;
	Exit)
		zenity --info \
			--title "Bye" \
			--width 500 \
			--height 100 \
			--text "Bye... :("

		# echo "Bye..."
		break
		;;
	*)
		zenity --error \
			--title "Wrong" \
			--width 500 \
			--height 100 \
			--text "Wrong Input"

		#echo "Wrong Input"
		;;
	esac

done

