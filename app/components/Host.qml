import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
     anchors {
        top: parent.top
        left:parent.left
        right:parent.right
        bottom:parent.bottom
    }

    Column {
        id:settingsColumn
        enabled:!launcher.active
        anchors {
            top: parent.top
            left:parent.left
            right:parent.right
            topMargin: units.gu(5)
        }
        height:units.gu(15)
        spacing: units.gu(3)

                CheckBox {
                    id:autoconfig
                    checked: mircastSettings.autoHostConfig
                    onValueChanged: {
                        mircastSettings.autoHostConfig = checked;
                    }
                }

        Row {
            id:connectionSettingssRow
            anchors {
                horizontalCenter: parent.horizontalCenter
                topMargin: units.gu(2)
            }
            width:parent.width
            spacing: units.gu(3)
			enabled: !mircastSettings.autoHostConfig

            TextField {
                id: portNumber
                visible:false
                objectName: "portNumber"
                placeholderText: i18n.tr("Remote port number")
                text:"12345"
            }
//             Column {
//                 Label {
//                     id:compressionLabel
//                     text: i18n.tr("Compression") + ":"
//                 }
//                 CheckBox {
//                     id:compression
//                     checked: mircastSettings.compression != 0
//                     onValueChanged: {
//                         mircastSettings.compression = launcher.compression = checked;
//                     }
//                 }
//             }
        }
        Row {
            id:screenSettingsRow

            anchors {
                horizontalCenter: parent.horizontalCenter
                topMargin: units.gu(2)
            }
            width:parent.width
            spacing: units.gu(3)

// 			ToolTip {
// 				id: toolTip
// 				text: i18n.tr("Force the display window to a certain height and request the casting device to resize to this width\nIf this is left blank the width will be determined by the casting  device.")
// 				target: screenHeight
// 				visible: mouseArea.pressed
// 			}
			
            TextField {
                id: screenWidth
                width:parent.width/2 - parent.spacing
                objectName: "screenWidth"
                placeholderText: i18n.tr("Override Width")
                text:mircastSettings.screenWidth

            }
			
// 			ToolTip {
// 				id: toolTip
// 				text: i18n.tr("Force the display window to a certain height and request the casting device to resize to this height\nIf this is left blank the  height will be determined by the casting  device.")
// 				target: screenHeight
// 				visible: mouseArea.pressed
// 			}

            TextField {
                id: screenHeight
                width:parent.width/2- parent.spacing
                objectName: "screenHeight"
                placeholderText: i18n.tr("Override Height")
                text:mircastSettings.screenHeight
            }
        }
    }
    Button {
        id:castButton
        objectName: "button"
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom:parent.bottom
            margins: units.gu(1)
        }
        width: parent.width
        height:units.gu(5)
        enabled: !launcher.active
        text: launcher.active ? i18n.tr("Stop Hosting") :i18n.tr("Wait for cast")

        onClicked: {
            if(launcher.active) {
                launcher.stop();
            } else {
                launcher.width = screenWidth.text;
                launcher.height = screenHeight.text;
                launcher.host();
            }
        }
    }

}

