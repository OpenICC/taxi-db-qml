#include <QtGui/QGuiApplication>
#include <QtGui/QScreen>
#include <QtQml> // qmlRegisterType<>()
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlComponent>
#include <QtQml/QQmlContext>
#include <QtQuick/QQuickWindow>
#include <QtCore/QUrl>
#include <QDebug>
#include "include/iccopen.h"

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName(QString("OpenICC Taxi DB Viewer"));
    app.setApplicationDisplayName(QString("ICC Taxi DB"));
    app.setApplicationVersion("0.0.3");
    app.setOrganizationName(QString("oyranos.com"));

    foreach (QScreen * screen, QGuiApplication::screens())
        screen->setOrientationUpdateMask(Qt::LandscapeOrientation | Qt::PortraitOrientation |
                                         Qt::InvertedLandscapeOrientation | Qt::InvertedPortraitOrientation);

    qmlRegisterType<IccOpen>("IccOpen", 1, 0, "IccOpen");

    QQmlEngine engine;
    QQmlComponent component(&engine);
    QQuickWindow::setDefaultAlphaBuffer(true);
    component.loadUrl(QUrl("qrc:///qml/IccTaxiDB.qml"));
    if ( component.isReady() )
        component.create();
    else
        qWarning() << component.errorString();

    QQmlContext *ctxt = engine.rootContext();
    ctxt->setContextProperty("ApplicationVersion", QVariant::fromValue( app.applicationVersion() ));

    return app.exec();
}
