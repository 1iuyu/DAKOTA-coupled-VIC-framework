#! /bin/bash
# VIC_EXECUTABLE为VIC可执行文件的路径
VIC_EXECUTABLE = "/mnt/path/to/VIC-master/vic/drivers/classic/vic_classic.exe"
for i in {1..40}
do
    PARAM_FILE = "/mnt/path/to/YellowRiver/vic_out_/parallel/global_param_$i.txt"
    $VIC_EXECUTABLE -g "$PARAM_FILE" &
done

# 模型汇流
#/mnt/path/to/VIC_routing/src/rout /path/to/YellowRiver/routing/rout_input.txt
