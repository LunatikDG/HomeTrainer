// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {

	signal userDataSaved(name);
	signal closed;

    TitleText {
		id: header;
		color: engine.colors.headerText;
		text: tr("Профиль");
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
			parent.update();
			parent.closed();
		}
		onKeyPressed: {		
			if (key == "Up") {
				buttonOK.setFocus();
				return true;
			}	
			if (key == "Down") {
				name.setFocus();
				return true;
			}				
		}
	}

	Item {
		anchors.top: header.bottom;
		anchors.topMargin: engine.margin;

		width: 550;

		BodyText {
			id: textName;
						
			anchors.verticalCenter: name.verticalCenter;

			text: tr("Имя:");
			color: engine.colors.textColor;
		}
		
		Edit {
			id: name;
			
			anchors.right: parent.right;

			width: 350;

			maxLen: 15;
			
			textColor: engine.colors.focusText;
			cursorColor: engine.colors.focusText;
			backColor: activeFocus ? engine.colors.focusBackground : engine.colors.textColor;
			borderColor: engine.colors.focusText;
			borderRadius: 0;

			onKeyPressed: {
				if (key == "Up") {
					buttonClose.setFocus();
					return true;
				}	
				if (key == "Down") {
					birthday.setFocus();
					return true;
				}		
			}			
		}
	}	
	Item {
		anchors.top: name.bottom;
		anchors.topMargin: engine.margin;

		width: 550;

		BodyText {
			id: textBirthday;
						
			anchors.verticalCenter: birthday.verticalCenter;

			text: tr("Год рождения:");
			color: engine.colors.textColor;
		}

		Edit {
			id: birthday;

			anchors.right: parent.right;

			width: 350;

			maxLen: 4;
			validateChars: engine.editCharsNum;
			textColor: engine.colors.focusText;
			cursorColor: engine.colors.focusText;
			backColor: activeFocus ? engine.colors.focusBackground : engine.colors.textColor;
			borderColor: engine.colors.focusText;
			borderRadius: 0;

			onKeyPressed: {
				if (key == "Up") {
					name.setFocus();
					return true;
				}
				if (key == "Down") {
					genderChooser.setFocus();
					return true;
				}										
			}
		}
	}	

	Item {
		height: genderChooser.height;
		width: 550;

		anchors.top: birthday.bottom;
		anchors.left: parent.left;        
		anchors.topMargin: engine.margin;

		BodyText {
			id: textGender;
						
			anchors.verticalCenter: parent.verticalCenter;

			text: tr("Пол:");
			color: engine.colors.textColor;
		}
		Chooser {
			id: genderChooser;

			anchors.right: parent.right;   
			
			backgroundVisible: false;
			textColor: engine.colors.textColor;
			focusTextColor: engine.colors.focusText;
			highlightColor: activeFocus ? engine.colors.focusBackground : engine.colors.textColor;

			model: ListModel { }

			onKeyPressed: {		
				if (key == "Up") {
					birthday.setFocus();
					return true;
				}	
				if (key == "Down") {
					levelChooser.setFocus();
					return true;
				}			
			}
			onCompleted: {
				engine.loadGenderList(this);
			}
		}
	}
	Item {
		height: levelChooser.height;
		width: 550;

		anchors.top: genderChooser.bottom;
		anchors.left: parent.left;        
		anchors.topMargin: engine.margin;

		BodyText {
			id: textLevel;
						
			anchors.verticalCenter: parent.verticalCenter;

			text: tr("Уровень:");
			color: engine.colors.textColor;
		}
		Chooser {
			id: levelChooser;     
			
			anchors.right: parent.right;
			
			backgroundVisible: false;
			textColor: engine.colors.textColor;
			focusTextColor: engine.colors.focusText;
			highlightColor: activeFocus ? engine.colors.focusBackground : engine.colors.textColor;

			model: ListModel { }

			
			onKeyPressed: {		
				if (key == "Up") {
					genderChooser.setFocus();
					return true;
				}
				if (key == "Down") {
					buttonOK.setFocus();
					return true;
				}				
			}
			onCompleted: {
				engine.loadLevelList(this);
			}
		}
	}

	Button {
		id: buttonOK;

		anchors.bottom: parent.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;

		text: tr("Сохранить");
		color: activeFocus ? engine.colors.focusBackground : engine.colors.background;
		textColor: activeFocus ? engine.colors.focusText : engine.colors.textColor;
		borderColor: textColor;
		borderWidth: 2;

		onSelectPressed: {
			var result = engine.saveUser(name.text, birthday.text, genderChooser.currentIndex, levelChooser.currentIndex);
			switch (result) {
				case "emptyName":
					name.placeholderColor = engine.colors.error;
					name.placeholder = tr("Не введено имя!");
					name.setFocus();	
					break;
				case "profileBusy":
					name.placeholderColor = engine.colors.error;
					name.placeholder = tr("Профиль занят!");
					name.text = "";
					name.setFocus();	
					break;
				case "emptyBirthday":
					birthday.placeholderColor = engine.colors.error;
					birthday.placeholder = tr("Не введен год рождения!");
					birthday.text = "";
					birthday.setFocus();
					break;
				case "invalidBirthday":
					birthday.placeholderColor = engine.colors.error;
					birthday.placeholder = tr("Неверно введен год рождения!");
					birthday.text = "";
					birthday.setFocus();
					break;
				case "success":
					parent.userDataSaved(name.text);
					parent.closed();
					break;
			}
		}
		onKeyPressed: {		
			if (key == "Up") {
				levelChooser.setFocus();
            	return true;
			}	
			if (key == "Down") {
				buttonClose.setFocus();
            	return true;
			}				
		}
	}

	onActiveFocusChanged: {
		if(this.activeFocus) {
			name.placeholder = tr("Введите имя");
			name.placeholderColor = engine.colors.placeholder;
			birthday.placeholder = tr("Введите год рождения");
			birthday.placeholderColor = engine.colors.placeholder;

			buttonClose.setFocus();
		}
	}

	function update() {
		this.name.text = engine.user.name;
		this.birthday.text = engine.user.birthday;
		this.genderChooser.currentIndex = engine.user.gender;
		this.levelChooser.currentIndex = engine.user.level;	
	}
}