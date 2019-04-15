import QtQuick 2.4
import QtQuick.Window 2.2
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3
import Qt.labs.settings 1.0
import Mircast 1.0

import "components"
/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    id:mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "mircast.etherpulse"

    width: units.gu(100)
    height: units.gu(75)


    Settings {
        id:mircastSettings
        property var remoteIP: ""
        property var screenWidth: Screen.width / 2
        property var screenHeight: Screen.height / 2
        property var compression: 7
    }

    Launcher {
        id: launcher
    }


    BasePage {
        id:mainPage
    }

    ContentPeerPicker {
        id:exportPicker
        visible: false
        contentType: ContentType.Text
        handler: ContentHandler.Share

        onPeerSelected: {
            exportPeer.selectionType = ContentTransfer.Single
            this.visible = false;
        }
        onCancelPressed:  {
            this.visible = false;
        }
    }

    ContentPeer {
        id: exportPeer
        appId:mainView.applicationName
        contentType: ContentType.Text
        handler: ContentHandler.Share

        property Component contentItem: ContentItem {}

        function exportText(text) {
            var transfer = exportPeer.request()
            transfer.items = [ contentItem.createObject(mainView, { "text": text })  ]
            transfer.state = ContentTransfer.Charged
        }

        function exportUrl(url) {
            var transfer = exportPeer.request()
            transfer.items = [ contentItem.createObject(mainView, { "url": url })  ]
            transfer.state = ContentTransfer.Charged
        }
    }
}


