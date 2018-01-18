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
                    right:parent.right
                    margins: units.gu(4)
                }
                readOnly: true
                onCursorPositionChanged: {
                    selectAll();
                }

                text: getHostCommand();

                function getHostCommand() {
                    return "nc -l "+ portNumber.text +" | "
                            +"gzip -dc | mplayer -demuxer rawvideo -rawvideo fps=12"
                            +":w="+screenWidth.text
                            +":h="+screenHeight.text
                            +":format=rgba -";

                }
            }
            Button {
                visible:true
                enabled:visible
                id:shareCommandButton
                objectName: "shareCommandButton"
                anchors {
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
 
