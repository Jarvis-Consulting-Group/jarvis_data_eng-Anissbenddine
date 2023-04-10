# save hostname as a variable
hostname=$(hostname -f)

# save the number of CPUs to a variable
lscpu_out=$(lscpu)
cpu_number=$(echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)

# hardware info
cpu_architecture=$(echo "$lscpu_out" | grep "Architecture" | awk '{print $2}')
cpu_model=$(echo "$lscpu_out" | grep "Model name" | awk -F ': ' '{print $2}')
cpu_mhz=$(echo "$lscpu_out" | grep "CPU MHz" | awk '{print $3}')
l2_cache=$(echo "$lscpu_out" | grep "L2 cache" | awk '{print $3}')
total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')
timestamp=$(date -u +"%Y-%m-%d %H:%M:%S")


# print hardware info
echo "Hardware Info:"
echo "Hostname: $hostname"
echo "Number of CPUs: $cpu_number"
echo "CPU Architecture: $cpu_architecture"
echo "CPU Model: $cpu_model"
echo "CPU MHz: $cpu_mhz"
echo "L2 Cache: $l2_cache"
echo "Total Memory: $total_mem MB"
echo "Timestamp: $timestamp"