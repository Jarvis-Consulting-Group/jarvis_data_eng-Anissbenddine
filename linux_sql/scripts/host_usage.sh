# usage info
memory_free=$(vmstat --unit M | tail -1 | awk -v col="4" '{print $col}')
cpu_idle=$(vmstat | tail -1 | awk '{print $15}')
cpu_kernel=$(vmstat | tail -1 | awk '{print $14}')
disk_io=$(vmstat --unit M -d | tail -1 | awk -v col="10" '{print $col}')
disk_available=$(df -h / | awk 'NR==2{print $4}')


echo "Usage Info:"
echo "Free Memory: $memory_free MB"
echo "CPU Idle: $cpu_idle"
echo "CPU Kernel: $cpu_kernel"
echo "Disk I/O: $disk_io MB/s"
echo "Disk Available: $disk_available"