import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3

Item {
    anchors {
        left:parent.left
        right:parent.right
        margins: units.gu(1)
    }

    height:childrenRect.height

        Column {
            anchors {
              top:parent.top
              left:parent.left
              right:parent.right
            }
            height:childrenRect.height
            spacing: units.gu(1)
            Label {
                id:instructionsLabel
                anchors {
                    left:parent.left
                    right:parent.right
                    margins: units.gu(1)
                }
                text: i18n.tr("Run the following on the hosting computer (%1) :").arg(remoteIp.text)
            }

            TextArea {
                id:deviceInstructions
                anchors {
                    left:parent.left
                    right:copyCommandButton.left
                    margins: units.gu(1)
                }

				text: launcher.getHostCommand();
                readOnly: true
				 LayoutMirroring.enabled: false
                onCursorPositionChanged: {
                    selectAll();
                }


				Timer {
					interval:1000
					running:true
					repeat:true
					onTriggered: {
						deviceInstructions.text = launcher.getHostCommand();
					}
				}
				MouseArea {
					anchors.fill:parent
					onPressAndHold:deviceInstructions.selectAll();
				}
            }


            Button {
                visible:true
                enabled:visible
                id:copyCommandButton
                objectName: "copyCommandButton"
                anchors {
//                     verticalCenter: deviceInstructions.verticalCenter
                    right:parent.right
                    margins: units.gu(5)
                }
                width: units.gu(5)
                height:units.gu(5)
                iconName: "edit-copy"
                text:i18n.tr("Copy Command Instructions")

                onClicked: {
                    Clipboard.push(deviceInstructions.text)
                }
            }
            Button {
                visible:true
                enabled:visible
                id:shareCommandButton
                objectName: "shareCommandButton"
                anchors {
//                     top:deviceInstructions.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: units.gu(2)
                }
                width: parent.width 
                height:units.gu(5)
                iconName: "share"
                text: exportPicker.visible ? i18n.tr("Abort Sharing") : i18n.tr("Share Command Instructions")

                onClicked: {
                    if(!exportPicker.visible) {
                      exportPeer.exportText(launcher.getHostCommand());
                    }
                    exportPicker.visible = !exportPicker.visible;
                }
            }
            Connections {
				target:exportPicker
				onPeerSelected: {
					var transfer = exportPicker.peer.request()
					transfer.items = [ exportPeer.contentItem.createObject(mainView, { "text": launcher.getHostCommand() })  ]
					transfer.state = ContentTransfer.Charged
				}
			}

        }

}
