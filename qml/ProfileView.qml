import QtQuick 2.0
import QtQuick.Controls 1.3

Rectangle {
    width: parent.width
    height: parent.height
    color: "transparent"

    TextArea { // our content
        id: textArea
        width: parent.width
        height: parent.height - font.pixelSize * 3 // keep some space for the button

        Accessible.name: "profile link"
        backgroundVisible: false // keep the area visually simple
        frameVisible: false      // keep the area visually simple

        textFormat: Qt.RichText // Html
        textMargin: font.pixelSize
        readOnly: true // obviously no edits
        text: "<a href=\"http://icc.opensuse.org/profile/" + profile_id + "/0/profile.icc\" type=\"vnd/iccprofile\">http://icc.opensuse.org/profile/" + profile_id + "/0/profile.icc</a>"
        onLinkActivated: {
            setBusyTimer.start()
            if(Qt.openUrlExternally(link))
                statusText = "Launched app for " + link
            else
                statusText = "Launching external app failed"
            //QDesktopServices:openUrl(link) is not defined
            unsetBusyTimer.start()
        }
    }

    Canvas {
        id:canvas
        width: parent.width
        height: parent.height - textArea.font.pixelSize * 3
        property color strokeStyle:  Qt.darker(fillStyle, 1.4)
        property color fillStyle: "#b4b4b4" // gray

        property int tm: textArea.font.pixelSize * 3 // top margin
        property int sm: textArea.font.pixelSize // side margin
        property int d: Math.min( width - sm, height - tm )
        property int lineWidth: textArea.font.pixelSize / 4
        antialiasing: true

        onPaint: {
            var ctx = canvas.getContext('2d')
            ctx.save()
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.strokeStyle = canvas.strokeStyle
            ctx.fillStyle = canvas.fillStyle
            ctx.lineWidth = lineWidth
            ctx.globalAlpha = 0.7

            //! triangle begin
            ctx.beginPath()
            ctx.moveTo(sm,tm)
            ctx.lineTo(sm,d)
            ctx.lineTo(d,d)
            ctx.lineTo(sm,tm)
            ctx.closePath()
            //! triangle end
            ctx.fill()
            ctx.stroke()
            ctx.restore()
        }
    }

    Action {
        id: openIccAction
        text: qsTr("View")
        shortcut: "Enter"
        onTriggered: {
            profile.fileName = "http://icc.opensuse.org/profile/" + profile_id + "/0/profile.icc"
            statusText = "opening " + profile.fileName
        }
    }
    Button { // finish button
        text: qsTr("View")
        width: parent.width - textArea.font.pixelSize * 2 // make this button big
        x: parent.width/2 - width/2 // place in the middle
        y: parent.height - textArea.font.pixelSize * 3 // place below aboutTextArea
        action: openIccAction
    }
}

