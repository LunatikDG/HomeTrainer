// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {

	property int exerciseIndex;

    TitleText {
		id: header;
		color: utils.colors.headerText;
		text: tr("Тренировка");
	}
	Button {
		id: buttonClose;

		anchors.right: parent.right;
		width: height;

		text: "X";
		color: activeFocus ? utils.colors.focusBackground : utils.colors.background;
		textColor: activeFocus ? utils.colors.focusText : utils.colors.textColor;
		borderColor: textColor;
		borderWidth: 2;
		radius: 10;

		onSelectPressed: {
			menu.setFocus();
		}
		onKeyPressed: {		
			if (key == "Up") {
				buttonSelect.setFocus();
				return true;
			}
			if (key == "Down") {
				buttonStart.setFocus();
				return true;
			}
		}
	}
	
	BodyText {
		id: textTraining;

		anchors.top: header.bottom;
		anchors.topMargin: 2*utils.margin;

		text: tr("Для начала тенировки нажмите \"Старт\"");
		color: utils.colors.textColor;
	}
	Button {
		id: buttonStart; 

		anchors.top: textTraining.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;
		anchors.topMargin: 2*utils.margin;

		text: tr("Старт");
		color: activeFocus ? utils.colors.focusBackground : utils.colors.background;
		textColor: activeFocus ? utils.colors.focusText : utils.colors.textColor;
		borderColor: textColor;
		borderWidth: 2;

		onSelectPressed: {
			parent.exerciseIndex = 0;
			exercise.showButtonNext = true;
			parent.nextExercise();
			container.showChildByTag("exercise", true);
		}

		onKeyPressed: {		
			if (key == "Up") {
				buttonClose.setFocus();
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
		anchors.topMargin: 2*utils.margin;

		text: tr("Выбрать упражнение");
		color: utils.colors.textColor;
	}
	Chooser {
		id: exerciseChooser;     
			
		anchors.top: textExercise.bottom;
		anchors.left: parent.left;        
		anchors.right: parent.right;  
		anchors.topMargin: 2*utils.margin;
			
		backgroundVisible: false;
		textColor: utils.colors.textColor;
		focusTextColor: utils.colors.focusText;
		highlightColor: activeFocus ? utils.colors.focusBackground : utils.colors.textColor;

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
			utils.exerciseItems.forEach(function (item) {
				model.append( { text: tr(item.title)} );
			});	
		}
	}
	Button {
		id: buttonSelect; 

		anchors.top: exerciseChooser.bottom;
		anchors.right: parent.right;  
		anchors.topMargin: 2*utils.margin;

		text: tr("Выполнить");
		color: activeFocus ? utils.colors.focusBackground : utils.colors.background;
		textColor: activeFocus ? utils.colors.focusText : utils.colors.textColor;
		borderColor: textColor;
		borderWidth: 2;

		onSelectPressed: {
			exercise.showButtonNext = false;
			exercise.setExerciseData(utils.exerciseItems[exerciseChooser.currentIndex]);
			container.showChildByTag("exercise", true);
		}

		onKeyPressed: {		
			if (key == "Up") {
				exerciseChooser.setFocus();
				return true;
			}
			if (key == "Down") {
				buttonClose.setFocus();
				return true;
			}			
		}
	}

	onActiveFocusChanged: {
		if(this.activeFocus)
			buttonClose.setFocus();
	}

	function nextExercise() {
		if(this.exerciseIndex >= utils.exerciseItems.length) {
			var results;
            if(results = load("results")) {
                results.trainings++;
                
				if(utils.dateToString(utils.currentDate) != results.lastDate) {
					results.days++;
					results.lastDate = utils.dateToString(utils.currentDate);
				}				
            }
            else {
                results = { days: 1, trainings: 1, exercises: utils.exerciseItems.length, lastDate: utils.dateToString(utils.currentDate) };
            }
            save("results", results);

			container.showChildByTag("training", true);
			return;
		}
		if(this.exerciseIndex == utils.exerciseItems.length - 1) {
			exercise.showButtonFinish();
		}
		exercise.setExerciseData(utils.exerciseItems[this.exerciseIndex++]);
	}
}