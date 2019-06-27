/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 2019  eran <email>
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
import QtGraphicalEffects 1.0

import Ubuntu.Components 1.3


Item {

	property alias label:centerLabel
	property alias background:backgroundFill

	anchors.fill:parent

	Rectangle {
		id:backgroundFill
		anchors.fill:parent
		opacity:0.75
		color: theme.palette.disabled.background
	}
	Label {
		id:centerLabel
		anchors {
			centerIn:parent
		}
		text: i18n.tr("Action Unavailable")
		textSize:Label.Large
		color:theme.palette.disabled.backgroundTertiaryText
		layer.enabled:true
		layer.effect:DropShadow {
			radius:3.0
			horizontalOffset: -3
			verticalOffset: -3
		}
	}
    
}
