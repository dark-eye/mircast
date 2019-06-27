/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 2018  eran <email>
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import QtQuick.Window 2.2
import Ubuntu.Components 1.3

Page {
	id:_basePage

     header: MiracastHeader {
		id:pageHeader
	}

    Item {
	   anchors {
            top: pageHeader.bottom
            left:parent.left
            right:parent.right
            bottom:parent.bottom
        }
        PageStack {
            id:mainPageStack
        }
    }

	Component.onCompleted: {
		pageHeader.switchToCast.connect(switchToCast);
		pageHeader.switchToHost.connect(switchToHost);
        mainPageStack.push(Qt.resolvedUrl("Device.qml"))
	}

    function switchToCast() {
        switchTo(Qt.resolvedUrl("Device.qml"));
    }

    function switchToHost() {
        switchTo(Qt.resolvedUrl("Host.qml"));
    }

    function switchTo(component) {
        console.log("switchTO : "+ component);
        mainPageStack.pop();
        mainPageStack.push(component)
    }
}
