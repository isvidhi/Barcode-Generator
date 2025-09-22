#ifndef BARCODEIMAGEPROVIDER_H
#define BARCODEIMAGEPROVIDER_H

#include <QObject>
#include <QQuickImageProvider>
#include "BarcodeGenerator.h"

class BarcodeImageProvider : public QQuickImageProvider
{
    Q_OBJECT
public:
    BarcodeImageProvider(BarcodeGenerator* generator);
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);

private:
    BarcodeGenerator* m_generator;
};

#endif // BARCODEIMAGEPROVIDER_H
