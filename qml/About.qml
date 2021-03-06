/** @file About.qml
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
 *  About info page
 */

import QtQuick 2.4
import QtQuick.Controls 1.3

Rectangle {
    id: aboutRectangle
    width: parent.width
    height: parent.height
    anchors.centerIn: parent

    color: myPalette.window
    implicitHeight: parent.height
    implicitWidth: parent.width

    Image {
        id: logoImage
        width: parent.width
        y: 10
        horizontalAlignment: Image.AlignHCenter
        fillMode: Image.PreserveAspectFit
        source: (Qt.platform.os === "android") ? "qrc:/extras/images/logo.png" : "qrc:/extras/images/logo-color-src.svg"
        sourceSize.width: 350
        sourceSize.height: 350
        height: 175
    }

    TextArea { // our content
        id: textArea
        y: logoImage.height + logoImage.y + 10
        width: parent.width
        height: parent.height - logoImage.height - font.pixelSize * 3 // keep some space for the button

        Accessible.name: "about text"
        backgroundVisible: false // keep the area visually simple
        frameVisible: false      // keep the area visually simple

        textFormat: Qt.RichText // Html
        textMargin: font.pixelSize
        readOnly: true // obviously no edits
        text: "<html><head></head><body> <p align=\"center\">OpenICC Taxi DB Viewer<br \>Version " + ApplicationVersion + "<br \>" +
                      qsTr("Taxi ICC Device Color Profile Database Viewer") +
                      "<br \>Copyright (c) 2015-2017 Kai-Uwe Behrmann<br \>" +
                      qsTr("All Rights reserved.") +
                      "<br \><a href=\"http://www.behrmann.name\">www.behrmann.name</a>" +
                      "<br \><a href=\"https://github.com/OpenICC/taxi-db-qml\">Sources: github.com</a></p></body></html>"
        onLinkActivated: {
            Qt.openUrlExternally(link)
            //QDesktopServices:openUrl(link)
            statusText = "opening adress externally"
        }
        onLinkHovered: (Qt.platform.os === "android") ? Qt.openUrlExternally(link) : statusText = link

    }

    Action {
        id: aboutcloseAction
        text: qsTr("OK")
        shortcut: "Esc"
        onTriggered:  setPage(0)
    }

    Button { // finish button
        text: qsTr("OK")
        width: parent.width - textArea.font.pixelSize * 2 // make this button big
        x: aboutRectangle.width/2 - width/2 // place in the middle
        y: aboutRectangle.height - textArea.font.pixelSize * 3 // place below aboutTextArea
        action: aboutcloseAction
    }
}

