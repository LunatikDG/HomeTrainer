// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "UserList.qml";

Rectangle {

	signal closed;
	signal newSelected;
	signal userSelected(name);

	Rectangle {
		id: header;

		anchors.left: parent.left;
		anchors.right: parent.right;
		height: engine.logoAuthHeight;

		color: engine.colors.backgroundSidebar;

		Image {
			anchors.fill: parent;
			anchors.margins: engine.margin;
			source: engine.resourcesPath + "logo.png";
			fillMode: PreserveAspectFit;
		}

		Button {
			id: buttonClose;

			anchors.verticalCenter: parent.verticalCenter;
			anchors.right: parent.right;
			anchors.rightMargin: engine.margin;
			width: height;

			text: "X";
			borderWidth: 2;
			color: activeFocus ? engine.colors.background : engine.colors.focusBackground;
			textColor: activeFocus ? engine.colors.textColor : engine.colors.focusText;
			borderColor: textColor;
			radius: 10;

			onSelectPressed: {
				parent.parent.closed();
			}
			onKeyPressed: {		
				if (key == "Up") {
					if(buttonNew.visible)
						buttonNew.setFocus();
					else {
						userList.setFocus();
						userList.currentIndex = userList.model.count - 1;
					}
					return true;
				}
				if (key == "Down") {
					if(userList.visible)
						userList.setFocus();
					else
						buttonNew.setFocus();
					return true;
				}			
			}
		}
	}

	SubheadText {
		id: hintText;
		anchors.top: header.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.topMargin: engine.margin;
		color: engine.colors.textColor;
	}

	UserList {
		id: userList;

		anchors.top: hintText.bottom;
		anchors.topMargin: engine.margin;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.bottom: parent.bottom;

		onSelectPressed: {
			parent.userSelected(this.model.get(this.currentIndex).name);
		}

		onKeyPressed: {		
			if (key == "Up" && this.currentIndex == 0) {
				buttonClose.setFocus();
				return true;
			}	
			if (key == "Down" && this.currentIndex == this.model.count - 1) {
				if(buttonNew.visible)
					buttonNew.setFocus();
				else
					buttonClose.setFocus();
				return true;
			}				
		}
	}

	Button {
		id: buttonNew;

		anchors.bottom: parent.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.bottomMargin: engine.margin;

		text: tr("Создать");
		width: engine.userButtonWidth;
		color: activeFocus ? engine.colors.focusBackground : engine.colors.background;
		textColor: activeFocus ? engine.colors.focusText : engine.colors.textColor;
		borderColor: textColor;
		borderWidth: 2;

		onKeyPressed: {		
			if (key == "Up") {
				if(userList.visible) {
					userList.setFocus();
					userList.currentIndex = userList.model.count - 1;
				}
				else
					buttonClose.setFocus();
				return true;
			}
			if (key == "Down") {
				buttonClose.setFocus();
				return true;
			}
		}
		onSelectPressed: {
			parent.newSelected();
		}
	}

	onActiveFocusChanged: {
		if(this.activeFocus) {
			this.loadUsers();
			if(userList.visible) {
				userList.setFocus();
			}
			else
				buttonNew.setFocus();
		}
	}

	function loadUsers() {
		var count = engine.loadUserList(userList);
		if(count > 0) {
			userList.visible = true;			
			hintText.text = tr("Выберите профиль");
			buttonNew.visible = (count <= 6);
			buttonNew.anchors.centerIn = false;
		}		
		else {
			userList.visible = false;
			buttonNew.visible = true;
			buttonNew.anchors.centerIn = this;
			hintText.text = tr("Создайте новый профиль");			
		}
	}
}