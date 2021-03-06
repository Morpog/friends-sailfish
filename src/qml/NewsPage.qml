/*
 * Copyright (C) 2013 Lucien XU <sfietkonstantin@free.fr>
 *
 * You may use this file under the terms of the BSD license as follows:
 *
 * "Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * The names of its contributors may not be used to endorse or promote
 *     products derived from this software without specific prior written
 *     permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.friends 1.0
import harbour.friends.social 1.0
import harbour.friends.social.extra 1.0

Page {
    id: container
    property string identifier
    function load() {
        if (!view.ready) {
            view.queued = true
            return
        }
        if (model.status == SocialNetwork.Idle || model.status == SocialNetwork.Error) {
            model.load()
        }
    }
    onStatusChanged: {
        if (status == PageStatus.Active) {
            pageStack.pushAttached(menuPage)
        }
    }

    StateIndicator {
        busy: (!view.ready || model.status == SocialNetwork.Busy) && model.count == 0
        error: model.status == SocialNetwork.Error
        onReload: container.load()
    }

    SilicaListView {
        id: view
        anchors.fill: parent
        property bool ready: facebook.currentUserIdentifier != "me"
        property bool queued: false
        visible: (model.status == SocialNetwork.Idle && view.ready) || model.count > 0
        onReadyChanged: {
            if (ready && queued) {
                queued = false
                load()
            }
        }

        model: SocialNetworkModel {
            id: model
            socialNetwork: facebook
            filter: NewsFeedFilter {
                type: NewsFeedFilter.Home
            }
        }
        header: PageHeader {
            title: qsTr("News")
        }

        delegate: PostDelegate {
            post: model.contentItem
            from: model.contentItem.from
            to: model.contentItem.to.length > 0 ? model.contentItem.to[0] : null
            fancy: false
            onClicked: {
                var headerProperties = {"post": post, "to": to, "from": from }
                var page = pageStack.push(Qt.resolvedUrl("CommentsPage.qml"),
                                          {"identifier": post.identifier,
                                           "item": post,
                                           "headerComponent": headerComponent,
                                           "headerProperties": headerProperties})
                page.load()
            }
        }

        onAtYEndChanged: {
            if (atYEnd && model.hasNext) {
                model.loadNext()
            }
        }

        VerticalScrollDecorator {}

        ViewPlaceholder {
            enabled: model.status == SocialNetwork.Idle && model.count == 0
            text: qsTr("No news")
        }
    }

    PostCommentHeaderComponent {
        id: headerComponent
    }
}
