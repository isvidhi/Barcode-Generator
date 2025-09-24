# Barcode Generator

A simple and efficient C++/Qt-based barcode generator powered by the [Zint Barcode Library](https://zint.org.uk/).  
This project allows you to generate various types of barcodes from text input and save them as images.

## ✨ Features

- Generate 1D & 2D barcodes (e.g., Code128, QR Code, etc.)
- Lightweight and easy to integrate in C++/Qt projects
- Export barcodes as PNG images
- Customizable scale and symbology

## 🛠️ Technologies

- **C++17**
- **Qt 5/6** (for `QImage`, `QUrl`, and file handling)
- **Zint Barcode Library** (for barcode generation)

## 📁 Project Structure

```
├── BarcodeGenerator.h      # Header file for the BarcodeGenerator class
├── BarcodeGenerator.cpp    # Implementation (uses Zint + Qt)
├── main.cpp               # Example usage (if added)
└── README.md              # Project documentation
```

## 🚀 Usage

```cpp
// Example usage code would go here
#include "BarcodeGenerator.h"

int main() {
    BarcodeGenerator generator;
    generator.generateBarcode("Hello World", "output.png");
    return 0;
}
```

## ⚙️ Build Instructions

### Prerequisites

- CMake or qmake (depending on your setup)
- Qt development environment (Qt 5 or 6)
- Zint library installed

### Build with CMake

```bash
mkdir build && cd build
cmake ..
make
```

### Build with qmake

```bash
qmake
make
```
