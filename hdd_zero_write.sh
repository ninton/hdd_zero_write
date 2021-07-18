#!/bin/bash -eu

if [[ "$1" == "" ]]; then
    echo "Write zero to hard disk (SSD)"
    echo "hdd_zero_write.sh <block device>"
    echo "example"
    echo "  hdd_zero_write.sh /dev/sdc"
    exit -1
fi

dev=$1

total_bytes=$(lsblk --noheadings --bytes $dev | head --lines=1 | sed -r 's/ +/ /g' | cut --delimiter=' ' --fields=4)
echo "total_bytes=$total_bytes"

read_bytes=$((1024 * 1024 * 1024))


remain_bytes=$total_bytes
notzero_bytes=0

for ((i = 0; $i * $read_bytes < $total_bytes; i += 1)); do
    remain_bytes=$(($total_bytes - $i * $read_bytes))
    if [[ $remain_bytes -lt $read_bytes ]]; then
        write_bytes=$remain_bytes
    else
        write_bytes=$read_bytes
    fi

    echo ""
    echo "skip=$i"
    notzero_bytes_per_block=$(sudo dd status=noxfer if=$dev count=1 ibs=$read_bytes skip=$i | ./notzero_bytes)
    
    if [[ $notzero_bytes_per_block > 0 ]]; then
        echo "notzero_bytes_per_block=$notzero_bytes_per_block"
        echo "dd if=/dev/zero of=$dev count=1 ibs=$read_bytes obs=$write_bytes  seek=$i"
        sudo dd if=/dev/zero of=$dev count=1 ibs=$read_bytes obs=$write_bytes  seek=$i

        notzero_bytes_per_block=$(sudo dd status=noxfer if=$dev count=1 ibs=$read_bytes skip=$i | ./notzero_bytes)
        echo "notzero_bytes_per_block=$notzero_bytes_per_block"
    fi

    notzero_bytes=$(($notzero_bytes + $notzero_bytes_per_block))
    echo "notzero_bytes=$notzero_bytes"
done

echo notzero_bytes=$notzero_bytes
