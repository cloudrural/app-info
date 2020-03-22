#!/bin/bash
module="$1"
propFile="$2"
propDir="$3"

# ENV
APP_HOME=${PWD}/../

# replace $1 - installer variable name, $2 - env variable name, $3 - value from env, $4 - default value
function replace() {
    echo "replacing $1, $2, $3, $4  ..."

    if [ "$3" = "" ] || [ "$3" = "$" ]
    then
        VALUE=$4
    else
        VALUE=$3
    fi

    export $(eval echo $2=$VALUE)
    echo "export $(eval echo $2=$VALUE)" >> $APP_HOME/webapps/.profile
    xargs sed -i -e "s|\#$1\#|$(eval echo \$$2)|g" < $propDir/$1.files
}

echo "Configuring $module ..."

while read -r line
do
    [ "$line" = "" ] || [ "${line:0:1}" = "#" ] && continue
    f2=$(echo $line | cut -d, -f2)
    f3=$(echo $line | cut -d, -f3)
    f4=$(echo $line | cut -d, -f4)

    eval val=\$$f3
    replace $f2 $f3 $val $f4

done < "$propFile"

. $APP_HOME/webapps/.profile

echo "Configuring $module done."
