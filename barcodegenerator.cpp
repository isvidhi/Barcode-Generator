#include "BarcodeGenerator.h"
#include <QUrl>
#include <QImage>
#include <QStandardPaths>
#include <QDebug>
#include <zint.h>
#include "Symbologies.h"
#include <QDateTime>

BarcodeGenerator::BarcodeGenerator(QObject *parent) : QObject(parent) {}

QStringList BarcodeGenerator::getSymbologyNames() {
    QMap<QString,int> symbologies = getZintSymbologies();
    return symbologies.keys();
}

int BarcodeGenerator::getSymbologyCode(const QString &name) {
    QMap<QString,int> symbologies = getZintSymbologies();
    return symbologies.value(name, 58);
}

QImage BarcodeGenerator::generate(const QString &text, int symbology, int rotate, int showHrt, int height, int width) {
    struct zint_symbol *symbol = ZBarcode_Create();
    if (!symbol) {
        emit errorOccurred("Failed to create ZBarcode symbol");
        return QImage();
    }

    symbol->symbology = symbology;
    symbol->scale = 2.0;
    symbol->show_hrt = showHrt;

    if (height > 0) {
        symbol->height = height;
    }

    if (width > 0) {
        symbol->width = width;
    }

    QByteArray utf8 = text.toUtf8();
    int result = ZBarcode_Encode(symbol, reinterpret_cast<const unsigned char*>(utf8.data()), utf8.size());

    if (result != 0) {
        QString errorMsg = QString(symbol->errtxt);
        emit errorOccurred("Error: " + errorMsg);
        ZBarcode_Delete(symbol);
        return QImage();
    }

    result = ZBarcode_Buffer(symbol,rotate);
    if (result != 0) {
        QString errorMsg = QString(symbol->errtxt);
        emit errorOccurred("Error: " + errorMsg);
        ZBarcode_Delete(symbol);
        return QImage();
    }


    QImage img(symbol->bitmap_width, symbol->bitmap_height, QImage::Format_RGB32);
    img.fill(Qt::white);

    unsigned char *bitmap = symbol->bitmap;

    for (int y = 0; y < symbol->bitmap_height; ++y) {
        for (int x = 0; x < symbol->bitmap_width; ++x) {
            // Zint bitmap is RGB format (3 bytes per pixel)
            int index = (y * symbol->bitmap_width + x) * 3;
            unsigned char r = bitmap[index];
            unsigned char g = bitmap[index + 1];
            unsigned char b = bitmap[index + 2];

            if (r < 128 || g < 128 || b < 128) {
                img.setPixel(x, y, qRgb(0, 0, 0));
            } else {
                img.setPixel(x, y, qRgb(255, 255, 255));
            }
        }
    }

    ZBarcode_Delete(symbol);
    return img;
}

bool BarcodeGenerator::saveBarcodeToPath(const QString &text, const QString &symbologyName, int rotate, int showHrt, const QString &height, const QString &width, const QString &filePath) {
    int symbologyCode = getSymbologyCode(symbologyName);
    int h = height.toInt();
    int w = width.toInt();

    QImage barcodeImg = generate(text, symbologyCode, rotate, showHrt, h, w);

    // Clean the file path (remove file:// prefix)
    QString cleanPath = filePath;
    if (cleanPath.startsWith("file://")) {
        cleanPath = cleanPath.mid(7);
#ifdef Q_OS_WIN
        if (cleanPath.startsWith("/")) {
            cleanPath = cleanPath.mid(1);
        }
#endif
    }

    if (barcodeImg.isNull()) {
        emit errorOccurred("Failed to generate barcode for saving");
        return false;
    }

    // Save the image to the selected path
    if (barcodeImg.save(cleanPath)) {
        qDebug() << "Barcode saved to:" << cleanPath;
        return true;
    } else {
        emit errorOccurred("Failed to save barcode image");
        return false;
    }
}
