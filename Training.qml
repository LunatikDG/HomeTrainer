// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {

    signal exerciseStarted(index);
    signal trainingStarted;

    TitleText {
        id: header;
        color: engine.colors.headerText;
        text: tr("Тренировка");
    }
    
    BodyText {
        id: textTraining;

        anchors.top: header.bottom;
        anchors.topMargin: engine.margin;

        text: tr("Для начала тенировки нажмите \"Старт\"");
        color: engine.colors.textColor;
    }
    Button {
        id: buttonStart; 

        anchors.top: textTraining.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.topMargin: engine.margin;

        text: tr("Старт");
        color: activeFocus ? engine.colors.focusBackground : engine.colors.background;
        textColor: activeFocus ? engine.colors.focusText : engine.colors.textColor;
        borderColor: textColor;
        borderWidth: 2;

        onSelectPressed: {
            parent.trainingStarted();
        }

        onKeyPressed: {        
            if (key == "Up") {
                buttonSelect.setFocus();
                return true;
            }
            if (key == "Down") {
                exerciseChooser.setFocus();                
                return true;
            }            
        }
    }

    BodyText {
        id: textExercise;
                        
        anchors.top: buttonStart.bottom;
        anchors.left: parent.left; 
        anchors.topMargin: engine.margin;

        text: tr("Выбрать одно упражнение");
        color: engine.colors.textColor;
    }
    Chooser {
        id: exerciseChooser;     
            
        anchors.top: textExercise.bottom;
        anchors.left: parent.left;        
        anchors.right: parent.right;  
        anchors.topMargin: engine.margin;
            
        backgroundVisible: false;
        textColor: engine.colors.textColor;
        focusTextColor: engine.colors.focusText;
        highlightColor: activeFocus ? engine.colors.focusBackground : engine.colors.textColor;

        model: ListModel { }

        onKeyPressed: {        
            if (key == "Up") {
                buttonStart.setFocus();
                return true;
            }
            if (key == "Down") {
                buttonSelect.setFocus();
                return true;
            }                
        }
        
        onCompleted: {        
            engine.loadExerciseList(this);
        }
    }
    Button {
        id: buttonSelect; 

        anchors.top: exerciseChooser.bottom;
        anchors.right: parent.right;  
        anchors.topMargin: engine.margin;

        text: tr("Выполнить");
        color: activeFocus ? engine.colors.focusBackground : engine.colors.background;
        textColor: activeFocus ? engine.colors.focusText : engine.colors.textColor;
        borderColor: textColor;
        borderWidth: 2;

        onSelectPressed: {
            parent.exerciseStarted(exerciseChooser.currentIndex);
        }

        onKeyPressed: {        
            if (key == "Up") {
                exerciseChooser.setFocus();
                return true;
            }
            if (key == "Down") {
                buttonStart.setFocus();
                return true;
            }            
        }
    }

    onActiveFocusChanged: {
        if(this.activeFocus) {
            exerciseChooser.currentIndex = 0;
            buttonStart.setFocus();
        }
    }
}