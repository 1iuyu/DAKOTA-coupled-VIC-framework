#! /bin/bash
VIC_EXECUTABLE="/mnt/path/to/VIC-master/vic/drivers/classic/vic_classic.exe"
for i in {1..40}
do
    PARAM_FILE="/mnt/path/to/YellowRiver/vic_out_/parallel/global_param_$i.txt"
    $VIC_EXECUTABLE -g "$PARAM_FILE" > /dev/null 2>&1 &
done

wait  # 等待所有后台任务完成

cd /home/path/to/YellowRiver/out_classic
rename 's/\.txt$//' *
/mnt/path/to/VIC_routing/src/rout /path/to/YellowRiver/routing/rout_input.txt
