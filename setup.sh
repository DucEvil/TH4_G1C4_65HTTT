#!/bin/bash
# Build & Run Flutter Flower Sales App
# Usage: ./setup.sh

echo "=== Flutter Flower Sales List Setup ===="
echo ""
echo "📦 Step 1: Downloading dependencies..."
flutter pub get

echo ""
echo "🔍 Step 2: Analyzing code..."
flutter analyze

echo ""
echo "✅ Setup complete!"
echo ""
echo "🚀 To run the app, use:"
echo "   flutter run              # Android/iOS"
echo "   flutter run -d chrome    # Web"
echo ""
echo "📱 Don't forget to update your name and ID in:"
echo "   lib/config/api_config.dart"
echo ""
