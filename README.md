# Smart Barcode Generator

A modern Qt/QML application for generating various types of barcodes with a user-friendly interface.

## Features

- **Multiple Barcode Types**: Supports various barcode symbologies through the Zint library
- **Real-time Generation**: Generate barcodes instantly as you type
- **Modern UI**: Clean, responsive interface built with Qt Quick Controls
- **Error Handling**: Clear error messages for invalid inputs or generation issues
- **Cross-platform**: Runs on Windows, macOS, and Linux

## Screenshots

The application features a clean, intuitive interface with:

- Text input field for the data to encode
- Dropdown menu to select barcode type
- Real-time barcode preview
- Error messages and loading indicators

## Requirements

### Build Requirements

- Qt 6.x or Qt 5.15+
- Qt Quick Controls 2
- C++17 compatible compiler
- CMake 3.16+ or qmake

### Libraries

- **Zint**: For barcode generation (included or linked)
- **Qt Modules**: QtQuick, QtQuickControls2, QtGui

## Installation

### Option 1: Build from Source

1. **Clone the repository**

   ```bash
   git clone [your-repo-url]
   cd smart-barcode-generator
   ```

2. **Install Qt and dependencies**

   - Download Qt from https://qt.io/download
   - Install Zint library for your platform

3. **Build the project**

   ```bash
   mkdir build
   cd build
   qmake .. # or use CMake
   make     # or nmake on Windows
   ```

4. **Run the application**
   ```bash
   ./BarcodeGenerator  # or BarcodeGenerator.exe on Windows
   ```

### Option 2: Using Qt Creator

1. Open Qt Creator
2. Open the project file (.pro or CMakeLists.txt)
3. Configure the kit and build settings
4. Build and run the project

## Usage

1. **Enter Text**: Type the text you want to encode in the input field
2. **Select Barcode Type**: Choose from the dropdown menu (Code 128, QR Code, etc.)
3. **Generate**: Click the "Generate Barcode" button
4. **View Result**: Your barcode will appear in the preview area

### Supported Barcode Types

The application supports numerous barcode symbologies including:

- Code 128
- Code 39
- QR Code
- Data Matrix
- EAN-13/EAN-8
- UPC-A/UPC-E
- And many more...

## Project Structure

```
├── main.cpp                      # Application entry point
├── Main.qml                      # Main UI interface
├── BarcodeGenerator.h/.cpp       # Core barcode generation logic
├── BarcodeImageProvider.h/.cpp   # QML image provider for barcodes
├── Symbologies.h                 # Barcode symbology definitions
└── README.md                     # This file
```

## Key Components

- **BarcodeGenerator**: C++ class that interfaces with the Zint library
- **BarcodeImageProvider**: Provides generated barcode images to QML
- **Main.qml**: User interface with input controls and barcode display
- **Symbologies**: Mapping of barcode names to Zint symbology codes

## Error Handling

The application includes comprehensive error handling for:

- Empty input text
- Invalid barcode data for selected symbology
- Library initialization failures
- Image generation errors

## Development

### Adding New Features

1. **New Symbologies**: Add entries to the symbology mapping in `Symbologies.h`
2. **UI Improvements**: Modify `Main.qml` for interface changes
3. **Backend Logic**: Extend `BarcodeGenerator` class for new functionality

### Debugging

- Check Qt Creator's application output for debug messages
- Verify Zint library installation and linking
- Ensure all required Qt modules are installed

## Troubleshooting

### Common Issues

**"Failed to create ZBarcode symbol"**

- Check Zint library installation
- Verify library linking in build configuration

**Barcode not displaying**

- Check image provider registration in `main.cpp`
- Verify QML image source path format

**Build errors**

- Ensure Qt development environment is properly configured
- Check compiler compatibility with C++17 features

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request
