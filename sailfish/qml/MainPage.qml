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
    id: mainPage
    objectName: "mainPage"
    title: linkModel.title
    busy: linkVoteManager.busy

    readonly property variant sectionModel: ["Hot", "New", "Rising", "Controversial", "Top"]

    function refresh(subreddit) {
        if (subreddit === undefined || subreddit == "") {
            linkModel.location = LinkModel.FrontPage;
        } else if (subreddit.toLowerCase() == "all") {
            linkModel.location = LinkModel.All;
        } else {
            linkModel.location = LinkModel.Subreddit;
            linkModel.subreddit = subreddit;
        }
        linkModel.refresh(false);
    }

    property Component __subredditDialogModelComponent: Component {
        SubredditModel {
            manager: quickdditManager
            section: SubredditModel.UserAsSubscriberSection
            onError: infoBanner.alert(errorString);
        }
    }
    property QtObject __subredditDialogModel
    function __openSubreddiitDialog() {
        var p = {}
        if (quickdditManager.isSignedIn) {
            if (!__subredditDialogModel)
                __subredditDialogModel = __subredditDialogModelComponent.createObject(mainPage);
            p.subredditModel = __subredditDialogModel;
        }
        var dialog = pageStack.replace(Qt.resolvedUrl("SubredditDialog.qml"), p);
        dialog.accepted.connect(function() {
            if (!dialog.acceptDestination)
                refresh(dialog.text);
        });
    }

    property Component __multiredditModelComponent: Component {
        MultiredditModel {
            manager: quickdditManager
            onError: infoBanner.alert(errorString);
        }
    }
    property QtObject __multiredditModel
    function __openMultiredditDialog() {
        if (!__multiredditModel)
            __multiredditModel = __multiredditModelComponent.createObject(mainPage);
        var dialog = pageStack.replace(Qt.resolvedUrl("MultiredditDialog.qml"), {multiredditModel: __multiredditModel});
        dialog.accepted.connect(function() {
            linkModel.location = LinkModel.Multireddit;
            linkModel.multireddit = dialog.multiredditName;
            linkModel.refresh(false);
        });
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: "More"
                onClicked: {
                    var page = pageStack.push(Qt.resolvedUrl("MainPageMorePage.qml"),
                                              {enableFrontPage: linkModel.location != LinkModel.FrontPage });
                    page.subredditsClicked.connect(__openSubreddiitDialog);
                    page.multiredditsClicked.connect(__openMultiredditDialog);
                }
            }
            MenuItem {
                text: "About /r/" + linkModel.subreddit
                visible: linkModel.location == LinkModel.Subreddit
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

        Column {
            width: parent.width
            id: headerContainer
            PageHeader { title: mainPage.title }
        }

        SilicaListView {
            id: linkListView
            anchors.bottom: parent.bottom
            anchors.top: headerContainer.bottom
            width: parent.width
            model: linkModel
            clip: true


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
    }


    LinkModel {
        id: linkModel
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
