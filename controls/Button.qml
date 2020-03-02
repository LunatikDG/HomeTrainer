// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {
	id: simpleButton;
    focus: true;

    height: buttonText.paintedHeight + borderWidth + 30;
	width: Math.max(140, buttonText.width + borderWidth + 30);

    borderWidth: 0;
    radius: 3;
    color: activeFocus ? colorTheme.activeFocusColor : colorTheme.focusablePanelColor;
    borderColor: activeFocus ? colorTheme.activeBorderColor : colorTheme.borderColor;

//------------properties-----------------------------------

	property string text;
	property Color textColor: activeFocus ? colorTheme.focusedTextColor : colorTheme.activeTextColor;

//------------structure------------------------------------

	BodyText {
		id: buttonText;

        anchors.centerIn: parent;
		
        opacity: parent.enabled ? 1 : 0.4;
		color: parent.textColor;
		text: parent.text;		

		Behavior on color { animation: Animation { duration: 300; } }
	}

//------------animations-----------------------------------

    Behavior on color { animation: Animation { duration: 300; } }
}