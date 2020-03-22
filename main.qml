// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "Sidebar.qml";
import "Profile.qml";
import "Training.qml";
import "About.qml";
import "Statistic.qml";

import "Exercise.qml";

import "Authorization.qml";

import "controls/Edit.qml";
import "controls/Button.qml";
import "controls/Chooser.qml";
import "controls/ProgressBar.qml";

import "js/engine.js" as engine;

Application {
	id: hometrainer;

	color: engine.colors.background;

	Resource {
		url: engine.resourcesPath + "data.json";
		onDataChanged: {
			engine.loadData(JSON.parse(this.data));
		}
	}

	Sidebar { 
		id: sidebar;
		anchors.left: mainWindow.left;
		anchors.top: mainWindow.top;
		anchors.bottom: mainWindow.bottom;
		width: engine.menuWidth;
		color: engine.colors.backgroundSidebar;

		onMenuSelected: {
			if(target == "exit") {
				authorization.visible = true;
				authorization.setFocus();
			}
			else
				engine.showByTag(container.children, target, true);
		}
	}
	
	Rectangle {
		id: container;

		anchors.left: sidebar.right;
		anchors.top: mainWindow.top;
		anchors.right: mainWindow.right;
		anchors.bottom: mainWindow.bottom;
		anchors.margins: engine.margin;

		color: parent.color;

		Profile { 
			id: profile;
			anchors.fill: parent;			
			color: parent.color;
			property var tag: "profile";

			onUserDataSaved: {
				sidebar.update();
			}
			onClosed: {
				sidebar.setFocus();
			}
		}
		Training { 
			id: training;
			anchors.fill: parent;
			color: parent.color;
			property var tag: "training";
			
			property int exerciseIndex;

			onClosed: {
				sidebar.setFocus();
			}
			onExerciseStarted: {
				exercise.showButtonNext = false;				
				exercise.setExercise(index);
				engine.showByTag(container.children, "exercise", true);
			}
			onTrainingStarted: {	
				exercise.showButtonNext = true;	
				this.exerciseIndex = 0;
				this.nextExercise();
				engine.showByTag(container.children, "exercise", true);
			}
			function nextExercise() {
				if(this.exerciseIndex >= engine.exerciseItems.length) {
					engine.addTraining();
					engine.showByTag(container.children, "training", true);
					return;
				}
				if(this.exerciseIndex == engine.exerciseItems.length - 1) {
					exercise.showButtonFinish = true;
				}
				exercise.setExercise(this.exerciseIndex++);
			}
		}		
		Statistic { 
			id: statistic;
			anchors.fill: parent;
			color: parent.color;
			property var tag: "statistic";
			onClosed: {
				sidebar.setFocus();
			}
		}
		About { 
			id: about;
			anchors.fill: parent;			
			color: parent.color;
			property var tag: "about";

			onClosed: {
				sidebar.setFocus();
			}
		}

		Exercise { 
			id: exercise;
			anchors.fill: parent;
			color: parent.color;
			property var tag: "exercise";

			onClosed: {
				engine.showByTag(container.children, "training", true);
			}
			onNext: {
				engine.addExercise();
				training.nextExercise();
			}
			onDone: {
				engine.addExercise();
				engine.showByTag(container.children, "training", true);
			}
		}
		
		onCompleted: {
			engine.showByTag(container.children, "profile", false);
		}
	}

	Authorization {
		id: authorization;

		anchors.fill: mainWindow;

		color: parent.color;

		onClosed: {
			viewsFinder.closeApp();
		}
		onNewSelected: {
			engine.newUser();
			engine.newResults("");

			sidebar.update();
			profile.update();
	
			engine.showByTag(container.children, "profile", true);
			this.visible = false;
		}
		onUserSelected: {
			engine.loadUser(name);
			engine.loadResults(name);

			sidebar.update();
			profile.update();
	
			engine.showByTag(container.children, "profile", false);
			sidebar.setFocus();
			this.visible = false;
		}
	}
	onActiveFocusChanged: {
		if(this.activeFocus) {
			authorization.visible = true;
			authorization.setFocus();
		}
	}
}
