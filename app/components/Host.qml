import QtQuick 2.4
import Ubuntu.Components 1.3

Page {


    header: PageHeader {
        id: pageHeader
        title: i18n.tr("Mircast")
        leadingActionBar.actions : [
            Action{
                iconSource: "../graphics/mircast.png"
            }
        ]
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
                mircastSettings.remoteIP = launcher.remoteIP = remoteIp.text;
                mircastSettings.screenWidth = launcher.width = screenWidth.text;
                mircastSettings.screenHeight = launcher.height = screenHeight.text;
                launcher.launch();
            }
        }
    }

}

