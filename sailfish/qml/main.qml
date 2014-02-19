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
import Sailfish.Silica 1.0
import harbour.quickddit.Core 1.0

ApplicationWindow {
    id: appWindow
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml");

    // Global busy indicator, it reads the 'busy' property from the current page
    DockedPanel {
        id: busyPanel
        width: parent.width
        height: busyIndicator.height + constant.paddingLarge
        open: pageStack.currentPage.hasOwnProperty('busy') ? pageStack.currentPage.busy : false
        dock: Dock.Bottom
        enabled: false

        BusyIndicator {
            id: busyIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            running: busyPanel.open
        }
    }

    InfoBanner { id: infoBanner }

    // A collections of global utility functions
    QtObject {
        id: globalUtils

        property Component __openLinkDialogComponent: null

        function openInTextLink(url) {
            url = QMLUtils.toAbsoluteUrl(url);
            if (!url)
                return;

            var subredditregex = /^https?:\/\/(\w+\.)?reddit.com\/r\/(\w+)?/;
            if (/^https?:\/\/imgur\.com/.test(url))
                pageStack.push(Qt.resolvedUrl("ImageViewPage.qml"), {imgurUrl: url});
            else if (/^https?:\/\/i\.imgur\.com/.test(url))
                pageStack.push(Qt.resolvedUrl("ImageViewPage.qml"), {imageUrl: url});
            else if (/^https?:\/\/.+\.(jpe?g|png|gif)/i.test(url))
                pageStack.push(Qt.resolvedUrl("ImageViewPage.qml"), {imageUrl: url});
            else if (/^https?:\/\/(\w+\.)?reddit.com(\/r\/\w+)?\/comments\/\w+/.test(url))
                pageStack.push(Qt.resolvedUrl("CommentPage.qml"), {linkPermalink: url});
            else if (subredditregex.test(url))
            {
                var subreddit = subredditregex.exec(url)[2];
                pageStack.push(Qt.resolvedUrl("SubredditPage.qml"), {subreddit: subreddit});
            }
            else
                createOpenLinkDialog(url);
        }

        function createOpenLinkDialog(url) {
            pageStack.push(Qt.resolvedUrl("OpenLinkDialog.qml"), {url: url});
        }

        function createSelectionDialog(titleText, model, selectedIndex, onAccepted) {
            var p = {titleText: titleText, model: model, selectedIndex: selectedIndex}
            var dialog = pageStack.push(Qt.resolvedUrl("SelectionDialog.qml"), p);
            dialog.accepted.connect(function() { onAccepted(dialog.selectedIndex); })
        }
    }

    Constant { id: constant }
    AppSettings { id: appSettings }

    QuickdditManager {
        id: quickdditManager
        settings: appSettings
        onAccessTokenFailure: infoBanner.alert(errorString);
    }
}
