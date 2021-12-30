#!/bin/bash
#
# Runs the speedtest-cli using https://speedtest.net
# Usually two servers are queried. Output results in CSV file
# for import to sqlite db
#

function runTest () {
	local id=$(echo $*|cut -d, -f 1)
	local sname=$(echo $*|cut -d, -f 2)
	local RIGHTNOW=$(date --utc +%Y-%m-%dT%H:%M:%SZ)
	# Run the Speedtest-CLI against the server listed in the main section.
	# The CSV output will be saved in a tmpfile
	echo -n "$RIGHTNOW," > /tmp/speedtest.tmp
	speedtest -f csv -s $id >> /tmp/speedtest.tmp
	if [[ $? -gt 0 ]]
	then
		# Speedtest failed so create a zero entry in place of any error message
		echo "$RIGHTNOW,$sname,$id,0.0,0.0,0,0.0,0.0,0,0.0,null,0" > /tmp/speedtest.tmp
	fi

	# save output ready for next server test
	cat /tmp/speedtest.tmp >> /tmp/speedtest.csv
}

## Main - Run the tests customize your servers here ##
# Add your servers in servers.csv, see https://github.com/ldelouw/speedtest-statistics/blob/master/README.md
# for more information
##

# Remove the old CSV file
rm -f /tmp/speedtest.csv

while read line
do
	[[ "$line" == "#"* ]] && continue
	runTest "$line"
	sleep 10
done < servers.csv

# ensure you customize the PHP script as well when using more than two servers.

# Import to SQLite
/usr/bin/sqlite3 -batch /var/www/html/speedtest-collector.db <<"EOF"
.separator ","
.import /tmp/speedtest.csv bandwidth
EOF
