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

