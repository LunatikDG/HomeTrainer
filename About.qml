// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {
	
	signal closed;

    TitleText {
		id: header;
		color: engine.colors.headerText;
		text: tr("О программе");
	}
	Button {
		id: buttonClose;

		anchors.right: parent.right;
		width: height;

		text: "X";
		borderWidth: 2;
		color: activeFocus ? engine.colors.focusBackground : engine.colors.background;
		textColor: activeFocus ? engine.colors.focusText : engine.colors.textColor;
		borderColor: textColor;
		radius: 10;

		onSelectPressed: {
			parent.closed();
		}
	}

	Resource {
		url: engine.resourcesPath + "about.json";
		onDataChanged: {
			this.description.text = (JSON.parse(this.data)).text;
		}
	}

	BodyText {
		id: description;

		anchors.top: header.bottom;
        anchors.topMargin: engine.margin;
        anchors.left: parent.left;
        anchors.right: parent.right;
        
		color: engine.colors.textColor;	
        wrapMode: WordWrap;	
	}
	Image {
		anchors.right: parent.right;
		anchors.bottom: parent.bottom;
		height: engine.teamHeight;
		width: engine.teamWidth;
		source: engine.resourcesPath + "team.png";
		fillMode: PreserveAspectFit;
	}
}