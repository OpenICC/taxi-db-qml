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
            snapMode: ListView.SnapOneItem
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
                        statusText = device_model
                        profile_id = oid
                        setPage(2)
                    }
                }
            }
        }

        function load() {
            listModel.clear();
            var xhr = new XMLHttpRequest();

            xhr.open("GET","http://icc.opensuse.org/devices/" + mnft,true);
            //xhr.open("GET", "http://localhost:5000/manufacturers", true);
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
                                     "red_x" : jsonObject[index].EDID_red_x,
                                     "red_y" : jsonObject[index].EDID_red_y,
                                     "green_x" : jsonObject[index].EDID_green_x,
                                     "green_y" : jsonObject[index].EDID_green_y,
                                     "blue_x" : jsonObject[index].EDID_blue_x,
                                     "blue_y" : jsonObject[index].EDID_blue_y,
                                     "white_x" : jsonObject[index].EDID_white_x,
                                     "white_y" : jsonObject[index].EDID_white_y
                                 });
            }
        }
}

