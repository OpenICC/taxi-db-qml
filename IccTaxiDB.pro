TEMPLATE = app

QT += quick qml
SOURCES += main.cpp
RESOURCES += \
    IccTaxiDB.qrc
DISTFILES += \
    qml/IccTaxiDB.qml \
    qml/DeviceListView.qml \
    qml/ManufacturerListView.qml \
    qml/About.qml \
    qml/ManufacturerListView.qml

# bring browser in foreground on Android
TARGET.CAPABILITY += SwEvent

HEADERS += \
    include/iccopen.h
