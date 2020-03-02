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
		text: tr("Статистика");
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
			menu.setFocus();
		}
		onKeyPressed: {		
			if (key == "Up" || key == "Down") {
				buttonClear.setFocus();
				return true;
			}				
		}
	}

	BodyText {
		id: textName;
		anchors.top: header.bottom;
		anchors.topMargin: 2*utils.margin;
		color: utils.colors.textColor;
	}
	BodyText {
		id: textAge;
		anchors.top: textName.bottom;
		anchors.topMargin: 2*utils.margin;
		color: utils.colors.textColor;
	}
	BodyText {
		id: textDays;
		anchors.top: textAge.bottom;
		anchors.topMargin: 2*utils.margin;
		color: utils.colors.textColor;
	}
	BodyText {
		id: textTrainings;
		anchors.top: textDays.bottom;
		anchors.topMargin: 2*utils.margin;
		color: utils.colors.textColor;
	}
	BodyText {
		id: textExercises;
		anchors.top: textTrainings.bottom;
		anchors.topMargin: 2*utils.margin;
		color: utils.colors.textColor;
	}
	BodyText {
		id: textExercisesByDay;
		anchors.top: textExercises.bottom;
		anchors.topMargin: 2*utils.margin;
		color: utils.colors.textColor;
	}
	BodyText {
		id: textLastDate;
		anchors.top: textExercisesByDay.bottom;
		anchors.topMargin: 2*utils.margin;
		color: utils.colors.textColor;
	}

	Button {
		id: buttonClear;

		anchors.bottom: parent.bottom;
		anchors.horizontalCenter: parent.horizontalCenter;

		text: tr("Сбросить");
		color: activeFocus ? utils.colors.focusBackground : utils.colors.background;
		textColor: activeFocus ? utils.colors.focusText : utils.colors.textColor;
		borderColor: textColor;
		borderWidth: 2;

		onSelectPressed: {
			save("results", { days: 0, trainings: 0, exercises: 0, lastDate: "01.01.1900" });
			parent.loadResults();
			menu.setFocus();
		}
		onKeyPressed: {		
			if (key == "Up" || key == "Down") {
				buttonClose.setFocus();
            	return true;
			}				
		}
	}

	onActiveFocusChanged: {
		if(this.activeFocus) {
			buttonClose.setFocus();

			textName.text = tr("Имя: ");
			textAge.text = tr("Возраст: ");
			
			var data;
			if(data = load("user")) {
				textName.text += data.name;
				textAge.text += "~" + utils.calculateAge(data.birthday);
			}
			this.loadResults();
		}
	}
	onCompleted: {		
	}

	function loadResults() {
		
		textDays.text = tr("Количество дней: ");
		textTrainings.text = tr("Завершено тренировок: ");
		textExercises.text = tr("Выполнено упражнений: ");
		textExercisesByDay.text = tr("Среднее количество упражений в день: ");
		textLastDate.text = tr("Последняя тренировка: ");

		var data;

		if(data = load("results")) {
			textDays.text += data.days;
			textTrainings.text += data.trainings;
			textExercises.text += data.exercises;
			textExercisesByDay.text += Math.floor(data.exercises / (data.days == 0 ? 1 : data.days));
			textLastDate.text += data.lastDate;
		}
		else {
			textDays.text += 0;
			textTrainings.text += 0;
			textExercises.text += 0;
			textExercisesByDay.text += 0;
			textLastDate.text += "01.01.1900";
		}
	}
}