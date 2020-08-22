// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {

    TitleText {
        id: header;
        color: engine.colors.headerText;
        text: tr("Видео");
    }

    Chooser {
        id: videoChooser;     
        
        anchors.top: header.bottom;
        anchors.topMargin: engine.margin;
        anchors.left: parent.left;
        anchors.right: parent.right;
        
        backgroundVisible: false;
        textColor: engine.colors.textColor;
        focusTextColor: engine.colors.focusText;
        highlightColor: activeFocus ? engine.colors.focusBackground : engine.colors.textColor;

        model: ListModel { }

        onKeyPressed: {        
            if (key == "Up" || key == "Down") {
                buttonOK.setFocus();
                return true;
            }              
        }
        onCompleted: {
            engine.loadVideoList(this);
        }
    }
    Button {
        id: buttonOK;

        anchors.top: videoChooser.bottom;
        anchors.right: parent.right;  
        anchors.topMargin: engine.margin;

        text: tr("Просмотр");
        color: activeFocus ? engine.colors.focusBackground : engine.colors.background;
        textColor: activeFocus ? engine.colors.focusText : engine.colors.textColor;
        borderColor: textColor;
        borderWidth: 2;

        onSelectPressed: {
            htPlayer.visible = true;
            htPlayer.title = engine.videoItems[videoChooser.currentIndex].title;
            htPlayer.playVideoById(engine.videoItems[videoChooser.currentIndex].url);
        }
        onKeyPressed: {        
            if (key == "Up" || key == "Down") {
                videoChooser.setFocus();
                return true;
            }                 
        }
    }

    VideoPlayer {
        id: htPlayer;

        anchors.fill: mainWindow;

        visible: false;

        onBackPressed: {
            this.abort();
            this.visible = false;
            log("hide");
            videoChooser.setFocus();
        }

        onFinished: {
            this.visible = false;
            log("hide");
            videoChooser.setFocus();
        }
    }

    onActiveFocusChanged: {
        if(this.activeFocus) {
            videoChooser.currentIndex = 0;
            videoChooser.setFocus();
        }
    }
}