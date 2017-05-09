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
    android/build.gradle \
    android/res/drawable-hdpi/icon.png \
    android/res/drawable-ldpi/icon.png \
    android/res/drawable-mdpi/icon.png \
    android/res/drawable-hdpi/icon_big.png \
    android/res/drawable-ldpi/icon_big.png \
    android/res/drawable-mdpi/icon_big.png \
    android/res/drawable-hdpi/splash.xml \
    android/res/drawable-ldpi/splash.xml \
    android/res/drawable-mdpi/splash.xml

# bring browser in foreground on Android
TARGET.CAPABILITY += SwEvent

HEADERS += \
    include/iccopen.h

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
