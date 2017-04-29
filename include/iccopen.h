/** @file iccopen.h
 *
 *  OpenICC Taxi DB is a color profile DB browser.
 *
 *  @par Copyright:
 *            2015 (C) Kai-Uwe Behrmann
 *            All Rights reserved.
 *
 *  @par License:
 *            AGPL-3.0 <https://opensource.org/licenses/AGPL-3.0>
 *  @since    2015/10/30
 *
 *  profile load and C++ <-> QML wrappers
 */


#ifndef ICCOPEN_H
#define ICCOPEN_H

#include <QObject>
#include <QDesktopServices>
#include <QUrl>

class IccOpen : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString fileName
               READ fileName
               WRITE setFileName
               NOTIFY fileNameChanged
               REVISION 1)
public:
    IccOpen(QObject * parent = 0) : QObject(parent) { }

    QString fileName() {
        return m_file_name;
    }
    void setFileName( QString fn ) {
        m_file_name = fn;

        // test for http Uri
        QUrl url;
        url.setUrl( m_file_name );
        QDesktopServices::openUrl( url );

        emit fileNameChanged();
    }

signals:
    void fileNameChanged();
private:
    QString m_file_name;
};

#endif // ICCOPEN_H

