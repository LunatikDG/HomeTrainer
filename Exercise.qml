// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {

    property bool showButtonNext: false;
    TitleText {
		id: header;
		color: utils.colors.headerText;
		text: tr("Упражнение");
	}
	Button {
		id: buttonBack;

		anchors.right: parent.right;
		width: height;

		text: "<";
		borderWidth: 2;
		color: activeFocus ? utils.colors.focusBackground : utils.colors.background;
		textColor: activeFocus ? utils.colors.focusText : utils.colors.textColor;
		borderColor: textColor;
		radius: 10;

		onSelectPressed: {
			container.showChildByTag("training", true);
		}
		onKeyPressed: {		
			if (key == "Up" || key == "Down") {
				task.setFocus();
				return true;
			}				
		}
	}
    
    SubheadText {
		id: title;
		anchors.top: header.bottom;
		anchors.topMargin: 2*utils.margin;
		color: utils.colors.textColor;		
	}
    BodyText {
		id: description;

		anchors.top: title.bottom;
        anchors.topMargin: utils.margin;
        
		color: utils.colors.textColor;		
	}

    Image {
		id: image;

		anchors.top: description.bottom;
        anchors.bottom: task.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.topMargin: utils.margin;
        anchors.bottomMargin: utils.margin;

		fillMode: PreserveAspectFit;
    }

    Rectangle {
        id: task;

        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: buttonOk.height;

        color: utils.colors.taskBackground;
        borderWidth: 2;
        borderColor: utils.colors.focusText;

        Button {
            id: buttonStart;

            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter;
            visible: false;

            text: tr("Старт");
            borderWidth: 2;
            color: activeFocus ? utils.colors.focusBackground : parent.color;
            textColor: activeFocus ? utils.colors.focusText : utils.colors.textColor;
            borderColor: utils.colors.focusText;

            onSelectPressed: {
                taskTimer.running ^= true;  
                this.text = taskTimer.running ? tr("Пауза") : tr("Старт");              
            }
            onKeyPressed: {		
                if (key == "Left" || key == "Right") {
                    if(buttonOk.visible)
                        buttonOk.setFocus();
                    else
                        buttonNext.setFocus();
                    return true;
                }				
            }
        }

        TitleText {
            id: taskText;            
            anchors.centerIn: parent;        
            color: utils.colors.textColor;  

            property int seconds;         		
        }

        Timer {
            id: taskTimer;

            interval: 1000;
            repeat: true;
            running: false;

            onTriggered: {
                if(--this.taskText.seconds < 0) {
                    this.running = false;
                    buttonStart.text = tr("Старт");  
                    return;
                }
                this.taskText.text = utils.timeToString(this.taskText.seconds);
            }
        }

        Button {
            id: buttonOk; 
            visible: !parent.parent.showButtonNext;

            anchors.right: parent.right;
            anchors.verticalCenter: parent.verticalCenter;

            text: tr("Выполнено");
            color: activeFocus ? utils.colors.focusBackground : parent.color;
            textColor: activeFocus ? utils.colors.focusText : utils.colors.textColor;
            borderColor: utils.colors.focusText;
            borderWidth: 2;

            onSelectPressed: {
                parent.saveResults();
               
                container.showChildByTag("training", true);
            }

            onKeyPressed: {		
                if (key == "Left" || key == "Right") {
                    if(buttonStart.visible)
                        buttonStart.setFocus();
                    return true;
                }		
            }
        }
        Button {
            id: buttonNext;
            visible: parent.parent.showButtonNext; 

            anchors.right: parent.right;
            anchors.verticalCenter: parent.verticalCenter;

            color: activeFocus ? utils.colors.focusBackground : parent.color;
            textColor: activeFocus ? utils.colors.focusText : utils.colors.textColor;
            borderColor: utils.colors.focusText;
            borderWidth: 2;

            onSelectPressed: {                
                parent.saveResults();

                taskTimer.running = false;
                buttonStart.text = tr("Старт");  
                training.nextExercise();
            }

            onKeyPressed: {		
                if (key == "Left" || key == "Right") {
                    if(buttonStart.visible)
                        buttonStart.setFocus();
                    return true;
                }		
            }
        }

        onKeyPressed: {		
            if (key == "Up" || key == "Down") {
                buttonBack.setFocus();
                return true;
            }				
        }

        function saveResults() {
            var results;
            if(results = load("results")) {
                results.exercises++;
            }
            else {
                results = { days: 0, trainings: 0, exercises: 1, lastDate: "01.01.1900" };
            }
            save("results", results);
        }
    }  

    onActiveFocusChanged: {  
        this.taskTimer.running = false;
        this.buttonStart.text = tr("Старт");  
		if(this.activeFocus) {
            this.buttonNext.text = tr("Следующее");
            this.buttonBack.setFocus();
        }
	}

    function setExerciseData(data) {
        this.title.text = data.title;
        this.description.text = data.description;
        this.image.source = utils.resourcesPath + "exercises/" + data.image;
        if(data.withTimer) {
            this.taskText.seconds = data.times;
            this.taskText.text = utils.timeToString(utils.calculateTimes(data.times, load("user")));
            this.buttonStart.visible = true;
        }
        else {
            this.taskText.text = "Количество повторений: " + utils.calculateTimes(data.times, load("user"));
            this.buttonStart.visible = false;
        }
    }
    function showButtonFinish(){
        this.buttonNext.text = tr("Завершить");
    }
    
}