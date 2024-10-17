#!/bin/bash

# 检查输入参数
if [ $# -ne 2 ]; then
    echo "用法: $0 <输入MP4文件> <输出MP4文件>"
    exit 1
fi

input_file="$1"
output_file="$2"
temp_dir="temp_ts_files"

# 创建临时目录
mkdir -p "$temp_dir"

# 获取视频总时长（秒）
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_file")
duration=${duration%.*}

# 计算每个片段的时长，以确保大约2M大小
bitrate=$(ffprobe -v error -select_streams v:0 -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 "$input_file")
segment_duration=$((16*1024*1024 / bitrate))

echo "开始切割视频..."

# 切割MP4为TS文件，并显示进度
ffmpeg -i "$input_file" -c copy -f segment -segment_time $segment_duration \
    -segment_list "$temp_dir/playlist.m3u8" -segment_format mpegts \
    -max_muxing_queue_size 1024 -analyzeduration 100M -probesize 100M \
    "$temp_dir/segment%03d.ts" \
    -progress - -nostats | while read line; do
    if [[ $line == progress=* ]]; then
        progress=${line#progress=}
        if [ "$progress" = "end" ]; then
            echo "切割完成"
        else
            current_time=${line#out_time_ms=}
            current_time=$((current_time/1000000))
            percent=$((current_time*100/duration))
            echo -ne "切割进度: $percent%\r"
        fi
    fi
done

echo "开始合并TS文件..."

# 使用concat demuxer合并TS文件为新的MP4
find "$temp_dir" -name "*.ts" | sort | sed "s/^/file '/" | sed "s/$/'/" > concat_list.txt
ffmpeg -f concat -safe 0 -i concat_list.txt -c copy -bsf:a aac_adtstoasc \
    -max_muxing_queue_size 1024 -analyzeduration 100M -probesize 100M \
    -progress - -nostats "$output_file" | while read line; do
    if [[ $line == progress=* ]]; then
        progress=${line#progress=}
        if [ "$progress" = "end" ]; then
            echo "合并完成"
        else
            current_time=${line#out_time_ms=}
            current_time=$((current_time/1000000))
            percent=$((current_time*100/duration))
            echo -ne "合并进度: $percent%\r"
        fi
    fi
done

# 清理临时文件
rm -rf "$temp_dir" concat_list.txt

echo "处理完成。输出文件: $output_file"