#pragma once
#include <QObject>
#include <QImage>
#include <QString>
#include <QStringList>
#include <QStandardPaths>
#include <QUrl>
#include <QMap>
#include <opencv2/opencv.hpp>

class BarcodeGenerator : public QObject
{
    Q_OBJECT
public:
    explicit BarcodeGenerator(QObject *parent = nullptr);

    Q_INVOKABLE QStringList getSymbologyNames();
    Q_INVOKABLE int getSymbologyCode(const QString &name);
    Q_INVOKABLE QImage generate(const QString &text, int symbology);

signals:
    void errorOccurred(const QString& errorMessage);
};
