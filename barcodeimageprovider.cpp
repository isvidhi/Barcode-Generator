#include "BarcodeImageProvider.h"
#include <QDebug>
#include <QImage>

BarcodeImageProvider::BarcodeImageProvider(BarcodeGenerator* generator)
    : QQuickImageProvider(QQuickImageProvider::Image), m_generator(generator)
{
}

QImage BarcodeImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QStringList parts = id.split('/');
    if (parts.size() < 2) {
        qDebug() << "Invalid image request ID:" << id;
        m_generator->errorOccurred("Invalid image request. Please check input parameters.");
        return QImage();
    }

    QString text = parts.at(0);
    QString symbologyName = parts.at(1);
    int rotation = 0;
    int showHrt = 0;
    int height = 50;
    int width = 0;

    if (parts.size() >= 3) {
        rotation = parts.at(2).toInt();
    }
    if (parts.size() >= 4) {
        showHrt = parts.at(3).toInt();
    }
    if (parts.size() >= 5) {
        height = parts.at(4).toInt();
    }
    if (parts.size() >= 6) {
        width = parts.at(5).toInt();
    }

    int symbologyCode = m_generator->getSymbologyCode(symbologyName);
    QImage barcodeImg = m_generator->generate(text, symbologyCode, rotation, showHrt, height, width);

    if (size) {
        *size = barcodeImg.size();
    }

    return barcodeImg;
}
