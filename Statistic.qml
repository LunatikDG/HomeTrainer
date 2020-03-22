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
        text: tr("Статистика");
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
        anchors.topMargin: engine.margin;
        color: engine.colors.textColor;
    }
    BodyText {
        id: textAge;
        anchors.top: textName.bottom;
        anchors.topMargin: engine.margin;
        color: engine.colors.textColor;
    }
    BodyText {
        id: textIndex;
        anchors.top: textAge.bottom;
        anchors.topMargin: engine.margin;
        color: engine.colors.textColor;
    }
    BodyText {
        id: textDays;
        anchors.top: textIndex.bottom;
        anchors.topMargin: engine.margin;
        color: engine.colors.textColor;
    }
    BodyText {
        id: textTrainings;
        anchors.top: textDays.bottom;
        anchors.topMargin: engine.margin;
        color: engine.colors.textColor;
    }
    BodyText {
        id: textExercises;
        anchors.top: textTrainings.bottom;
        anchors.topMargin: engine.margin;
        color: engine.colors.textColor;
    }
    BodyText {
        id: textExercisesByDay;
        anchors.top: textExercises.bottom;
        anchors.topMargin: engine.margin;
        color: engine.colors.textColor;
    }
    BodyText {
        id: textLastDate;
        anchors.top: textExercisesByDay.bottom;
        anchors.topMargin: engine.margin;
        color: engine.colors.textColor;
    }

    Button {
        id: buttonClear;

        anchors.bottom: parent.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;

        text: tr("Сбросить");
        color: activeFocus ? engine.colors.focusBackground : engine.colors.background;
        textColor: activeFocus ? engine.colors.focusText : engine.colors.textColor;
        borderColor: textColor;
        borderWidth: 2;

        onSelectPressed: {
            engine.resetResults();
            parent.loadResults();
            parent.closed();
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

            textName.text = tr("Имя: ") + engine.user.name;
            textAge.text = tr("Возраст: ~") + engine.getAge();
            textIndex.text = tr("Индекс массы тела: ") + engine.indexKetle(true);
            
            this.loadResults();
        }
    }

    function loadResults() {        
        textDays.text = tr("Количество дней: ") + engine.results.days;
        textTrainings.text = tr("Завершено тренировок: ") + engine.results.trainings;
        textExercises.text = tr("Выполнено упражнений: ") + engine.results.exercises;
        textExercisesByDay.text = tr("Среднее количество упражений в день: ") + Math.floor(engine.results.exercises / (engine.results.days == 0 ? 1 : engine.results.days));
        textLastDate.text = tr("Последняя тренировка: ") + engine.results.lastDate;
    }
}