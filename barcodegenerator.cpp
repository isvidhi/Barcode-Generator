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

QImage BarcodeGenerator::generate(const QString &text, int symbology) {
    struct zint_symbol *symbol = ZBarcode_Create();
    if (!symbol) {
        emit errorOccurred("Failed to create ZBarcode symbol");
        return QImage();
    }

    symbol->symbology = symbology;
    symbol->scale = 2.0;
    symbol->show_hrt = 1;

    QByteArray utf8 = text.toUtf8();
    int result = ZBarcode_Encode(symbol, reinterpret_cast<const unsigned char*>(utf8.data()), utf8.size());

    if (result != 0) {
        QString errorMsg = QString(symbol->errtxt);
        emit errorOccurred("Error: " + errorMsg);
        ZBarcode_Delete(symbol);
        return QImage();
    }

    result = ZBarcode_Buffer(symbol, 0);
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
            int pixel = bitmap[y * symbol->bitmap_width + x];
            img.setPixel(x, y, pixel ? qRgb(0, 0, 0) : qRgb(255, 255, 255));
        }
    }

    ZBarcode_Delete(symbol);
    return img;
}
