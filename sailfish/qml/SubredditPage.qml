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

AbstractPage {
    id: subredditPage
    objectName: "subredditPage"
    title: linkModel.title
    busy: linkVoteManager.busy

    readonly property variant sectionModel: ["Hot", "New", "Rising", "Controversial", "Top"]

    property string subreddit

    SilicaListView {
        id: linkListView
        anchors.fill: parent
        width: parent.width
        model: linkModel

        header: PageHeader { title: subredditPage.title }

        PullDownMenu {
            MenuItem {
                text: "About /r/" + linkModel.subreddit
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AboutSubredditPage.qml"), {subreddit: linkModel.subreddit});
                }
            }
            MenuItem {
                text: "Section"
                onClicked: {
                    globalUtils.createSelectionDialog("Section", sectionModel, linkModel.section,
                    function(selectedIndex) {
                        linkModel.section = selectedIndex;
                        linkModel.refresh(false);
                    });
                }
            }
            MenuItem {
                text: "Refresh"
                onClicked: linkModel.refresh(false);
            }
        }


        delegate: LinkDelegate {
            menu: Component { LinkMenu {} }
            showMenuOnPressAndHold: false
            showSubreddit: linkModel.location != LinkModel.Subreddit
            onClicked: {
                var p = { link: model, linkVoteManager: linkVoteManager };
                pageStack.push(Qt.resolvedUrl("CommentPage.qml"), p);
            }
            onPressAndHold: showMenu({link: model, linkVoteManager: linkVoteManager});
        }

        footer: LoadingFooter { visible: linkModel.busy; listViewItem: linkListView }

        onAtYEndChanged: {
            if (atYEnd && count > 0 && !linkModel.busy && linkModel.canLoadMore)
                linkModel.refresh(true);
        }

        ViewPlaceholder { enabled: linkListView.count == 0 && !linkModel.busy; text: "Nothing here :(" }

        VerticalScrollDecorator {}
    }


    LinkModel {
        id: linkModel
        location: LinkModel.Subreddit
        subreddit: subredditPage.subreddit
        manager: quickdditManager
        onError: infoBanner.alert(errorString)
    }

    VoteManager {
        id: linkVoteManager
        manager: quickdditManager
        onVoteSuccess: linkModel.changeLikes(fullname, likes);
        onError: infoBanner.alert(errorString);
    }
}
