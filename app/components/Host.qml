import QtQuick 2.4
import Ubuntu.Components 1.3

Flickable {
	id:hostPage

     anchors {
        top: parent.top
        left:parent.left
        right:parent.right
        bottom:parent.bottom
    }
    enabled: launcher.canHost
    interactive:true

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
                    enabled: true //TODO add check against negosiator state
                    checked: mircastSettings.autoHostConfig
                    onCheckedChanged: {
                        mircastSettings.autoHostConfig = checked;
                    }
                    text:i18n.tr("Auto Configure")
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
				visible:true
				objectName: "portNumber"
				placeholderText: i18n.tr("Remote port number")
				text:"12345"
			}
			CheckBox {
				id:compression
				checked: mircastSettings.compression != 0
				text:i18n.tr("Compression")
				onCheckedChanged: {
					mircastSettings.compression = launcher.compression = checked ? 9 : 0;
				}
			}
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
        color: !launcher.active ? theme.palette.normal.positive : theme.palette.disabled.negative
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

    onEnabledChanged: {
		if( !enabled ) {
			unavailableComponent.createObject(hostPage,{z:100});
		}
	}

	Component {
		id:unavailableComponent
		Unavailable {
			anchors.fill:parent
			label.text:i18n.tr("Action unavailable for now")
		}
	}

}

