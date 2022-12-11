#!/bin/bash
echo "Watching for files ending in .mp3 or .ogg in current directory"
inotifywait -m -e close_write --format %f . |
while read filename;
do 
	if [[ $filename == *.mp3 || $filename == *.ogg ]]; then 
		echo "File $filename detected"
		filename2=$(echo "$filename" | cut -f 1 -d '.')
		echo "Converting file to wav"
		ffmpeg -i "$filename" -ar 16000 -ac 1 -c:a pcm_s16le "$filename2".wav
		echo "Processing file" 
		/home/dragon/Downloads/whisper.cpp/main -m /home/dragon/Downloads/whisper.cpp/models/ggml-medium.bin -f "$filename2".wav -otxt
	fi
done
echo "Stopped watching for files"
