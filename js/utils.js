// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

this.appPath = "apps/hometrainer/";
this.resourcesPath = this.appPath + "resources/";

this.colors = {
	"background" : "#333",
	"backgroundSidebar" : "#fd5",
	"focusText": "#891812",
	"focusBackground": "#fd5",
	"userName": "#000",
	"headerText": "#fd5",
	"textColor": "#fff",
	"taskBackground": "#000",
	"error": "#f00",
	"placeholder": "#999"
};
this.menuWidth = 256;
this.menuItemHeight = 64;
this.margin = 16;

this.editCharsNum = "0123456789"; 
this.currentDate = new Date();

this.dateToString = (date) => {
	return (date.getDate() < 10 ? "0" : "") + date.getDate() + "." + (date.getMonth() + 1 < 10 ? "0" : "") + (date.getMonth() + 1) + "." + date.getFullYear();
};
this.timeToString = (time) => {
	var minutes = Math.floor(time / 60);
    var seconds = time % 60;
	return (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
};
this.calculateAge = (birthday) => {
	return this.currentDate.getFullYear() - parseInt(birthday);
};
this.calculateTimes = (times, user) => {
	var result = times;
	result *= this.genderItems[user.gender].level * this.levelItems[user.level].level;
	var age = this.calculateAge(user.birthday);
	if(age < 15 || age > 50) {
		result *= 0.7;
	}
	else if (age > 25) {
		result *= 0.9;
	} 
	else if (age > 35) {
		result *= 0.8;
	}
	return Math.floor(result); 
};

this.menuItems = [ 
	{ title: "Анкета", tag: "profile" }, 
	{ title: "Тренировка", tag: "training" }, 
	{ title: "Статистика", tag: "statistic" }
];
this.genderItems = [ 
	{ title: "Мужчина", level: 1 }, 
	{ title: "Женщина", level: 0.8 } 
];
this.levelItems = [ 
	{ title: "Новичок", level: 1 }, 
	{ title: "Продвинутый", level: 1.25 }, 
	{ title: "Мастер", level: 1.5 } 
];

this.exerciseItems = [ 
	{ title: "Прыжки", withTimer: true, times: 30, image: "pryzhki.png", 
		description: "Исходное положение: ноги вместе, руки по швам.\nДелаем прыжок вверх, расставляя ноги на ширине плеч и поднимая руки над головой." 
	}, 
	{ title: "Отжимания от пола", withTimer: false, times: 10, image: "otzhimania.png", 
		description: "Исходное положение: упор лежа.\nСгибаем руки, пока не дотронемся грудью пола, и возвращаемся в исходное положение."  
	}, 
	{ title: "Упражнение для пресса", withTimer: false, times: 15, image: "uprazhnenie_dlya_pressa.png",
		description: "Исходное положение: лежа на спине, ноги согнуты в коленях, руки вытянуты вперед.\nПриподнимаем тело, отрывая спину от пола." 
	}, 
	{ title: "Выпады", withTimer: false, times: 20, image: "vypady.png", 
		description: "Исходное положение: ноги на ширине плеч, руки на талии.\nДелаем одной ногой выпад вперед, и возвращаемся в исходное положение.\nЗатем другой ногой делаем выпад." 
	}, 
	{ title: "Планка", withTimer: true, times: 30, image: "planka.png", 
		description: "Исходное положение: упор лежа, локти согнуты." 
	}, 
	{ title: "Бег на месте", withTimer: true, times: 30, image: "beg_na_meste.png", 
		description: "Исходное положение: руки по швам.\nПоочередно поднимаем ноги для создания имитации пробежки,\nприземляться и отталкиваться важно от носков." 
	}, 
	{ title: "Приседания", withTimer: false, times: 16, image: "prisedania.png", 
		description: "Исходное положение: руки по швам.\nДелаем присед с одновременным поднятием рук до горизонтального положения." 
	} 
];
