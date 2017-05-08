/** @file main.cpp
 *
 *  OpenICC Taxi DB is a color profile DB browser.
 *
 *  @par Copyright:
 *            2015 (C) Kai-Uwe Behrmann
 *            All Rights reserved.
 *
 *  @par License:
 *            AGPL-3.0 <https://opensource.org/licenses/AGPL-3.0>
 *  @since    2015/10/22
 *
 *  basic QML handling and environment setup
 */

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
    app.setApplicationVersion("1.0.0");
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
