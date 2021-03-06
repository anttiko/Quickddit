/*
    Quickddit - Reddit client for mobile phones
    Copyright (C) 2014  Dickson Leong

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see [http://www.gnu.org/licenses/].
*/

import QtQuick 2.0

Item {
    id: customCountBubble

    property int value
    property int colorMode: 0

    height: valueText.paintedHeight + 2 * constant.paddingSmall
    width: valueText.paintedWidth + 2 * constant.paddingMedium

    Rectangle {
        id: background
        anchors.fill: parent
        radius: constant.paddingLarge
        color: {
            if (colorMode > 0)
                return constant.colorPositive;
            else if (colorMode < 0)
                return constant.colorNegative;
            else
                return constant.colorNeutral;
        }
    }

    Text {
        id: valueText
        anchors.centerIn: parent
        font.pixelSize: constant.fontSizeSmall
        color: constant.colorLight
        text: customCountBubble.value
    }
}
