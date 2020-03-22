// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Item {
    id: editItem;
    focus: true;
    clip: true;

    width: 100;
    height: 40;

//------------properties-----------------------------------

    property string text: "";
    property int maxLen: 0;
    property bool passwordMode: false;
    property string passwordChar: "*";    
    property string placeholder: "";
    property string ignoreChars: "#*";
    property string validateChars: "";

    property Color textColor: colorTheme.activeTextColor;
    property Color cursorColor: colorTheme.activeTextColor;
    property Color backColor: colorTheme.globalBackgroundColor;
    property Color placeholderColor: colorTheme.textColor;
    property Color borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;
    property int borderWidth: 2;
    property int borderRadius: colorTheme.rounded ? 8 : 0;
    
    property bool handleDelete: true;
    property bool showBackground: true;
    property bool alwaysShowCursor: false;

//------------signals--------------------------------------
    
    signal maxLenReached;
    signal invalidKeyEntered(std::string key);

//------------structure------------------------------------

    Rectangle {
        id: borderRect;
        anchors.fill: parent;

        borderWidth: parent.borderWidth;
        radius: parent.borderRadius;
        color: parent.backColor;
        borderColor: parent.borderColor;
        visible: parent.showBackground;

        Behavior on borderColor { animation: Animation { duration: 200; } }
    }
    Item {
        anchors.fill: parent;
        anchors.margins: 5;
        BodyText {
            id: placeholderText;
            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter;
            
            color: editItem.placeholderColor;         
            text: editItem.placeholder;
            opacity: editText.text == "" ? 1 : 0;

            Behavior on opacity { animation: Animation { duration: 500; } }
        }
        BodyText {
            id: editText;
            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter;
            color: editItem.textColor;

            Behavior on opacity { animation: Animation { duration: 300; } }
        }
    }
    Rectangle {
        id: cursorRect;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        anchors.left: editText.right;
        anchors.margins: 7;
        anchors.leftMargin: 2;

        opacity: borderRect.opacity;
        width: 2;        
        color: parent.cursorColor;
        visible: false;
    }
    Timer {
        id: cursorBlinkTimer;
        interval: 500;
        repeat: true;
        
        onTriggered: {
            cursorRect.visible ^= true;
        }
    }

//------------methods--------------------------------------

    function updateText() {
        //log("text changed " + editItem.text);

        var line = editItem.text;
        if (editItem.maxLen > 0)
            line = line.substr(0, editItem.maxLen);

        if (!editItem.passwordMode)
            editText.text = line;
        else
            editText.text = new Array(line.length + 1).join(editItem.passwordChar);
    }
    function removeChar() {
        if (editItem.text.length == 0)
            return;

        var text = editItem.text;
        var i = text.length - 1;

        while (i > 0 && (text[i] & 0xc0) == 0x80)
            i--;

        editItem.text = text.substr(0, i);
    }
    function clear() {
        editItem.text = "";
        editText.width = 0;
    }

//------------handlers-------------------------------------

    onKeyPressed: {
        if (!recursiveVisible)
            return false;
            
        if ((key == "Backspace" || key == "Left") && this.handleDelete) {
            removeChar();
            return true;
        } 
        if (key == "Space") {
            this.text += " ";
            return true;
        } 
        if (key.length == 1) {
            if (this.ignoreChars.indexOf(key) != -1)
                return true;
            if (this.validateChars.length > 0 && this.validateChars.indexOf(key) == -1)
                return true;

            if (this.maxLen == 0 || this.text.length < this.maxLen)
                this.text += key;
            return true;
        }
        
        return false;
    }
    onActiveFocusChanged: {
        cursorRect.visible = activeFocus || alwaysShowCursor;

        if (cursorRect.visible)
            cursorBlinkTimer.restart();
        else
            cursorBlinkTimer.stop();
    }
    onTextChanged: {
        this.updateText();
    }
    onCompleted: {
        this.updateText();
    }
}