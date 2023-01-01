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
regexChar='^[a-zA-Z]+'
flag=0

tableName=$(zenity --entry \
	--width 500 \
	--title "check table exist" \
	--text "Enter table name")
#read -r -p "Enter table name : " tableName

if [[ $tableName =~ $regexChar && $tableName != *' '* && $tableName != $re ]]; then
	if ! [ -f $tableName ]; then
		zenity --error \
			--title "Can't found" \
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
		while true; do
			choice=$(zenity --list \
				--column "Select your option" \
				SelectByRow \
				SelectAllData \
				SelectByColumn \
				SelectDataWithEquation \
				Back)
			#select choice in SelectByRow SelectAllData SelectByColumn SelectDataWithEquation Back; do

			if (($tableExist == 1)); then
				break
			fi

			if (($tableExist == 0)); then
				colNames=($(sed -n -e "s/:/ /g" -e "1p" ~/DataBase/$DBName/$tableName))
				declare -i colLength=${#colNames[@]} #len=3
			fi
			if (($tableExist == 1)); then
				break
			fi
			case $choice in
			SelectByRow)
				colName=$(zenity --entry \
					--width 500 \
					--title "column namer" \
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

					declare -i tmp
					counter=0
					data=$(zenity --entry \
						--width 500 \
						--title "Data" \
						--text "Enter data you want to Select")
					#read -p "Enter data you want to Select: " data

					for ((i = 0; i < $colDataLength; i++)); do

						if [[ ${colData[$i]} == $data ]]; then
							tmp=0
							tmp=$i+3

							if ! [[ $data =~ $re ]]; then
								zenity --info \
									--title "Your Data" \
									--width 500 \
									--height 100 \
									--text "$(sed -n ''/"$data"/p'' ./$tableName)"
								#sed -n ''/"$data"/p'' ./$tableName

							else
								deleteLine[$counter]=$tmp
								((counter = $counter + 1))
							fi
						fi
					done
					for ((i = $counter - 1; i >= 0; i--)); do
						zenity --info \
							--title "Your Data" \
							--width 500 \
							--height 100 \
							--text "$(sed -n "${deleteLine[$i]} p" ./$tableName)"
						#sed -n "${deleteLine[$i]} p" ./$tableName
					done
				fi
				;;
			SelectAllData)
				zenity --info \
					--title "Your Data" \
					--width 500 \
					--height 100 \
					--text "$(sed '1,2d' ./$tableName)"
				#sed '1,2d' ./$tableName
				;;
			SelectByColumn)
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

					for ((i = 0; i < $colDataLength; i++)); do
						zenity --info \
							--title "Your Data" \
							--width 500 \
							--height 100 \
							--text "${colData[$i]}"
						#echo ${colData[$i]}
					done
				fi
				;;
			SelectDataWithEquation)
				#echo "Select greater then or lower than"
				colName=$(zenity --entry \
					--width 500 \
					--title "check column" \
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
						--title "Can't found" \
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

					record=$(zenity --list \
						--column "Select option" \
						GreaterThan \
						LowerThan)
					#select record in GreaterThan LowerThan; do
					case $record in
					GreaterThan)
						mark="g"
						#break
						;;
					LowerThan)
						mark="l"
						#break
						;;
					*)
						echo "Wrong Input..."
						;;
					esac
					#done
					comparedData=$(zenity --entry \
						--width 500 \
						--title "Compared Data" \
						--text "Enter where Cluase")
					#read -r -p "Enter where Cluase : " comparedData
					declare columnNum
					for ((i = 0; i < $colDataLength; i++)); do
						((columnNum = $i + 3))
						if [[ $mark == "g" ]]; then
							if ((${colData[$i]} > $comparedData)); then
								zenity --info \
									--title "Your Data" \
									--width 500 \
									--height 100 \
									--text "$(sed -n "$columnNum"'p' ./$tableName)"
								#sed -n "$columnNum"'p' ./$tableName
							fi
						elif [[ $mark == "l" ]]; then
							if ((${colData[$i]} < $comparedData)); then
								zenity --info \
									--title "Your Data" \
									--width 500 \
									--height 100 \
									--text "$(sed -n "$columnNum p" ./$tableName)"
								#sed -n "$columnNum p" ./$tableName
							fi
						else
							zenity --error \
								--title "Can't Find" \
								--width 500 \
								--height 100 \
								--text "No Data Found..."
							#echo "No Data Found..."
						fi
					done
				fi
				;;
			Back)
				tableExist=1
				break
				;;
			*)
				zenity --error \
					--title "Wrong input" \
					--width 500 \
					--height 100 \
					--text "It's not option"
				#echo "It's not option"
				;;
			esac
			flag=0
			#echo "1)SelectByRow        2)SelectAllData        3)SelectByColumn        4)SelectDataWithEquation        5)Back"
		done

	fi

else
	zenity --error \
		--title "Wrong input" \
		--width 500 \
		--height 100 \
		--text "Wrong Format..."
	#echo "Wrong Format..."
	tableExist=1
fi

