// BarcodeGenerator.cpp
#include "BarcodeGenerator.h"
#include <qurl.h>
#include <zint.h>   // Zint header

BarcodeGenerator::BarcodeGenerator(QObject *parent) : QObject(parent) {}

QUrl BarcodeGenerator::generate(const QString &text, int symbology) {
    struct zint_symbol *symbol = ZBarcode_Create();
    symbol->symbology = symbology;
    symbol->scale = 2.0;
    symbol->show_hrt = 0;

    QByteArray utf8 = text.toUtf8();
    ZBarcode_Encode(symbol, reinterpret_cast<const unsigned char*>(utf8.data()), utf8.size());
    ZBarcode_Buffer(symbol, 0);

    QImage img(symbol->bitmap_width, symbol->bitmap_height, QImage::Format_RGB32);
    img.fill(Qt::white);

    unsigned char *bitmap = symbol->bitmap;
    for (int y = 0; y < symbol->bitmap_height; ++y) {
        for (int x = 0; x < symbol->bitmap_width; ++x) {
            int pixel = bitmap[y * symbol->bitmap_width + x];
            img.setPixel(x, y, pixel ? qRgb(0, 0, 0) : qRgb(255, 255, 255));
        }
    }

    // Save to temporary file
    QString path = QStandardPaths::writableLocation(QStandardPaths::TempLocation) + "/barcode.png";
    img.save(path);

    ZBarcode_Delete(symbol);
    return QUrl::fromLocalFile(path);
}
