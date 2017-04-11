/*
 * OpenICC Taxi DB is a viewer for the online ICC monitor profile DB
 * http://icc.opensuse.org
 * 
 * Copyright (C) 2015  Kai-Uwe Behrmann 
 *
 * Autor: Kai-Uwe Behrmann <ku.b@gmx.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 * -----------------------------------------------------------------------------
 *
 * the device list tab
 * 
 */

import QtQuick 2.0

Rectangle {
    width: parent.width
    height: parent.height
    color: myPalette.window

        // highlight from mnft page
        Rectangle {
            id: mnftRect
            width: parent.width
            height: h
            color: "lightsteelblue"
        }

        Text {
            anchors.verticalCenter: mnftRect.verticalCenter
            anchors.topMargin: h/8
            anchors.leftMargin: h
            font.bold: true
            text: "  " + long_mnft
        }

        MouseArea {
            id: backMouseArea
            width: parent.width
            height: h
            onClicked: {
                if(pages.ListView.isCurrentItem)
                    pagesItem = -1
                setPage(0)
            }
        }

        ListModel {  id: listModel }
        ListView {
            id:view
            anchors.bottomMargin: 0
            anchors.top: mnftRect.bottom
            height: parent.height - h
            width: parent.width
            snapMode: ListView.SnapToItem
            highlightRangeMode: ListView.ApplyRange
            highlightMoveDuration: 250
            keyNavigationWraps: true
            focus: true
            clip: true

            highlight: Item {
                Rectangle {
                    width: parent.width
                    height: h
                    color: "steelblue"
                }
            }
            model: listModel
            delegate: Rectangle {
                id: modelD
                width:  parent.width
                height: h
                color: "transparent"


                Rectangle {
                    id: mnftItemBackgroundRect
                    width:  parent.width //- h/4
                    anchors.top: modelD.top
                    anchors.topMargin: h/8
                    anchors.left: modelD.left
                    height: h - h/4
                    color: "lightsteelblue"
                }
                Text {
                    id: mnftItemText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.topMargin: h/8
                    anchors.leftMargin: h
                    //font.bold: true
                    textFormat: Qt.RichText // Html
                    text: "  <b>" + device_model + "</b> " + profile_description.replace(device_model,"") + " <i>" + GAMUT_volume + "</i>"
                }

                MouseArea {
                    id: mnftItemMouseArea
                    anchors.fill: parent;
                    onClicked: {
                        view.currentIndex = index
                        statusText = " <b>" + device_model + "</b> " + profile_description.replace(device_model,"") + " <i>" + GAMUT_volume + "</i>"
                        profile_id = oid
                        device_name = device_model
                        measurement_device = MEASUREMENT_device
                        gamut_volume = GAMUT_volume
                        red_x = redX
                        red_y = redY
                        green_x = greenX
                        green_y = greenY
                        blue_x = blueX
                        blue_y = blueY
                        white_x = whiteX
                        white_y = whiteY
                        profileJsonObject = jsonObject
                        setPage(2)
                    }
                }
            }
        }

        function load() {
            listModel.clear();
            var xhr = new XMLHttpRequest();

            xhr.open("GET","http://icc.opensuse.org/devices/" + mnft,true)
            xhr.onreadystatechange = function()
            {
                if ( xhr.readyState == xhr.DONE)
                {
                    if ( xhr.status == 200)
                    {
                        statusText = "down loaded"
                        var jsonObject = JSON.parse( xhr.responseText )
                        loaded(jsonObject)
                    } else
                        statusText = "HTTP Status: " + xhr.status
                }
            }
            xhr.send();
        }

        function loaded( jsonObject ) {
            jsonObject.sort(function(a, b) {
                var a_ = String(a.model)
                var b_ = String(b.model)
                if(a_.length && b_.length)
                    return a_.localeCompare(b_)
                else
                    return 0
            })

            var total = 0
            for ( var index in jsonObject ) {
                ++total
                statusText = total
            }

            for ( index in jsonObject )
            {
                listModel.append({
                                     "device_model" : jsonObject[index].model,
                                     "profile_description" : jsonObject[index].profile_description[0],
                                     "GAMUT_volume" : jsonObject[index].GAMUT_volume,
                                     "MEASUREMENT_device" : jsonObject[index].MEASUREMENT_device,
                                     "oid" : jsonObject[index]._id.$oid,
                                     "redX" : jsonObject[index].EDID_red_x,
                                     "redY" : jsonObject[index].EDID_red_y,
                                     "greenX" : jsonObject[index].EDID_green_x,
                                     "greenY" : jsonObject[index].EDID_green_y,
                                     "blueX" : jsonObject[index].EDID_blue_x,
                                     "blueY" : jsonObject[index].EDID_blue_y,
                                     "whiteX" : jsonObject[index].EDID_white_x,
                                     "whiteY" : jsonObject[index].EDID_white_y,
                                     "jsonObject" : jsonObject[index]
                                 });
            }
        }
}

