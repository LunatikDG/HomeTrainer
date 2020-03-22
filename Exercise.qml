// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rectangle {

	signal closed;
	signal done;
	signal next;

	property bool showButtonNext: false;
	property bool showButtonFinish: false;

	TitleText {
		id: header;
		color: engine.colors.headerText;
		text: tr("Упражнение");
	}
	Button {
		id: buttonBack;

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
				task.setFocus();
				return true;
			}				
		}
	}
	
	SubheadText {
		id: title;
		anchors.top: header.bottom;
		anchors.topMargin: engine.margin;
		color: engine.colors.textColor;		
	}
	BodyText {
		id: description;

		anchors.top: title.bottom;
	anchors.topMargin: engine.marginHalf;
	anchors.left: parent.left;
	anchors.right: parent.right;
	
		color: engine.colors.textColor;	
	wrapMode: WordWrap;	
	}

	Image {
		id: image;

		anchors.top: description.bottom;
	anchors.bottom: task.top;
	anchors.left: parent.left;
	anchors.right: parent.right;
	anchors.topMargin: engine.marginHalf;
	anchors.bottomMargin: engine.marginHalf;

		fillMode: PreserveAspectFit;
	}

	Rectangle {
	id: task;

	anchors.bottom: parent.bottom;
	anchors.left: parent.left;
	anchors.right: parent.right;
	height: buttonOk.height;

	color: engine.colors.taskBackground;
	borderWidth: 2;
	borderColor: engine.colors.focusText;

	Button {
	id: buttonStart;

	anchors.left: parent.left;
	anchors.verticalCenter: parent.verticalCenter;
	visible: false;

	text: taskTimer.running ? tr("Пауза") : tr("Старт");
	borderWidth: 2;
	color: activeFocus ? engine.colors.focusBackground : parent.color;
	textColor: activeFocus ? engine.colors.focusText : engine.colors.textColor;
	borderColor: engine.colors.focusText;

	onSelectPressed: {
	taskTimer.running ^= true;	 
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
	
	ProgressBar {
	id: progress;

	property int maxProgress: 1;

	anchors.bottom: parent.bottom;
	anchors.bottomMargin: parent.borderWidth;
	anchors.left: buttonStart.right;
	anchors.right: buttonOk.left;

	visible: false;
	height: parent.height - 2*parent.borderWidth;
	color: parent.color;
	radius: 0;
	barColor: engine.colors.focusText;
	animationDuration: 1000;
	}

	TitleText {
	id: taskText;	
	anchors.centerIn: parent;	
	color: engine.colors.textColor;	   		
	}

	Timer {
	id: taskTimer;

	interval: 1000;
	repeat: true;
	running: false;

	property int seconds;

	onTriggered: {	
	if(--this.seconds < 0) {
	this.running = false;
	this.progress.visible = false;
	this.progress.progress = 0;
	return;
	}
	this.taskText.text = engine.timeToString(this.seconds);
	this.progress.progress =  1 - (this.seconds - 1) / this.progress.maxProgress;
	}
	}

	Button {
	id: buttonOk; 
	visible: !parent.parent.showButtonNext;

	anchors.right: parent.right;
	anchors.verticalCenter: parent.verticalCenter;

	text: tr("Выполнено");
	color: activeFocus ? engine.colors.focusBackground : parent.color;
	textColor: activeFocus ? engine.colors.focusText : engine.colors.textColor;
	borderColor: engine.colors.focusText;
	borderWidth: 2;

	onSelectPressed: {
	parent.parent.done();	   
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

	text: parent.parent.showButtonFinish ? tr("Завершить") : tr("Следующее");//tr("Следующее");
	color: activeFocus ? engine.colors.focusBackground : parent.color;
	textColor: activeFocus ? engine.colors.focusText : engine.colors.textColor;
	borderColor: engine.colors.focusText;
	borderWidth: 2;

	onSelectPressed: {	   
	taskTimer.running = false;
	this.progress.visible = false;
	this.progress.progress = 0;
	parent.parent.next();
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
	}

	onActiveFocusChanged: {
	this.taskTimer.running = false;
		if(this.activeFocus) {
	this.showButtonFinish = false;
	this.buttonBack.setFocus();
	}
	}

	function setExercise(index) {
	var data = engine.exerciseItems[index];
	this.title.text = data.title;
	this.description.text = data.description;
	this.image.source = engine.resourcesPath + "exercises/" + data.image;
	if(data.withTimer) {
	this.taskTimer.seconds = engine.calculateTimes(data.times);
	this.taskText.text = engine.timeToString(this.taskTimer.seconds);
	this.buttonStart.visible = true;
	this.progress.maxProgress = this.taskTimer.seconds;  
	this.progress.progress = 0;	
	this.progress.visible = true;
	}
	else {
	this.taskText.text = "Количество повторений: " + engine.calculateTimes(data.times);
	this.buttonStart.visible = false;
	this.progress.visible = false;
	}
	}
}