# Enhanced Cutting Diagram Tool v3.0

A professional-grade web application for generating optimized cutting diagrams and printing labels for woodworking and manufacturing projects.

## 🚀 How to Run This Application

### Quick Start (Easiest)

**Option 1: Use the provided start scripts**
```bash
# On Windows (double-click or run in cmd):
start.bat

# On macOS/Linux/Unix:
./start.sh

# Or with Python directly:
python3 start.py
```

**Option 2: Manual Python Server (Recommended)**
```bash
# Navigate to the project directory
cd /path/to/115.html

# Python 3 (recommended)
python3 -m http.server 8080

# Then open your browser to:
# http://localhost:8080/115%20fixed%20.html
```

### Alternative Methods

**Method 1: Simple File Opening (Basic)**
```bash
# Simply open the HTML file in your browser
# On Windows:
start "115 fixed .html"

# On macOS:
open "115 fixed .html"

# On Linux:
xdg-open "115 fixed .html"
```

**Method 3: Node.js HTTP Server**
```bash
# Install a simple HTTP server globally
npm install -g http-server

# Navigate to project directory and start server
cd /path/to/115.html
http-server -p 8080

# Then open your browser to:
# http://localhost:8080/115%20fixed%20.html
```

**Method 4: PHP Built-in Server**
```bash
# Navigate to project directory
cd /path/to/115.html

# Start PHP server
php -S localhost:8080

# Then open your browser to:
# http://localhost:8080/115%20fixed%20.html
```

**Method 5: Using Live Server (VS Code Extension)**
If you're using Visual Studio Code:
1. Install the "Live Server" extension
2. Right-click on `115 fixed .html`
3. Select "Open with Live Server"

## 🖨️ Zebra Printer Setup (Required for Direct Printing)

To use the Zebra label printing functionality:

### 1. Install Zebra Browser Print
```bash
# Download and install from:
# https://www.zebra.com/us/en/software/printer-software/browser-print.html

# The service will run on https://localhost:9101
```

### 2. Connect Your ZT230 Printer
- Connect via USB or network
- Ensure the printer is powered on and ready
- Test connection using the "Test Print" button in the app

### 3. Browser Security Settings
Since the Zebra Browser Print service runs on `localhost:9101` with HTTPS, you may need to:
- Accept the self-signed certificate warning
- Add `localhost:9101` to trusted sites if prompted

## 📋 Features Overview

- **CSV Import**: Upload Cutting List and Board Master CSV files
- **Optimization**: Advanced nesting algorithms for material efficiency
- **Visualization**: Interactive cutting diagrams with zoom/pan
- **Label Printing**: Both browser and direct Zebra printer support
- **PDF Export**: Generate printable sheets
- **Project Management**: Save/load projects locally
- **Analytics**: Material utilization reports

## 🧪 Testing with Sample Data

Sample CSV files are provided in the `samples/` directory:
- `sample_cutting_list.csv` - Example cabinet project with doors, shelves, and panels
- `sample_board_master.csv` - Standard sheet sizes for MDF, plywood, and solid wood

To test the application:
1. Start the application using one of the methods above
2. Click "📋 Upload Cutting List" and select `samples/sample_cutting_list.csv`
3. Click "📏 Upload Board Master" and select `samples/sample_board_master.csv`
4. Click "🚀 Process CSVs" to generate cutting diagrams
5. Navigate through different material tabs to see the optimized layouts

## 🛠️ Troubleshooting

### Common Issues:

**1. "Can't load external resources" or CORS errors**
- Use an HTTP server (Methods 2-4 above) instead of opening the file directly
- Don't open with `file://` protocol for full functionality

**2. Zebra printer not detected**
- Ensure Zebra Browser Print is installed and running
- Check if `https://localhost:9101` is accessible
- Verify printer is connected and powered on

**3. CSV files not processing**
- Check CSV format matches the requirements in the Help section
- Ensure files have proper headers (see DESIGN.md for details)

**4. JavaScript errors**
- Make sure you're using a modern browser (Chrome, Firefox, Safari, Edge)
- Clear browser cache and reload

## 📁 File Structure

```
115.html/
├── 115 fixed .html           # Main application file
├── DESIGN.md                 # Software design documentation
├── README.md                 # This file
├── start.py                  # Python quick-start script
├── start.bat                 # Windows quick-start script
├── start.sh                  # Unix/Linux/macOS quick-start script
└── samples/                  # Sample CSV files for testing
    ├── sample_cutting_list.csv
    └── sample_board_master.csv
```

## 🔧 Development

This is a single-file application with inline CSS and JavaScript. All dependencies are loaded via CDN:
- Zebra Browser Print SDK (localhost:9101)
- jsPDF (cdnjs.cloudflare.com)

No build process required - it's ready to run as-is!