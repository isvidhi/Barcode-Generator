#pragma once
#include <QObject>
#include <QImage>
#include <QString>
#include <QStringList>
#include <QStandardPaths>
#include <QUrl> // Keep QUrl for local file path creation
#include <QMap>

class BarcodeGenerator : public QObject
{
    Q_OBJECT
public:
    explicit BarcodeGenerator(QObject *parent = nullptr);

    Q_INVOKABLE QStringList getSymbologyNames();
    Q_INVOKABLE int getSymbologyCode(const QString &name);
    Q_INVOKABLE QString generate(const QString &text, int symbology);
};
