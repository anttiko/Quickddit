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

ContextMenu {
    id: commentMenu

    property variant comment
    property string linkPermalink
    property VoteManager commentVoteManager

    // when the menu is closing SilicaListView will override the contentY causes the positioning to failed
    // position at menu destruction to fix this
    property bool __showParentAtDestruction: false
    // TODO: this is ugly :(
    property bool __showNextAtDestruction: false
    property bool __showPrevAtDestruction: false
    property bool __showRootAtDestruction: false
    signal showNext
    signal showPrev
    signal showRoot

    signal showParent
    signal replyClicked
    signal editClicked
    signal deleteClicked
    signal collapse

    MenuItem {
        id: upvoteButton
        visible: quickdditManager.isSignedIn && comment.likes != 1
        enabled: !commentVoteManager.busy
        text: "Upvote"
        onClicked: commentVoteManager.vote(comment.fullname, VoteManager.Upvote)
    }
    MenuItem {
        visible: quickdditManager.isSignedIn && comment.likes != -1
        enabled: !commentVoteManager.busy
        text: "Downvote"
        onClicked: commentVoteManager.vote(comment.fullname, VoteManager.Downvote)
    }
    MenuItem {
        visible: quickdditManager.isSignedIn && comment.likes != 0
        enabled: !commentVoteManager.busy
        text: "Unvote"
        onClicked: commentVoteManager.vote(comment.fullname, VoteManager.Unvote)
    }
    MenuItem {
        visible: quickdditManager.isSignedIn
        text: "Reply"
        onClicked: replyClicked();
    }
    MenuItem {
        visible: comment.isAuthor
        text: "Edit"
        onClicked: editClicked();
    }
    MenuItem {
        visible: comment.isAuthor
        text: "Delete"
        onClicked: deleteClicked();
    }
    MenuItem {
        text: "Permalink"
        onClicked: {
            var link = QMLUtils.toAbsoluteUrl(linkPermalink + comment.fullname.substring(3));
            globalUtils.createOpenLinkDialog(link);
        }
    }
    MenuItem {
        visible: comment.depth > 0
        text: "Parent"
        onClicked: __showParentAtDestruction = true;
    }

    /*
    MenuItem {
        visible: comment.depth > 0
        text: "Root"
        onClicked: __showRootAtDestruction = true;
    }

    MenuItem {
        visible: comment.depth == 0
        text: "Previous"
        onClicked: __showPrevAtDestruction = true;
    }

    MenuItem {
        visible: comment.depth == 0
        text: "Next"
        onClicked: __showNextAtDestruction = true;
    }
    */

    MenuItem {
        text: "Collapse"
        onClicked: collapse();
    }

    Component.onDestruction: {
        if (__showParentAtDestruction)
            showParent();
        if (__showNextAtDestruction)
            showNext();
        if (__showPrevAtDestruction)
            showPrev();
        if (__showRootAtDestruction)
            showRoot();
    }
}
