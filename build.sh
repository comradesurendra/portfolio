#!/bin/bash

# Build script for optimized website deployment

echo "🚀 Starting build process..."

# Create build directory
mkdir -p dist

# Copy HTML file
cp index.html dist/

# Copy CSS directory
cp -r CSS dist/

# Copy service worker
cp sw.js dist/

# Copy favicon
cp images/favicon.ico dist/

# Create optimized images directory
mkdir -p dist/images

# Copy and optimize images (if ImageMagick is available)
if command -v convert &> /dev/null; then
    echo "📸 Optimizing images..."
    ./optimize-images.sh
    
    # Copy optimized images
    cp images/optimized/* dist/images/ 2>/dev/null || cp images/* dist/images/
else
    echo "⚠️ ImageMagick not found, copying original images..."
    cp images/* dist/images/
fi

# Create .htaccess for compression (Apache)
cat > dist/.htaccess << 'EOF'
# Enable compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
</IfModule>

# Browser caching
<IfModule mod_expires.c>
    ExpiresActive on
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
</IfModule>
EOF

# Calculate sizes
echo "📊 Build Summary:"
echo "Original size: $(du -sh . | cut -f1)"
echo "Build size: $(du -sh dist/ | cut -f1)"

# List files in build
echo "📁 Build contents:"
find dist/ -type f | head -20

echo "✅ Build complete! Deploy the 'dist' directory to your web server."