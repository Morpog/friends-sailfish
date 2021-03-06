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

Rectangle {
    id: container
    property bool loading: true
    property variant item
    property alias description: description.text
    signal showComments()
    anchors.fill: parent
    color: Theme.rgba(Theme.highlightBackgroundColor, 0.1)

    Column {
        anchors.left: parent.left; anchors.right: parent.right
        spacing: Theme.paddingMedium

        Row {
            spacing: Theme.paddingLarge
            height: Theme.itemSizeLarge
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingLarge

            Image {
                opacity: container.loading ? 0.5 : 1
                source: "image://theme/icon-s-like" + "?" + Theme.highlightColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                opacity: container.loading ? 0.5 : 1
                color: Theme.highlightColor
                text: item === null ? "" : item.likesCount
                anchors.verticalCenter: parent.verticalCenter
                width: Theme.paddingLarge
            }

            Image {
                opacity: container.loading ? 0.5 : 1
                source: "image://theme/icon-s-chat" + "?" + Theme.highlightColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                opacity: container.loading ? 0.5 : 1
                color: Theme.highlightColor
                text: item === null ? "" : item.commentsCount
                anchors.verticalCenter: parent.verticalCenter
                width: Theme.paddingLarge
            }
        }

        Label {
            id: description
            anchors.left: parent.left; anchors.leftMargin: Theme.paddingMedium
            anchors.right: parent.right; anchors.rightMargin: Theme.paddingMedium
            wrapMode: Text.WordWrap
            visible: text.length > 0
        }

        Label {

            anchors.left: parent.left; anchors.leftMargin: Theme.paddingMedium
            anchors.right: parent.right; anchors.rightMargin: Theme.paddingMedium
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            text: qsTr("Last update %1").arg(Format.formatDate(DateHelper.fromString(item === null ? "" : item.updatedTime), Formatter.DurationElapsed))
        }
    }

    Item {
        anchors.left: parent.left; anchors.right: parent.right
        anchors.bottom: parent.bottom; anchors.bottomMargin: Theme.paddingMedium
        height: childrenRect.height

        BackgroundItem {
            id: likeItem
            opacity: container.loading ? 0.5 : 1
            enabled: !container.loading
            Behavior on opacity { FadeAnimation {} }

            anchors.left: parent.left; anchors.right: parent.horizontalCenter

            Image {
                id: likeIcon
                source: "image://theme/icon-s-like"
                        + (likeItem.highlighted ? "?" + Theme.highlightColor : "")
                anchors.left: parent.left; anchors.leftMargin: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                text: item === null ? "" : (item.liked ? qsTr("Unlike") : qsTr("Like"))
                anchors.left: likeIcon.right; anchors.leftMargin: Theme.paddingLarge
                anchors.right: parent.right; anchors.rightMargin: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
                truncationMode: TruncationMode.Fade
                font.pixelSize: Theme.fontSizeExtraSmall
                color: likeItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                if (item === null) {
                    return
                }

                item.liked ? item.unlike() : item.like()
            }
        }

        BackgroundItem {
            id: commentItem
            opacity: container.loading ? 0.5 : 1
            enabled: !container.loading
            Behavior on opacity { FadeAnimation {} }

            anchors.left: parent.horizontalCenter; anchors.right: parent.right

            Image {
                id: commentsIcon
                source: "image://theme/icon-s-chat"
                        + (commentItem.highlighted ? "?" + Theme.highlightColor : "")
                anchors.left: parent.left; anchors.leftMargin: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                text: qsTr("Comment")
                anchors.left: commentsIcon.right; anchors.leftMargin: Theme.paddingLarge
                anchors.right: parent.right; anchors.rightMargin: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
                truncationMode: TruncationMode.Fade
                font.pixelSize: Theme.fontSizeExtraSmall
                color: commentItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: container.showComments()
        }
    }
}
