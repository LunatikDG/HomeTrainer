// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "Menu.qml";

Rectangle {

    signal menuSelected(target);

    Image {
        id: logo;

        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.margins: engine.marginHalf;

        source: engine.resourcesPath + "logo.png";
        fillMode: PreserveAspectFit;
    }
    Rectangle {
        id: hline;

        anchors.top: logo.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.margins: engine.marginHalf;

        height: 2;
        color: engine.colors.focusText;
    }

    Item {
        id: name;

        anchors.top: hline.bottom;
        anchors.margins: engine.marginHalf;
        anchors.topMargin: engine.margin;

        width: parent.width;
        
        BodyText {
            id: nameText;
            anchors.centerIn: parent;
            color: engine.colors.userName;
        }
    }

    Menu {
        id: menu;
        anchors.top: name.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.margins: engine.marginHalf;
        anchors.topMargin: engine.margin;

        onSelectPressed: {
            parent.menuSelected(this.model.get(this.currentIndex).target);
        }
    }
    function update() {        
        engine.updateSidebar(nameText, menu);
    }
}