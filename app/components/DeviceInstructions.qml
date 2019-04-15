import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    anchors {
        left:parent.left
        right:parent.right
        margins: units.gu(1)
    }


        Column {
            anchors {
              fill: parent
            }
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
//                     top:instructionsLabel.bottom
                    left:parent.left
                    right:copyCommandButton.left
                    margins: units.gu(4)
                }
                readOnly: true
                onCursorPositionChanged: {
                    selectAll();
                }

                text: getHostCommand();

                function getHostCommand() {
                    return "nc -l "+ portNumber.text +" | "
                            +(compression.value ? "gzip -dc | " : "")
							+"mplayer -demuxer rawvideo -rawvideo fps=15"
                            +":w="+screenWidth.text
                            +":h="+screenHeight.text
                            +":format=rgba -";

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
                //text:i18n.tr("Copy Command Instructions")

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
                      exportPeer.exportText(hostInstructions.getHostCommand());
                    }
                    exportPicker.visible = !exportPicker.visible;
                }
            }

        }

}
