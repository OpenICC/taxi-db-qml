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
    qml/ManufacturerListView.qml \
    qml/ProfileView.qml \
    android/AndroidManifest.xml \
    android/res/values/libs.xml \
    android/build.gradle

# bring browser in foreground on Android
TARGET.CAPABILITY += SwEvent

HEADERS += \
    include/iccopen.h

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
