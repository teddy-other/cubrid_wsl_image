#!/bin/bash
DEMODB_NAME="demodb"

set -e

init_db () {
	if [ -f "$CUBRID_DATABASES/databases.txt" ]; then
		if grep -qwe "^$DEMODB_NAME" "$CUBRID_DATABASES/databases.txt"; then
			echo "Database '$DEMODB_NAME' is initialized already"
			return
		fi
	else
		touch "$CUBRID_DATABASES/databases.txt"
	fi
	chown -R cubrid:cubrid "$CUBRID_DATABASES"

	echo "Initializing database '$DEMODB_NAME'"

	if [ ! -d "$CUBRID_DATABASES/$DEMODB_NAME" ]; then
		mkdir -p "$CUBRID_DATABASES/$DEMODB_NAME"
	fi

	cd "$CUBRID_DATABASES/$DEMODB_NAME"
	cubrid createdb --db-volume-size=100M --log-volume-size=100M $DEMODB_NAME en_US.utf8  > /dev/null 2>&1
    cubrid loaddb -u dba -s $CUBRID/demo/demodb_schema -d $CUBRID/demo/demodb_objects $DEMODB_NAME > /dev/null 2>&1
}

while true; do
	read -p "Would you like to create demo database? (y/n): " CREATE_DEMODB
	if [ "$CREATE_DEMODB" == "y" ] || [ "$CREATE_DEMODB" == "Y" ]; then
		init_db
		cubrid service start
		cubrid server start $DEMODB_NAME
		break
	elif [ "$CREATE_DEMODB" == "n" ] || [ "$CREATE_DEMODB" == "N" ]; then
		cubrid service start
		break
		echo "Invalid input. Please enter y or n."
	fi
done
