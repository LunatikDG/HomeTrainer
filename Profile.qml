// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {
    TitleText {
		id: header;
		color: utils.colors.headerText;
		text: tr("Анкета");
	}
	Button {
		id: buttonClose;

		anchors.right: parent.right;
		width: height;

		text: "X";
		borderWidth: 2;
		color: activeFocus ? utils.colors.focusBackground : utils.colors.background;
		textColor: activeFocus ? utils.colors.focusText : utils.colors.textColor;
		borderColor: textColor;
		radius: 10;

		onSelectPressed: {
			profile.loadUser();
			menu.setFocus();
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
		anchors.topMargin: 2*utils.margin;

		width: 550;

		BodyText {
			id: textName;
						
			anchors.verticalCenter: name.verticalCenter;

			text: tr("Имя:");
			color: utils.colors.textColor;
		}
		
		Edit {
			id: name;
			
			anchors.right: parent.right;

			width: 350;

			maxLen: 15;
			textColor: utils.colors.focusText;
			cursorColor: utils.colors.focusText;
			backColor: activeFocus ? utils.colors.focusBackground : utils.colors.textColor;
			placeholderColor: utils.colors.placeholder;
			borderColor: utils.colors.focusText;
			borderRadius: 0;
		
			placeholder: tr("Введите имя");
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
		anchors.topMargin: 2*utils.margin;

		width: 550;

		BodyText {
			id: textBirthday;
						
			anchors.verticalCenter: birthday.verticalCenter;

			text: tr("Год рождения:");
			color: utils.colors.textColor;
		}

		Edit {
			id: birthday;

			anchors.right: parent.right;

			width: 350;

			maxLen: 4;
			validateChars: utils.editCharsNum;
			textColor: utils.colors.focusText;
			cursorColor: utils.colors.focusText;
			backColor: activeFocus ? utils.colors.focusBackground : utils.colors.textColor;
			placeholderColor: utils.colors.placeholder;
			borderColor: utils.colors.focusText;
			borderRadius: 0;
		
			placeholder: tr("Введите год рождения");

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
		anchors.topMargin: 2*utils.margin;

		BodyText {
			id: textGender;
						
			anchors.verticalCenter: parent.verticalCenter;

			text: tr("Пол:");
			color: utils.colors.textColor;
		}
		Chooser {
			id: genderChooser;

			anchors.right: parent.right;   
			
			backgroundVisible: false;
			textColor: utils.colors.textColor;
			focusTextColor: utils.colors.focusText;
			highlightColor: activeFocus ? utils.colors.focusBackground : utils.colors.textColor;

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
				utils.genderItems.forEach(function (item) {
					model.append( { text: tr(item.title)} );
				});
				
			}
		}
	}
	Item {
		height: levelChooser.height;
		width: 550;

		anchors.top: genderChooser.bottom;
		anchors.left: parent.left;        
		anchors.topMargin: 2*utils.margin;

		BodyText {
			id: textLevel;
						
			anchors.verticalCenter: parent.verticalCenter;

			text: tr("Уровень:");
			color: utils.colors.textColor;
		}
		Chooser {
			id: levelChooser;     
			
			anchors.right: parent.right;
			
			backgroundVisible: false;
			textColor: utils.colors.textColor;
			focusTextColor: utils.colors.focusText;
			highlightColor: activeFocus ? utils.colors.focusBackground : utils.colors.textColor;

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
				utils.levelItems.forEach(function (item) {
					model.append( { text: tr(item.title)} );
				});
			}
		}
	}

	Button {
		id: buttonOK;

		anchors.bottom: parent.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;

		text: tr("Сохранить");
		color: activeFocus ? utils.colors.focusBackground : utils.colors.background;
		textColor: activeFocus ? utils.colors.focusText : utils.colors.textColor;
		borderColor: textColor;
		borderWidth: 2;

		onSelectPressed: {
			if(name.text == "") {
				name.placeholderColor = utils.colors.error;
				name.placeholder = tr("Не введено имя!");
				name.setFocus();
				return;
			}
			if((birthday.text.length < 4) || (birthday.text < 1900) || (birthday.text > utils.currentDate.getFullYear())) {
				birthday.placeholderColor = utils.colors.error;
				birthday.placeholder = tr("Неверно введен год рождения!");
				birthday.text = "";
				birthday.setFocus();
				return;
			}
			save("user", { name: name.text, birthday: birthday.text, gender: genderChooser.currentIndex, level: levelChooser.currentIndex });
				
			nameText.update(name.text);
			menu.appendAll();
			menu.setFocus();
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
			buttonClose.setFocus();
		}
	}
	onCompleted: {
		this.loadUser();
	}

	function loadUser() {
		var user;
		if(user = load("user")) {
			name.text = user.name;
			birthday.text = user.birthday;
			genderChooser.currentIndex = user.gender;
			levelChooser.currentIndex = user.level;
		}
		else {
			name.text = "";
			birthday.text = "";
			genderChooser.currentIndex = 0;
			levelChooser.currentIndex = 0;
		}
	}
}