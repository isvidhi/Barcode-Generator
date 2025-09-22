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

    int symbologyCode = m_generator->getSymbologyCode(symbologyName);

    // Call the BarcodeGenerator's function, which now returns a QImage
    QImage barcodeImg = m_generator->generate(text, symbologyCode);

    if (size) {
        *size = barcodeImg.size();
    }

    return barcodeImg;
}
