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

AbstractPage {
    id: signInPage
    title: "Sign in to Reddit"
    busy: webView.loading
    backNavigation: webView.atXBeginning && webView.atXEnd && !webView.moving && !webView.pulleyMenuActive

    SilicaWebView {
        id: webView
        anchors.fill: parent
        header: PageHeader { title: signInPage.title }
        overridePageStackNavigation: true

        onUrlChanged: {
            if (url.toString().indexOf("code=") > 0) {
                stop();
                quickdditManager.getAccessToken(url);
                signInPage.busy = true;
            }
        }

        PullDownMenu {
            MenuItem {
                text: "Cancel"
                onClicked: {
                    backNavigation = true;
                    pageStack.pop();
                }
            }
            MenuItem {
                text: "Reload"
                onClicked: webView.reload();
            }
        }

        ScrollDecorator {}
    }

    Connections {
        target: quickdditManager
        onAccessTokenSuccess: {
            signInPage.busy = false;
            infoBanner.alert("Sign in successfully! Welcome! :)");
            var mainPage = pageStack.find(function(page) { return page.objectName == "mainPage"; });
            mainPage.refresh("");
            backNavigation = true;
            pageStack.pop(mainPage);
        }
        onAccessTokenFailure: {
            signInPage.busy = false;
        }
    }

    Component.onCompleted: webView.url = quickdditManager.generateAuthorizationUrl();
}
