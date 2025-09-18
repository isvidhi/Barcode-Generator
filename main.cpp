#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "BarcodeGenerator.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    BarcodeGenerator generator;
    engine.rootContext()->setContextProperty("barcodeGen", &generator);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("BarcodeGenerator", "Main");

    return app.exec();
}
