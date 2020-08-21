// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

//main
this.showByTag = (children, tag, withFocus) => {
    for(var i = 0; i < children.length; i++) {
        if(children[i].tag != tag)
            children[i].visible = false;
        else {
            children[i].visible = true;
            if(withFocus)
                children[i].setFocus();
        }                
    }
}

//sidebar
this.clearMenu = (menu) => {
    menu.model.reset();
    var count = this.menuItems.length;
    menu.model.append( { title: tr(this.menuItems[0].title), target: tr(this.menuItems[0].target) } );
    menu.model.append( { title: tr(this.menuItems[count - 1].title), target: tr(this.menuItems[count - 1].target) } );
}
this.fillMenu = (menu) => {
    if(menu.model.count <= 3) {
        if(menu.model.count == 0)
            this.clearMenu(menu);
        var model = menu.model;
        var position = 1;
        this.menuItems.slice(1, this.menuItems.length - 1).forEach(function (item) {        
            model.insert(position++, { title: tr(item.title), target: tr(item.target) } );
        });
    }
}
this.updateSidebar = (nameText, menu) => {        
    nameText.text = this.user.name;
    if(nameText.text == "")
        this.clearMenu(menu);
    else
        this.fillMenu(menu);
}

//authorization
this.loadUserList = (list) => {
    var users = this.loadNames();
    list.model.reset();
    if(users) {
        for(var i = 0; i < users.length; i++)
            list.model.append( { name: tr(users[i]) } );
        return users.length;
    }
    return 0;
}

//profile
this.loadLevelList = (list) => {
    var model = list.model;
    this.levelItems.forEach(function (item) {
        model.append( { text: tr(item.title)} );
    });
}
this.loadGenderList = (list) => {
    var model = list.model;
    this.genderItems.forEach(function (item) {
        model.append( { text: tr(item.title)} );
    });
}

//training
this.loadExerciseList = (list) => {
    var model = list.model;
    this.exerciseItems.forEach(function (item) {
        model.append( { text: tr(item.title)} );
    });    
}

//notificator
this.isNeedTraining = () => {
    return this.dateToString(new Date()) != this.results.lastDate;
}
this.showNotify = (type) => {
    if(type in this.notifications) {
        if(Array.isArray(this.notifications[type])) {
            var index = Math.floor(Math.random() * this.notifications[type].length);
            notificator.text = tr(this.notifications[type][index]);
        }
        else
            notificator.text = tr(this.notifications[type]);
        notificator.addNotify();
    }
}

//keyboard
this.validateText = (text, validateChars) => {
    if(validateChars.length === 0)
        return text;
    var regex = new RegExp("[^" + validateChars + "]", "gi");
    return text.replace(regex, "");
}

//constants
this.appPath = "apps/HomeTrainer/";
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
this.margin = 32;
this.marginHalf = this.margin / 2;
this.logoAuthHeight = 128;
this.userButtonWidth = 300;
this.teamWidth = 160;
this.teamHeight = this.teamWidth * 3 / 2;
this.rowWidth = 550;
this.editWidth = 350;

this.editCharsNum = "0123456789";

//utils
this.dateToString = (date) => {
    return (date.getDate() < 10 ? "0" : "") + date.getDate() + "." + (date.getMonth() + 1 < 10 ? "0" : "") + (date.getMonth() + 1) + "." + date.getFullYear();
};
this.timeToString = (time) => {
    var minutes = Math.floor(time / 60);
    var seconds = time % 60;
    return (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
};
this.getAge = () => {
    return (new Date().getFullYear()) - parseInt(this.user.birthday);
};
this.calculateTimes = (times) => {
    var result = times / (1 + Math.abs(this.indexKetle(false) / 22 - 1));
    result *= this.genderItems[this.user.gender].level * this.levelItems[this.user.level].level;
    var age = this.getAge();
    if(age < 15 || age > 50) {
        result *= 0.7;
    }
    else if (age > 25) {
        result *= 0.9;
    }
    else if (age > 35) {
        result *= 0.8;
    }
    return Math.round(result); 
};
this.indexKetle = (withDescription) => {
    var index = Math.round(100000 * this.user.weight / (this.user.height * this.user.height)) / 10;
    if(!withDescription)
        return index;
    if(index < 18.5)
        return index + " - дефицит массы тела";
    if(index <= 24.9)
        return index + " - нормальная масса тела";
    if(index <= 29.9)
        return index + " - избыточная масса тела (предожирение)";
    if(index <= 34.9)
        return index + " - ожирение I степени";
    if(index <= 39.9)
        return index + " - ожирение II степени";
    return index + " - ожирение III степени";
}

this.user;
this.results;

this.loadNames = () => {
    var users;
    if(!(users = load("users")))
        return null;
    var names = [ ];
    users.forEach(function (item) {
        names.push(tr(item.name));
    });    
    return names;
};

this.newUser = () => {
    this.user = { name: "", birthday: "", height: "", weight: "", gender: 0, level: 0 };
}
this.loadUser = (name) => {
    var users;
    if(users = load("users"))
        for(var i = 0; i < users.length; i++)
            if(name == users[i].name) {
                this.user = users[i];
                return;
            }
    this.newUser();                    
};
this.saveUser = (name, birthday, height, weight, gender, level) => {
    if(name == "")
        return "emptyName";
    if(this.isProfileBusy(name))
        return "profileBusy";
    if(birthday == "")
        return "emptyBirthday";
    if(birthday.length < 4 || birthday < 1900 || birthday > (new Date().getFullYear()))
        return "invalidBirthday";
    if(height == "")
        return "emptyHeight";
    if(height < 70 || height > 300)
        return "invalidHeight";    
    if(weight == "")
        return "emptyWeight";
    if(weight < 30 || weight > 300)
        return "invalidWeight";
    
    var oldName = this.user.name;
    this.user = { name: name, birthday: birthday, height: height, weight: weight, gender: gender, level: level };

    var users;
    if(!(users = load("users"))) {
        users = [ ];        
        users.push(this.user);
    }        
    else {
        for(var i = 0; i < users.length && users[i].name != oldName; i++);
        if(i < users.length)
            users.splice(i, 1, this.user);
        else
            users.push(this.user);
    }
    save("users", users);

    this.results.name = name;
    this.saveResults(oldName);

    return "success";
};

this.isProfileBusy = (name) => {
    if(name == this.user.name)
        return false;

    var users;
    
    if(!(users = load("users")))        
        return false;        
    
    for(var i = 0; i < users.length && users[i].name != name; i++);
    
    return i < users.length;
}

this.newResults = (name) => {
    this.results = { name: name, days: 0, trainings: 0, exercises: 0, lastDate: "01.01.1900" };
}
this.resetResults = () => {
    var name = this.results.name;
    this.newResults(name);

    this.saveResults(name);
};
this.saveResults = (name) => {
    var res;
    if(!(res = load("results"))) {
        res = [ ];
        res.push(this.results);
    }
    else {
        for(var i = 0; i < res.length && res[i].name != name; i++);
        if(i < res.length)
            res.splice(i, 1, this.results);
        else
            res.push(this.results);
    }
    save("results", res);
};
this.loadResults = (name) => {
    var res;    
    if(res = load("results"))
        for(var i = 0; i < res.length; i++)
            if(name == res[i].name) {
                this.results = res[i];
                return;
            }    
    this.newResults(name);
};

this.addExercise = () => {
    this.results.exercises++;

    this.saveResults(this.results.name);
};

this.addTraining = () => {
    if(this.dateToString(new Date()) != this.results.lastDate)
        this.results.days++;    
    
    this.results.lastDate = this.dateToString(new Date());
    this.results.trainings++;
    
    this.saveResults(this.results.name);

    this.showNotify("doneTraining");
};

this.menuItems;
this.genderItems;
this.levelItems;
this.exerciseItems;
this.notifications;
this.videos;
this.loadData = (data) => {
    this.menuItems = data["menu"];
    this.genderItems = data["genders"];
    this.levelItems = data["levels"];
    this.exerciseItems = data["exercises"];
    this.notifications = data["notifications"];
    this.videos = data["videos"];
}
