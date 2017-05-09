/** @file ProfileView.qml
 *
 *  OpenICC Taxi DB is a viewer for the online ICC monitor profile DB
 *  http://icc.opensuse.org
 *
 *  @par Copyright:
 *            2015 (C) Kai-Uwe Behrmann
 *            All Rights reserved.
 *
 *  @par License:
 *            AGPL-3.0 <https://opensource.org/licenses/AGPL-3.0>
 *  @since    2015/10/22
 *
 * -----------------------------------------------------------------------------
 *
 * the selected device meta data, with some graphics and a link to
 * the actual ICC profile
 *
 */

import QtQuick 2.0
import QtQuick.Controls 1.3

Rectangle {
    width: parent.width
    height: parent.height
    color: "transparent"

    property int repaint: 0
    onRepaintChanged: canvas.requestPaint()
    property string html

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
        text: html
        onLinkActivated: {
            setBusyTimer.start()
            if(Qt.openUrlExternally(link))
                statusText = "Launched app for " + link
            else
                statusText = "Launching external app failed"
            unsetBusyTimer.start()
        }
        onLinkHovered: if(Qt.platform.os != "android") statusText = link
    }

    property bool showJson: false
    function parseMyJson( json ) {
        html =
            long_mnft + " : " + device_name + "<br />
            <small><a href=\"http://icc.opensuse.org/profile/" + profile_id + "/0/profile.icc\" type=\"vnd/iccprofile\">
            http://icc.opensuse.org/profile/" + profile_id + "/0/profile.icc</a><br /><div style='color: black; font-style: italic'>"

        if(showJson)
        for (var obj in json) {
            html += obj + ": " + json[obj] + "<br/>"
        }
        html += "</div></small>"
    }
    property int tm: textArea.font.pixelSize * 3 // top margin
    property int sm: textArea.font.pixelSize // side margin
    property int head: if(textArea.font.pixelSize * 12 > canvas.height) tm; else 2*tm
    property int d: Math.min( canvas.width - tm-2*sm, canvas.height - head-2*sm )
    property int diag_top: canvas.height - head -2*sm - d
    Canvas {
        id: canvas
        width: parent.width
        height: parent.height - textArea.font.pixelSize * 3
        property color strokeStyle:  Qt.darker(fillStyle, 1.4)
        property color fillStyle: "#b4b4b4" // gray

        property real lineWidth: textArea.font.pixelSize / 5.0
        antialiasing: true

        onPaint: {
            var ctx = canvas.getContext('2d')
            ctx.save()
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.strokeStyle = canvas.strokeStyle
            ctx.fillStyle = canvas.fillStyle
            ctx.lineWidth = lineWidth/2.0
            ctx.translate( tm+sm/2, height-d-3*sm/2 )
            ctx.globalAlpha = 0.3

            //! triangle begin
            ctx.beginPath()
            ctx.moveTo(0,0)
            ctx.lineTo(0,d)
            ctx.lineTo(d,d)
            ctx.lineTo(0,0)
            ctx.closePath()
            //! triangle end
            if(showJson === false)
                ctx.globalAlpha = 1
            ctx.stroke()

            //! EDID triangle begin
            ctx.lineWidth = lineWidth
            ctx.beginPath()
            ctx.moveTo( red_x*d, d-red_y*d )
            ctx.lineTo( green_x*d, d-green_y*d )
            ctx.lineTo( blue_x*d, d-blue_y*d )
            ctx.closePath()
            //! EDID triangle end

            ctx.globalAlpha = 0.3
            ctx.fill()
            ctx.strokeStyle = "black"
            if(showJson === false)
                ctx.globalAlpha = 1
            else
                ctx.globalAlpha = 0.5
            ctx.stroke()

            ctx.font = textArea.font.pixelSize + 'px sans-serif vertical-lr'
            if(showJson === false)
                ctx.fillStyle = "black"
            ctx.fillText( "CIE*x", d-tm, d+sm )
            ctx.fillText( "CIE*y", sm/4-tm, sm )

            ctx.restore()

            parseMyJson( profileJsonObject )
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
    Button { // view button
        id: viewButton
        text: qsTr("Open")
        width: parent.width - textArea.font.pixelSize * 2 - jsonButton.width // make this button big
        x: (parent.width - width)/2 - jsonButton.width/2
        y: parent.height - textArea.font.pixelSize * 3 // place below aboutTextArea
        action: openIccAction
    }
    Button { // JSON button
        id: jsonButton
        text: showJson ? qsTr("Show Less") : qsTr("Show More")
        width: textArea.font.pixelSize * 9 // make this button big
        anchors.left: viewButton.right
        anchors.top: viewButton.top
        onClicked: {
            showJson = !showJson
            canvas.requestPaint()
        }
    }
}

