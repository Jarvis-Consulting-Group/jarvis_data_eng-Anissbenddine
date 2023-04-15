#!/bin/bash
hostname=$(hostname -f)

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi


lscpu_out=$(lscpu)
cpu_number=$(echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)

total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')

timestamp=$(date -u +"%Y-%m-%d %H:%M:%S")

memory_free=$(vmstat --unit M | tail -1 | awk -v col="4" '{print $col}')
cpu_idel=$(vmstat | tail -1 | awk '{print $15}')
cpu_kernel=$(vmstat | tail -1 | awk '{print $14}')

disk_io=$(vmstat -d | tail -1 | awk '{print $10}')
disk_available=$(df -BM / | tail -1 | awk '{print $4}' | sed 's/[^0-9]*//g')
export PGPASSWORD=$psql_password
host_id=$(psql -h "$psql_host" -p "$psql_port" -d "$db_name" -U "$psql_user" -t -c "SELECT id FROM host_info WHERE hostname='$hostname'")
insert_stmt="INSERT INTO host_usage\
(host_id, memory_free, cpu_idel, cpu_kernel, disk_io, disk_available, timestamp) \
VALUES('$host_id', '$memory_free', '$cpu_idel', '$cpu_kernel', '$disk_io', '$disk_available', '$timestamp')"
export PGPASSWORD=$psql_password
psql -h "$psql_host" -p "$psql_port" -d "$db_name" -U "$psql_user" -c "$insert_stmt"

exit $?