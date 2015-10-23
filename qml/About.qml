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

    TextArea { // our content
        id: textArea
        //anchors.centerIn: parent
        width: parent.width
        height: parent.height - font.pixelSize * 3 // keep some space for the button

        Accessible.name: "about text"
        backgroundVisible: false // keep the area visually simple
        frameVisible: false      // keep the area visually simple

        textFormat: Qt.RichText // Html
        textMargin: font.pixelSize
        readOnly: true // obviously no edits
        text: "<html><head></head><body> <p align=\"center\">OpenICC Taxi DB Viewer<br \>Version " + ApplicationVersion + "<br \>" +
                      qsTr("Taxi ICC Device Color Profile Database Viewer") +
                      "<br \>Copyright (c) 2015 Kai-Uwe Behrmann<br \>" +
                      qsTr("All Rights reserved.") +
                      "<br \><a href=\"http://www.behrmann.name\">www.behrmann.name</p></body></html>"
        onLinkActivated: {
            Qt.openUrlExternally(link)
            //QDesktopServices:openUrl(link)
            statusText = "opening adress externally"
        }
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

