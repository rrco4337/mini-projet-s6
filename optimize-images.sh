#!/bin/bash

# Script to optimize images for web (converts to WebP, compresses)
# Usage: bash optimize-images.sh /path/to/images

IMAGES_DIR="${1:-.}"
OUTPUT_DIR="$IMAGES_DIR/optimized"

if ! command -v ffmpeg &> /dev/null; then
    echo "❌ ffmpeg not found. Install it:"
    echo "   brew install ffmpeg  (macOS)"
    echo "   apt-get install ffmpeg  (Linux)"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "🖼️  Optimizing images in: $IMAGES_DIR"
echo "📁 Output: $OUTPUT_DIR"

# Convert and compress all JPG/PNG to WebP
for file in "$IMAGES_DIR"/*.{jpg,jpeg,png}; do
    [ -e "$file" ] || continue
    
    filename=$(basename "$file")
    name="${filename%.*}"
    
    # Convert to WebP with quality 80 (best balance)
    ffmpeg -i "$file" -q:v 80 "$OUTPUT_DIR/${name}.webp" -y 2>/dev/null
    
    # Get original and new size
    orig_size=$(du -h "$file" | cut -f1)
    new_size=$(du -h "$OUTPUT_DIR/${name}.webp" | cut -f1#!/bin/bash

# Script to optimize images for web (converts to WebP, compresses)
# Usageco
# Script gin# Usage: bash optimize-images.sh /path/to/images

IMAGES_DIR="${1do
IMAGES_DIR="${1:-.}"
OUTPUT_DIR="$IMAGES_DIR/ome=OUTPUT_DIR="$IMAGES
    name="${filename%.*}"
    ext="${    echo "❌ ffmpeg not found. Install im    echo "   brew install ffmpeg  (macOS)"
co    echo "  v/null; then
        convert "$file" -quality 85 -strip "$OUTPUT_DIR/${name}_fi

mkdird.
{ex
echo "🖼️  Optim   echo "📁 Output: $OUTPUT_DIR"

#compressed.${ext
# Convert and compress all JP?or file in "$IMAGES_DIR"/*.{jpg,jpeg,pngGE    [ -e "$file" ] || continue
    
    filen(r    
    filename=$(basenam"?  ex    name="${filename%.*}"
    
ri    
    # Convert to Weersions    ffmpeg -i "$file" -q:v 80 "$OUTPUT_DIR/${name}.at    
    # Get original and new size
    orig_size=$(du -h "$file" | ces    v    on control"
