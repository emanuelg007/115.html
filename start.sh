#!/bin/bash
# Quick start script for Unix/Linux/macOS
# Usage: ./start.sh [port]

set -e

PORT=${1:-8080}

echo "🚀 Starting Enhanced Cutting Diagram Tool..."

# Check if Python 3 is available
if command -v python3 &> /dev/null; then
    echo "📍 Using Python 3"
    python3 start.py "$PORT"
elif command -v python &> /dev/null; then
    # Check if it's Python 3
    PYTHON_VERSION=$(python --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1)
    if [ "$PYTHON_VERSION" = "3" ]; then
        echo "📍 Using Python 3"
        python start.py "$PORT"
    else
        echo "⚠️  Python 2 detected. Using basic HTTP server..."
        python -m SimpleHTTPServer "$PORT" &
        sleep 2
        URL="http://localhost:$PORT/115%20fixed%20.html"
        echo "🔗 Application URL: $URL"
        
        # Try to open browser
        if command -v xdg-open &> /dev/null; then
            xdg-open "$URL"
        elif command -v open &> /dev/null; then
            open "$URL"
        else
            echo "Please open: $URL"
        fi
        wait
    fi
else
    echo "❌ Python not found. Please install Python 3 and try again."
    echo "Or manually open '115 fixed .html' in your browser."
    exit 1
fi