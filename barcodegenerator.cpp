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

    result = ZBarcode_Buffer(symbol,0);
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

    // if (!img.isNull()) {
    //     // Convert QImage to OpenCV Mat
    //     cv::Mat matImage(
    //         img.height(),
    //         img.width(),
    //         CV_8UC4, // Use 8-bit, 4-channel for ARGB32
    //         (uchar*)img.bits(),
    //         img.bytesPerLine()
    //         );

    //     // Convert from ARGB to BGR format which is standard for OpenCV
    //     cv::Mat bgrImage;
    //     cv::cvtColor(matImage, bgrImage, cv::COLOR_BGRA2BGR);

    //     // Display the image in a window
    //     cv::imshow("Barcode Debug", bgrImage);
    //     cv::waitKey(0); // Wait for a key press to close the window
    // }
    // --- END OF NEW DEBUGGING CODE ---

    ZBarcode_Delete(symbol);
    return img;
}
