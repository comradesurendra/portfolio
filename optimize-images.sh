#!/bin/bash

# Image optimization script
# This script optimizes images for web performance

echo "Starting image optimization..."

# Create optimized images directory
mkdir -p images/optimized

# Function to optimize image
optimize_image() {
    local input="$1"
    local output="$2"
    local quality="$3"
    
    if [ -f "$input" ]; then
        echo "Optimizing $input..."
        convert "$input" -strip -quality "$quality" -resize "800x800>" "$output"
    fi
}

# Optimize PNG images
for img in images/*.png; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        optimize_image "$img" "images/optimized/${filename%.*}_opt.png" 85
    fi
done

# Optimize JPG images
for img in images/*.jpg; do
    if [ -f "$img" ]; then
        filename=$(basename "$img")
        optimize_image "$img" "images/optimized/${filename%.*}_opt.jpg" 85
    fi
done

# Copy SVG and ICO files as they are already optimized
cp images/*.svg images/optimized/ 2>/dev/null || true
cp images/*.ico images/optimized/ 2>/dev/null || true

echo "Image optimization complete!"
echo "Original size: $(du -sh images/ | cut -f1)"
echo "Optimized size: $(du -sh images/optimized/ | cut -f1)"