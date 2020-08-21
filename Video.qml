// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {

    signal playerStopped;

    focus: true;

    TitleText {
        id: header;
        color: engine.colors.headerText;
        text: tr("Видео");
    }

    VideoPlayer {
        id: htPlayer;

        anchors.top: header.bottom;
        anchors.topMargin: engine.margin;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;

        visible: false;

        onBackPressed: {
            this.abort();
            this.visible = false;
            log("hide");
            parent.playerStopped();
        }

        onFinished: {
            this.visible = false;
            log("hide");
            parent.playerStopped();
        }
    }

    onActiveFocusChanged: {
        if(this.activeFocus) {
            htPlayer.visible = true;
            htPlayer.title = engine.videos[1].title;
            htPlayer.playVideoById(engine.videos[1].url);
        }
    }
}