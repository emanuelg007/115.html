# Enhanced Cutting Diagram Tool v3.0

A professional-grade web application for generating optimized cutting diagrams and printing labels for woodworking and manufacturing projects.

## ⚡ Quick Answer: What to Type in Terminal

**Easiest way (recommended):**
```bash
# Navigate to the project folder
cd /path/to/115.html

# Run the Python start script
python3 start.py

# Or on Windows, double-click start.bat
# Or on Unix/Linux/Mac, run ./start.sh
```

**Alternative (if you don't have the start scripts):**
```bash
# Navigate to the project folder
cd /path/to/115.html

# Start a simple HTTP server
python3 -m http.server 8080

# Then open this URL in your browser:
# http://localhost:8080/115%20fixed%20.html
```

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

**Simple Examples (start here):**
- `simple_cutting_list.csv` - Minimal example with 3 parts
- `simple_board_master.csv` - Basic board sizes

**Complex Examples:**
- `sample_cutting_list.csv` - Complete cabinet project with doors, shelves, panels, and edging
- `sample_board_master.csv` - Multiple materials and grain directions

**To test the application:**
1. Start the application using one of the methods above
2. Click "📋 Upload Cutting List" and select a cutting list CSV
3. Click "📏 Upload Board Master" and select the corresponding board master CSV
4. Click "🚀 Process CSVs" to generate cutting diagrams
5. Navigate through different material tabs to see the optimized layouts

**Tip:** Start with the simple examples first to verify everything works, then try the complex ones.

## 🛠️ Troubleshooting

### Common Issues:

**1. "Can't load external resources" or CORS errors**
- Use an HTTP server (Methods above) instead of opening the file directly
- Don't open with `file://` protocol for full functionality

**2. "Please select both CSV files" or CSV processing errors**
- Ensure CSV files have the exact required headers:
  - **Cutting List**: `Name`, `Length`, `Width`, `Quantity`, `Material`
  - **Board Master**: `Material`, `board length  `, `board width  ` (note the trailing spaces!)
- Make sure files are properly formatted CSV (comma-separated)
- Check that there are no extra blank lines or special characters

**3. Zebra printer not detected**
- Ensure Zebra Browser Print is installed and running
- Check if `https://localhost:9101` is accessible
- Verify printer is connected and powered on

**4. JavaScript errors**
- Make sure you're using a modern browser (Chrome, Firefox, Safari, Edge)
- Clear browser cache and reload

### CSV Format Requirements:

**Cutting List CSV must have these headers (exact case):**
- Name, Length, Width, Quantity, Material
- Optional: Can Rotate (0 = No / 1 = Yes / 2 = Same As Material), Edging Length 1, Edging Length 2, Edging Width 1, Edging Width 2, Note 1, Note 2

**Board Master CSV must have these headers (note trailing spaces):**
- Material, board length  , board width  
- Optional: Thickness, CanRotate, Kerf, Grain Direction

## 📁 File Structure

```
115.html/
├── 115 fixed .html           # Main application file
├── DESIGN.md                 # Software design documentation
├── README.md                 # This file
├── start.py                  # Python quick-start script
├── start.bat                 # Windows quick-start script
├── start.sh                  # Unix/Linux/macOS quick-start script
└── samples/                      # Sample CSV files for testing
    ├── simple_cutting_list.csv      # Basic example (start here)
    ├── simple_board_master.csv      # Basic board sizes
    ├── sample_cutting_list.csv      # Complex cabinet project
    └── sample_board_master.csv      # Multiple materials
```

## 🔧 Development

This is a single-file application with inline CSS and JavaScript. All dependencies are loaded via CDN:
- Zebra Browser Print SDK (localhost:9101)
- jsPDF (cdnjs.cloudflare.com)

No build process required - it's ready to run as-is!