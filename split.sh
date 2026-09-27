#!/bin/bash

# Usage: ./split.sh <input_video> <segment_seconds>
# Example: ./split.sh death.mp4 1

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_video> <segment_seconds>"
    exit 1
fi

INPUT="$1"
SEGMENT="$2"

if [ ! -f "$INPUT" ]; then
    echo "Error: file '$INPUT' not found."
    exit 1
fi

# Extract duration (HH:MM:SS.xx) from ffmpeg -i output on stderr
DUR_STR=$(ffmpeg -i "$INPUT" 2>&1 | grep -oP 'Duration: \K[0-9:.]+' | head -n1)

if [ -z "$DUR_STR" ]; then
    echo "Error: could not determine duration from '$INPUT'."
    exit 1
fi

# Convert HH:MM:SS.xx to total seconds
DURATION=$(awk -F: '{ print ($1*3600) + ($2*60) + $3 }' <<< "$DUR_STR")

# Compute number of segments (ceil)
N=$(awk -v d="$DURATION" -v s="$SEGMENT" 'BEGIN { print int((d + s - 0.0001) / s) }')

BASENAME="${INPUT%.*}"

echo "Input:    $INPUT"
echo "Duration: ${DURATION}s  (raw: $DUR_STR)"
echo "Segment:  ${SEGMENT}s"
echo "Splits:   $N"

for i in $(seq 1 "$N"); do
    START=$(awk -v i="$i" -v s="$SEGMENT" 'BEGIN { print (i - 1) * s }')
    OUT=$(printf "%s_%02d.mp4" "$BASENAME" "$i")
    ffmpeg -y -ss "$START" -i "$INPUT" -t "$SEGMENT" \
        -c:v libx264 -preset fast -crf 18 -pix_fmt yuv420p \
        -an "$OUT"
    echo "Created $OUT"
done