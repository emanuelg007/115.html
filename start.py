#!/usr/bin/env python3
"""
Quick start script for the Enhanced Cutting Diagram Tool
Usage: python3 start.py [port]
"""
import sys
import http.server
import socketserver
import webbrowser
import os
from pathlib import Path

def main():
    # Default port
    port = 8080
    
    # Check if port is provided as argument
    if len(sys.argv) > 1:
        try:
            port = int(sys.argv[1])
        except ValueError:
            print("Error: Port must be a number")
            sys.exit(1)
    
    # Change to script directory
    os.chdir(Path(__file__).parent)
    
    # Create handler
    handler = http.server.SimpleHTTPRequestHandler
    
    try:
        with socketserver.TCPServer(("", port), handler) as httpd:
            url = f"http://localhost:{port}/115%20fixed%20.html"
            print(f"🚀 Starting Enhanced Cutting Diagram Tool")
            print(f"📍 Server running at: http://localhost:{port}")
            print(f"🔗 Application URL: {url}")
            print(f"📱 Opening in browser...")
            print(f"⏹️  Press Ctrl+C to stop the server")
            
            # Try to open browser
            try:
                webbrowser.open(url)
            except Exception as e:
                print(f"⚠️  Could not auto-open browser: {e}")
                print(f"Please manually open: {url}")
            
            # Start server
            httpd.serve_forever()
            
    except KeyboardInterrupt:
        print(f"\n👋 Server stopped")
    except OSError as e:
        if "Address already in use" in str(e):
            print(f"❌ Port {port} is already in use. Try a different port:")
            print(f"   python3 start.py {port + 1}")
        else:
            print(f"❌ Error starting server: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()