// BarcodeGenerator.cpp
#include "BarcodeGenerator.h"
#include <QUrl>
#include <QImage>
#include <QStandardPaths>
#include <QDebug>
#include <zint.h>   // Zint header
#include "Symbologies.h"
#include <QDateTime>

BarcodeGenerator::BarcodeGenerator(QObject *parent) : QObject(parent) {}

QStringList BarcodeGenerator::getSymbologyNames() {
    QMap<QString,int> symbologies = getZintSymbologies();
    return symbologies.keys();
}

int BarcodeGenerator::getSymbologyCode(const QString &name) {
    QMap<QString,int> symbologies = getZintSymbologies();
    return symbologies.value(name, 58); // Default to QR Code if not found
}

QString BarcodeGenerator::generate(const QString &text, int symbology) {
    struct zint_symbol *symbol = ZBarcode_Create();
    if (!symbol) {
        qDebug() << "Failed to create ZBarcode symbol";
        return "Error: Failed to create barcode symbol";
    }

    symbol->symbology = symbology;
    symbol->scale = 2.0;
    symbol->show_hrt = 1;

    QByteArray utf8 = text.toUtf8();
    int result = ZBarcode_Encode(symbol, reinterpret_cast<const unsigned char*>(utf8.data()), utf8.size());

    // Check for errors right after encoding
    if (result != 0) {
        QString errorMsg = QString(symbol->errtxt);
        qDebug() << "ZBarcode encoding failed:" << errorMsg;
        ZBarcode_Delete(symbol);
        return "Error: " + errorMsg; // Return the specific error message
    }

    result = ZBarcode_Buffer(symbol, 0);
    if (result != 0) {
        qDebug() << "ZBarcode buffer creation failed:" << symbol->errtxt;
        ZBarcode_Delete(symbol);
        return "Error: " + QString(symbol->errtxt); // Return the specific error message
    }

    QImage img(symbol->bitmap_width, symbol->bitmap_height, QImage::Format_RGB32);
    img.fill(Qt::white);

    unsigned char *bitmap = symbol->bitmap;
    for (int y = 0; y < symbol->bitmap_height; ++y) {
        for (int x = 0; x < symbol->bitmap_width; ++x) {
            int pixel = bitmap[y * symbol->bitmap_width + x];
            img.setPixel(x, y, pixel ? qRgb(0, 0, 0) : qRgb(255, 255, 255));
        }
    }

    QString timestamp = QDateTime::currentDateTime().toString("yyyyMMdd_HHmmss");
    QString path = QStandardPaths::writableLocation(QStandardPaths::TempLocation) + QString("/barcode_%1.png").arg(timestamp);
    bool saved = img.save(path);

    ZBarcode_Delete(symbol);

    if (!saved) {
        qDebug() << "Failed to save barcode image to:" << path;
        return "Error: Failed to save barcode image"; // Return a generic save error
    }

    return QUrl::fromLocalFile(path).toString(); // Return the file URL as a string
}
