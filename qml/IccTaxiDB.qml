import QtQuick 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2
import IccOpen 1.0

ApplicationWindow {
    id:root
    width: 360
    height: 600
    visible: true

    property string title: "Liste"
    readonly property int dens: Math.round(Screen.logicalPixelDensity)
    SystemPalette { id: myPalette; colorGroup: SystemPalette.Active }
    property int h: mainStatusBar.height*1.5

    property int pagesIndex: 0
    function setPage(page)
    {
        setBusyTimer.start()
        //statusText = "page: " + page + " "  + pagesIndex + " " + pages.currentIndex

        if(pagesIndex === page)
            pagesIndex = -1 // delesect list item to get properly back
        pagesIndex = page

        unsetBusyTimer.start()
    }

    ListView {
        id: pages

        width: parent.width
        height: parent.height

        model: pagesModel
        currentIndex: pagesIndex
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        flickDeceleration: 2000

        highlightFollowsCurrentItem: true
        highlightMoveDuration: 500
        //interactive: false
    }

    //property string pageTwoText: "Page 2"
    property string mnft
    property string long_mnft
    property string profile_id
    VisualItemModel {
        id: pagesModel

        Rectangle {
            width: pages.width
            height: pages.height
            id: textPage

            ManufacturerListView {}
        }
        Rectangle {
            width: pages.width
            height: pages.height
            id: twoPage
            color: "transparent"

            DeviceListView {
                id: deviceList
            }
        }
        Rectangle {
            width: pages.width
            height: pages.height
            color: "transparent"
            ProfileView {}
        }


        Rectangle {
            id: aboutPage
            width: pages.width
            height: pages.height
            About {}
        }
    }


    Action {
        id: copyAction
        text: qsTr("Copy")
        shortcut: "Ctrl+C"
        //iconSource: "qrc:/images/" + dpiName + "/ic_action_copy.png"
        iconName: "edit-copy"
        enabled: (!!activeFocusItem && !!activeFocusItem["copy"])
        onTriggered: activeFocusItem.copy()
    }
    Action {
        id: pasteAction
        text: qsTr("Paste")
        shortcut: "ctrl+v"
        //iconSource: "qrc:/images/" + dpiName + "/ic_action_paste.png"
        iconName: "edit-paste"
        enabled: (!!activeFocusItem && !!activeFocusItem["paste"])
        onTriggered: activeFocusItem.paste()
    }
    Action {
        id: helpAction
        text: qsTr("About...")
        shortcut: "F1"
        //iconSource: "qrc:/images/" + dpiName + "/ic_action_about.png"
        iconName: "about"
        onTriggered: setPage(3)
    }
    Action {
        id: quitAction
        text: qsTr("Quit")
        shortcut: "Ctrl+q"
        onTriggered: {
            statusText = qsTr("Quit")
            root.close()
        }
    }

    menuBar: MenuBar {
        Menu {
            //iconSource: "qrc:/images/" + dpiName + "/ic_action_menu.png"
            title: qsTr("&Edit ...")
            MenuItem { action: copyAction }
            MenuItem { action: pasteAction }
            MenuItem { action: helpAction }
            MenuItem { action: quitAction }
        }
    }

    toolBar: ToolBar {
        implicitWidth: root.width

        Rectangle {
            id: banner
            anchors.fill: parent
            color: "transparent"

            Text {
                id: bannerLeftText
                width: parent.width/2
                height: parent.height/2

                anchors.right: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: "steelblue"
                fontSizeMode: Text.Fit // does no effect
                horizontalAlignment: Text.AlignRight
                font.bold: true
                text: "<font size=\"5\">OpenICC </font>"
            }
            Text {
                id: bannerRightText
                anchors.left: bannerLeftText.right
                anchors.top: bannerLeftText.top
                anchors.verticalCenter: parent.verticalCenter
                color: "#000000"
                font.bold: true
                text: "<font size=\"5\"> Taxi DB</font>"
            }

            MouseArea {
                anchors.fill: banner
                onClicked: setPage(0)
            }
        }
    }

    // Take busy out of non UI function
    Timer {
        id: setBusyTimer
        triggeredOnStart: false
        interval: 0
        onTriggered: {
            if(isbusy === false)
            {
                statusLabel.text = qsTr("Busy")
                isbusy = true
            }
        }
    }
    Timer {
        id: unsetBusyTimer
        triggeredOnStart: false
        interval: 200
        onTriggered: {
            if(isbusy === true)
            {
                isbusy = false
                if(statusText.length)
                    statusLabel.text = statusText
            }
        }
    }

    property string statusText: "Running..."
    statusBar: RowLayout {
            id: mainStatusBar
            anchors.fill: parent
            Label {
                id: statusLabel
                text: statusText
            }
    }
    property bool isbusy: false
    BusyIndicator {
       id: busy
       anchors.centerIn: parent
       running: isbusy
       opacity: 0.85
       Layout.alignment: Qt.AlignLeft
    }

    IccOpen {
        id: profile
        onFileNameChanged: {
            statusText = qsTr("Loaded") + " " + profile.fileName
        }
    }
}

