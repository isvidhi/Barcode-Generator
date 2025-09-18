// BarcodeGenerator.h
#pragma once
#include <QObject>
#include <QImage>
#include <QString>
#include <QStandardPaths>
#include <QUrl>

class BarcodeGenerator : public QObject {
    Q_OBJECT
public:
    explicit BarcodeGenerator(QObject *parent = nullptr);

    Q_INVOKABLE QUrl generate(const QString &text, int symbology = 10);

};
