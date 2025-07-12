// Performance Audit Script
// Run this in the browser console to analyze performance

console.log('🔍 Starting Performance Audit...');

// Performance timing API
const perfData = performance.getEntriesByType('navigation')[0];
const paintTimings = performance.getEntriesByType('paint');

console.log('📊 Performance Metrics:');
console.log('DOM Content Loaded:', perfData.domContentLoadedEventEnd - perfData.domContentLoadedEventStart, 'ms');
console.log('Load Complete:', perfData.loadEventEnd - perfData.loadEventStart, 'ms');
console.log('First Paint:', paintTimings.find(p => p.name === 'first-paint')?.startTime || 'N/A', 'ms');
console.log('First Contentful Paint:', paintTimings.find(p => p.name === 'first-contentful-paint')?.startTime || 'N/A', 'ms');

// Resource loading analysis
const resources = performance.getEntriesByType('resource');
const imageResources = resources.filter(r => r.initiatorType === 'img');
const cssResources = resources.filter(r => r.initiatorType === 'css');

console.log('\n📦 Resource Analysis:');
console.log('Total Resources:', resources.length);
console.log('Images:', imageResources.length);
console.log('CSS Files:', cssResources.length);

// Image optimization check
const images = document.querySelectorAll('img');
let totalImageSize = 0;
let imagesWithoutDimensions = 0;
let imagesWithoutLazyLoading = 0;

images.forEach(img => {
    if (!img.width || !img.height) imagesWithoutDimensions++;
    if (!img.loading) imagesWithoutLazyLoading++;
});

console.log('\n🖼️ Image Optimization:');
console.log('Total Images:', images.length);
console.log('Images without dimensions:', imagesWithoutDimensions);
console.log('Images without lazy loading:', imagesWithoutLazyLoading);

// CSS analysis
const stylesheets = document.querySelectorAll('link[rel="stylesheet"]');
console.log('\n🎨 CSS Analysis:');
console.log('Stylesheets:', stylesheets.length);
stylesheets.forEach(sheet => {
    console.log('-', sheet.href);
});

// Font analysis
const fonts = document.querySelectorAll('link[href*="fonts.googleapis.com"]');
console.log('\n🔤 Font Analysis:');
console.log('Google Fonts:', fonts.length);

// Performance recommendations
console.log('\n💡 Performance Recommendations:');

if (imagesWithoutDimensions > 0) {
    console.log('⚠️ Add width and height attributes to images to prevent layout shifts');
}

if (imagesWithoutLazyLoading > 0) {
    console.log('⚠️ Add loading="lazy" to non-critical images');
}

if (resources.length > 20) {
    console.log('⚠️ Consider reducing the number of HTTP requests');
}

// Core Web Vitals estimation
const fcp = paintTimings.find(p => p.name === 'first-contentful-paint')?.startTime;
if (fcp && fcp > 1800) {
    console.log('⚠️ First Contentful Paint is above recommended threshold (1.8s)');
}

console.log('\n✅ Performance audit complete!');