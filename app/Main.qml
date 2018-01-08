import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3
import Qt.labs.settings 1.0
import Mircast 1.0
/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "mircast.etherpulse"

    width: units.gu(100)
    height: units.gu(75)

    Page {
        header: PageHeader {
            id: pageHeader
            title: i18n.tr("Mircast")
            StyleHints {
                foregroundColor: theme.palette.normal.foreground
                backgroundColor: theme.palette.normal.background
            }
        }

        Settings {
            id:micastSettings
            property var remoteIP: ""
            property var screenWidth: ""
            property var screenHeight: ""
            property var compression: 9
        }

        Launcher {
            id: launcher
        }
        Column {
            id:settingsColumn
            enabled:!launcher.active
            anchors {
                top: pageHeader.bottom
                left:parent.left
                right:parent.right
                topMargin: units.gu(5)
            }
            height:units.gu(15)
            spacing: units.gu(3)

            Row {
                id:connectionSettingssRow
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    topMargin: units.gu(2)
                }
                width:parent.width
                spacing: units.gu(3)

                TextField {
                    id: remoteIp
                    width:parent.width/2 - parent.spacing
                    objectName: "remoteIp"
                    placeholderText: i18n.tr("Remote IP / hostname")
                    text:micastSettings.remoteIP
                }

                TextField {
                    id: portNumber
                    visible:false
                    objectName: "portNumber"
                    placeholderText: i18n.tr("Remote port number")
                    text:"12345"
                }

                Label {
                    id:compressionLabel
                    text: i18n.tr("Compression") + " :"

                }

                Slider {
                    id:compression
                    width:parent.width/2 - (parent.spacing*2) - compressionLabel.width
                    maximumValue: 9
                    minimumValue: 1
                    value: micastSettings.compression
                    onValueChanged: {
                        micastSettings.compression = launcher.compression = value;
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

                TextField {
                    id: screenWidth
                    width:parent.width/2 - parent.spacing
                    objectName: "screenWidth"
                    placeholderText: i18n.tr("Width")
                    text:micastSettings.screenWidth

                }

                TextField {
                    id: screenHeight
                    width:parent.width/2- parent.spacing
                    objectName: "screenHeight"
                    placeholderText: i18n.tr("Height")
                    text:micastSettings.screenHeight
                }
            }
        }
        TextArea {
            id:hostInstructions
            anchors {
                left:parent.left
                right:parent.right
                top:settingsColumn.bottom
                margins: units.gu(2)
            }
            readOnly: true
            text: i18n.tr("Run the following on the hosting computer (%1) :").arg(remoteIp.text)+ "\n\n" + getHostCommand();

            function getHostCommand() {
                return "nc -l "+ portNumber.text +" | "
                        +"gzip -dc | mplayer -demuxer rawvideo -rawvideo fps=12"
                        +":w="+screenWidth.text
                        +":h="+screenHeight.text
                        +":format=rgba -";

            }
        }
        ContentPeerPicker {
            id:exportPicker
            visible: false
            contentType: ContentType.Text
            handler: ContentHandler.Share

            onPeerSelected: {
                exportPeer.selectionType = ContentTransfer.Single
                mainPage.activeTransfer = exportPeer.request()
                this.visible = false;
            }
        }

        ContentPeer {
            id: exportPeer
            contentType: ContentType.Text
            handler: ContentHandler.Share

            property Component picItem: ContentItem {}

            function exportText(text) {
                var transfer = exportPeer.request()
                transfer.items = [ text ]
                transfer.state = ContentTransfer.Charged
                exportPicker.visible = true;
            }
        }

        Button {
            id:shareCommandButton
            objectName: "shareCommandButton"
            anchors {
                horizontalCenter: parent.horizontalCenter
                top:hostInstructions.bottom
                margins: units.gu(2)
            }
            width: parent.width
            height:units.gu(5)
            iconName: "share"
            text: i18n.tr("Share Command Instructions")

            onClicked: {
               exportPeer.exportText();
            }
        }

        TextArea {
            id:outputLog
            anchors {

                left:parent.left
                right:parent.right
                top:shareCommandButton.bottom
                bottom:castButton.top
                margins: units.gu(2)
            }
            readOnly: true
            text: launcher.output
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

            text: launcher.active ? i18n.tr("Stop Cast") :i18n.tr("Cast")

            onClicked: {
                if(launcher.active) {
                    launcher.stop();
                } else {
                    micastSettings.remoteIP = launcher.remoteIP = remoteIp.text;
                    micastSettings.screenWidth = launcher.width = screenWidth.text;
                    micastSettings.screenHeight = launcher.height = screenHeight.text;
                    launcher.launch();
                }
            }
        }
    }
}


