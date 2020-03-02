// Copyright (c) 2020, Tochka nevozvrata
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

ListView {

	focus: true;

	model: ListModel { }

	delegate: Button { 
		text: tr(model.title);
		width: parent.width;
		textColor: utils.colors.focusText;
		color: utils.colors.backgroundSidebar;
		borderWidth: 2;
		borderColor: activeFocus ? utils.colors.focusText : utils.colors.backgroundSidebar;
	}

	onSelectPressed: {
		container.showChild(this.currentIndex, true);
	}

    onCompleted: {
		this.model.append( { title: tr(utils.menuItems[0].title) } );
		if(nameText.text != "") 
			this.appendAll();	
    }
	
	function appendAll() {
		if (this.model.count < 2) {			
			var model = this.model;
			utils.menuItems.slice(1).forEach(function (item) {
            	model.append( { title: tr(item.title) } );
        	});
		}				
	}
}

