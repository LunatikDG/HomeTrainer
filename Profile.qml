// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {

    signal userDataSaved;
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
                nameEdit.setFocus();
                return true;
            }                
        }
    }

    Item {
        anchors.top: header.bottom;
        anchors.topMargin: engine.margin;

        width: engine.rowWidth;

        BodyText {                        
            anchors.verticalCenter: nameEdit.verticalCenter;

            text: tr("Имя:");
            color: engine.colors.textColor;
        }
        
        Edit {
            id: nameEdit;
            
            anchors.right: parent.right;

            width: engine.editWidth;

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
                    birthdayEdit.setFocus();
                    return true;
                }        
            }            
        }
    }    
    Item {
        anchors.top: nameEdit.bottom;
        anchors.topMargin: engine.margin;

        width: engine.rowWidth;

        BodyText {                        
            anchors.verticalCenter: birthdayEdit.verticalCenter;

            text: tr("Год рождения:");
            color: engine.colors.textColor;
        }

        Edit {
            id: birthdayEdit;

            anchors.right: parent.right;

            width: engine.editWidth;

            maxLen: 4;
            validateChars: engine.editCharsNum;
            textColor: engine.colors.focusText;
            cursorColor: engine.colors.focusText;
            backColor: activeFocus ? engine.colors.focusBackground : engine.colors.textColor;
            borderColor: engine.colors.focusText;
            borderRadius: 0;

            onKeyPressed: {
                if (key == "Up") {
                    nameEdit.setFocus();
                    return true;
                }
                if (key == "Down") {
                    heightEdit.setFocus();
                    return true;
                }                                        
            }
        }
    }
    Item {
        anchors.top: birthdayEdit.bottom;
        anchors.topMargin: engine.margin;

        width: engine.rowWidth;

        BodyText {                        
            anchors.verticalCenter: heightEdit.verticalCenter;

            text: tr("Рост (см):");
            color: engine.colors.textColor;
        }

        Edit {
            id: heightEdit;

            anchors.right: parent.right;

            width: engine.editWidth;

            maxLen: 3;
            validateChars: engine.editCharsNum;
            textColor: engine.colors.focusText;
            cursorColor: engine.colors.focusText;
            backColor: activeFocus ? engine.colors.focusBackground : engine.colors.textColor;
            borderColor: engine.colors.focusText;
            borderRadius: 0;

            onKeyPressed: {
                if (key == "Up") {
                    birthdayEdit.setFocus();
                    return true;
                }
                if (key == "Down") {
                    weightEdit.setFocus();
                    return true;
                }                                        
            }
        }
    }
    Item {
        anchors.top: heightEdit.bottom;
        anchors.topMargin: engine.margin;

        width: engine.rowWidth;

        BodyText {                        
            anchors.verticalCenter: weightEdit.verticalCenter;

            text: tr("Вес (кг):");
            color: engine.colors.textColor;
        }

        Edit {
            id: weightEdit;

            anchors.right: parent.right;

            width: engine.editWidth;

            maxLen: 3;
            validateChars: engine.editCharsNum;
            textColor: engine.colors.focusText;
            cursorColor: engine.colors.focusText;
            backColor: activeFocus ? engine.colors.focusBackground : engine.colors.textColor;
            borderColor: engine.colors.focusText;
            borderRadius: 0;

            onKeyPressed: {
                if (key == "Up") {
                    heightEdit.setFocus();
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
        width: engine.rowWidth;

        anchors.top: weightEdit.bottom;
        anchors.left: parent.left;        
        anchors.topMargin: engine.margin;

        BodyText {
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
                    weightEdit.setFocus();
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
        width: engine.rowWidth;

        anchors.top: genderChooser.bottom;
        anchors.left: parent.left;        
        anchors.topMargin: engine.margin;

        BodyText {                    
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
            switch (engine.saveUser(nameEdit.text, birthdayEdit.text, heightEdit.text, weightEdit.text, genderChooser.currentIndex, levelChooser.currentIndex)) {
                case "emptyName":
                    nameEdit.placeholderColor = engine.colors.error;
                    nameEdit.placeholder = tr("Не введено имя!");
                    nameEdit.setFocus();    
                    break;
                case "profileBusy":
                    nameEdit.placeholderColor = engine.colors.error;
                    nameEdit.placeholder = tr("Профиль занят!");
                    nameEdit.text = "";
                    nameEdit.setFocus();    
                    break;
                case "emptyBirthday":
                    birthdayEdit.placeholderColor = engine.colors.error;
                    birthdayEdit.placeholder = tr("Не введен год рождения!");
                    birthdayEdit.text = "";
                    birthdayEdit.setFocus();
                    break;
                case "invalidBirthday":
                    birthdayEdit.placeholderColor = engine.colors.error;
                    birthdayEdit.placeholder = tr("Неверно введен год рождения!");
                    birthdayEdit.text = "";
                    birthdayEdit.setFocus();
                    break;
                case "emptyHeight":
                    heightEdit.placeholderColor = engine.colors.error;
                    heightEdit.placeholder = tr("Не указан рост!");
                    heightEdit.text = "";
                    heightEdit.setFocus();
                    break;
                case "invalidHeight":
                    heightEdit.placeholderColor = engine.colors.error;
                    heightEdit.placeholder = tr("Неверно указан рост!");
                    heightEdit.text = "";
                    heightEdit.setFocus();
                    break;
                case "emptyWeight":
                    weightEdit.placeholderColor = engine.colors.error;
                    weightEdit.placeholder = tr("Не указан вес!");
                    weightEdit.text = "";
                    weightEdit.setFocus();
                    break;
                case "invalidWeight":
                    weightEdit.placeholderColor = engine.colors.error;
                    weightEdit.placeholder = tr("Неверно указан вес!");
                    weightEdit.text = "";
                    weightEdit.setFocus();
                    break;
                case "success":
                    parent.userDataSaved();
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
            nameEdit.placeholder = tr("Введите имя");
            nameEdit.placeholderColor = engine.colors.placeholder;
            birthdayEdit.placeholder = tr("Введите год рождения");
            birthdayEdit.placeholderColor = engine.colors.placeholder;
            heightEdit.placeholder = tr("Укажите рост");
            heightEdit.placeholderColor = engine.colors.placeholder;
            weightEdit.placeholder = tr("Укажите вес");
            weightEdit.placeholderColor = engine.colors.placeholder;

            buttonClose.setFocus();
        }
    }

    function update() {
        this.nameEdit.text = engine.user.name;
        this.birthdayEdit.text = engine.user.birthday;
        this.heightEdit.text = engine.user.height;
        this.weightEdit.text = engine.user.weight;
        this.genderChooser.currentIndex = engine.user.gender;
        this.levelChooser.currentIndex = engine.user.level;    
    }
}
