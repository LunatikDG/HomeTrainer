// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

import "Sidebar.qml";
import "Profile.qml";
import "Training.qml";
import "Statistic.qml";

import "Exercise.qml";

import "controls/Button.qml";
import "controls/Edit.qml";
import "controls/Chooser.qml";

import "js/utils.js" as utils;

Application {
	id: hometrainer;

	color: utils.colors.background;

	Sidebar { 
		id: sidebar;
		anchors.left: mainWindow.left;
		anchors.top: mainWindow.top;
		anchors.bottom: mainWindow.bottom;
		width: utils.menuWidth;
		color: utils.colors.backgroundSidebar;
	}
	
	Rectangle {
		id: container;

		anchors.left: sidebar.right;
		anchors.top: mainWindow.top;
		anchors.right: mainWindow.right;
		anchors.bottom: mainWindow.bottom;
		anchors.margins: 2*utils.margin;

		color: parent.color;

		Profile { 
			id: profile;
			anchors.fill: parent;			
			color: parent.color;
			property var tag: "profile";
		}
		Training { 
			id: training;
			anchors.fill: parent;
			color: parent.color;
			property var tag: "training";
		}
		Statistic { 
			id: statistic;
			anchors.fill: parent;
			color: parent.color;
			property var tag: "statistic";
		}

		Exercise { 
			id: exercise;
			anchors.fill: parent;
			color: parent.color;
			property var tag: "exercise";
		}

		function showChild(index, withFocus) {	
			for(var i = 0; i < this.children.length; i++) {
				this.children[i].visible = (i == index);
			}
			if(withFocus)
				this.children[index].setFocus();
		}
		function showChildByTag(tag, withFocus) {
			for(var i = 0; i < this.children.length; i++) {
				if(this.children[i].tag != tag)
					this.children[i].visible = false;
				else {
					this.children[i].visible = true;
					if(withFocus)
						this.children[i].setFocus();
				}				
			}
		}
		
		onCompleted: {
			this.showChildByTag("profile", false);
		}
	}	
}
