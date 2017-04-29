/** @file ManufacturerListView.qml
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
 * all manufacturers named in a column and selectable
 *
 */

import QtQuick 2.0

Rectangle {
    width: parent.width
    height: parent.height
    color: myPalette.window

        Component.onCompleted:{
            statusText = "Starting ..."
            load()
        }
        ListModel {  id: listModel }
        ListView {
            id:view
            anchors.bottomMargin: 0
            height: parent.height
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
                    radius: h/2
                    color: "steelblue"
                }
                Rectangle {
                    anchors.right: parent.right
                    width: 2*h
                    height: h
                    radius: (h-h/8)/3
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
                    width:  parent.width - h/4
                    anchors.top: modelD.top
                    anchors.topMargin: h/8
                    anchors.left: modelD.left
                    anchors.leftMargin: h/8
                    height: h - h/4
                    color: "lightsteelblue"
                    radius: (h-h/8)/3
                }
                Rectangle {
                    id: mnftItemBackgroundRightRect
                    width:  h
                    anchors.top: modelD.top
                    anchors.topMargin: h/8
                    anchors.right: modelD.right
                    height: h - h/4
                    color: "lightsteelblue"
                }
                Text {
                    id: mnftItemText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.topMargin: h/8
                    anchors.leftMargin: h
                    font.bold: true
                    text: "  " + long_name
                }
                MouseArea {
                    id: mnftItemMouseArea
                    anchors.fill: parent;
                    onClicked: {
                        view.currentIndex = index;
                        statusText = short_name + " : " + count
                        setPage(1)
                        mnft = short_name
                        long_mnft = long_name
                        deviceList.load()
                    }
                }
            }
        }

        function load() {
            listModel.clear();
            var xhr = new XMLHttpRequest();

            xhr.open("GET","http://icc.opensuse.org/manufacturers",true);
            xhr.onreadystatechange = function()
            {
                if ( xhr.readyState == xhr.DONE)
                {
                    if ( xhr.status == 200)
                    {
                        statusText = "down loaded"
                        var jsonObject = JSON.parse( xhr.responseText );
                        loaded(jsonObject)
                    } else
                        statusText = "HTTP Status: " + xhr.status
                }
            }
            xhr.send();
        }

        function loaded( jsonObject ) {
            jsonObject.sort(function(a, b) {
                return a.short_name.localeCompare(b.short_name)
            })

            var total = 0
            for ( var index in jsonObject ) {
                total += jsonObject[index].count
                statusText = total
            }

            var newObject = new Array
            var pos = 0
            for ( index in jsonObject ) {
                var a = String()
                var b = String()

                a = String(jsonObject[index].short_name)
                if(index > 0 && ((index-1) < jsonObject.length))
                    b = String(jsonObject[index-1].short_name)

                if(a.length && b.length && a === b) {
                    if(jsonObject[index].long_name.length > jsonObject[index-1].long_name.length) {
                        jsonObject[index].count += jsonObject[index-1].count
                        newObject[pos-1] = jsonObject[index]
                    } else
                        newObject[pos-1].count += jsonObject[index].count
                } else
                    newObject[pos++] = jsonObject[index]
            }
            newObject.sort(function(a, b) {
                return a.long_name.localeCompare(b.long_name)
            })

            for ( index in newObject )
            {
                listModel.append({
                                     "long_name" : newObject[index].long_name,
                                     "short_name" : newObject[index].short_name,
                                     "count" : newObject[index].count
                                 });
            }

            // get directly the json object. Should work but not tested
            //listModel.append();
        }
}

