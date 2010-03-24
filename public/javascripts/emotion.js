/**
 * TODO:
 * hover effect !! 
 * Change Log
 * 1.2
 * change view generation and simplify code
 */

Iyxzone.Emotion = {
  version: '1.2',

  author: ['高侠鸿','戴雨宸'],

	faces: [ '[惊吓]', '[晕]', '[流鼻涕]', '[挖鼻子]', '[鼓掌]', '[骷髅]', '[坏笑]', '[傲慢]', '[大哭]', '[砸头]', '[衰]', '[哭]', '[可爱]', '[冷汗]', '[抽烟]', '[擦汗]', '[亲亲]', '[糗]', '[吃惊]', '[左哼哼]', '[疑问]', '[惊恐]', '[睡觉]', '[皱眉头]', '[可怜]', '[打呵欠]', '[害羞]', '[花痴]', '[右哼哼]', '[囧]', '[大便]', '[咒骂]', '[贼笑]', '[嘘]', '[吐]', '[苦恼]', '[白眼]', '[流汗]', '[大笑]', '[羞]', '[撇嘴]', '[偷笑]', '[BS]', '[困]', '[火]', '[闭嘴]', '[抓狂]', '[强]', '[不行]', '[装酷]' ],

  facesCount: 50,

	facesPerPage: 32,

  Manager: {}

};

Object.extend(Iyxzone.Emotion.Manager, {

  currentField: null,

  currentLink: null,

	facesSingle : null,

	facePages: [],

  constructFacesTable: function(link, textField){
    if(textField == null) return;

    // I am a lazy boy... save constants to local variant
		var rows = Iyxzone.Emotion.rows;
		var myFaces = Iyxzone.Emotion.faces;
		var facesPerPage = Iyxzone.Emotion.facesPerPage;
		var facesCount = Iyxzone.Emotion.facesCount;
		var a, img, pageIndex = -1;

		this.facesSingle = new Element('div', {class:"emot-box drop-wrap"});

		for (var i =0; i < facesCount; i++){
			if (i % facesPerPage == 0){
				pageIndex++;
				this.facePages[pageIndex] = new Element('div', {class:"con"});
			}	
			a = new Element('a', {title: myFaces[i], href: 'javascript: void(0)'});
			img = new Element('img', {src: "/images/faces/"+ myFaces[i].slice(1,myFaces[i].length-1) +".gif",  alt: myFaces[i], index: i});
			a.appendChild(img);
			a.observe('click', function(e){
				var idx = parseInt(e.element().readAttribute('index'));
				this.currentField.value += myFaces[idx];
				this.toggleFaces(this.currentLink, this.currentField, e);
			}.bind(this));
			this.facePages[pageIndex].appendChild(a);
		}

		for(var i = 0; i < this.facePages.length; i++){
			var prev = new Element('a',{class:'prev', pageNum: i});
			if (i != 0){
				prev.observe('click',function(e){
          Event.stop(e);
          var el = e.element();
					var pageTo = parseInt(el.readAttribute('pageNum')) -1;
					this.facesSingle.appendChild(this.facePages[pageTo]);
					this.facesSingle.removeChild(el.up().up());
        }.bind(this));
			}else{
        prev.writeAttribute({class: 'first'});
        prev.observe('click', function(e){
          Event.stop(e);
        }.bind(this));
      }

			var next = new Element('a',{class:'next',pageNum: i});
			if (i != this.facePages.length - 1){
				next.observe('click',function(e){
          Event.stop(e);
          var el = e.element();
					var pageTo = parseInt(el.readAttribute("pageNum")) +1;
					this.facesSingle.appendChild(this.facePages[pageTo]);
					this.facesSingle.removeChild(el.up().up());
        }.bind(this));
			}else{
        next.writeAttribute({class: 'last'});
        next.observe('click', function(e){
          Event.stop(e);
        }.bind(this));
      }

			var foot = new Element('div', {class:'pager-simple foot'});
			var pagenum = new Element('span').update(i+1);
      foot.appendChild(prev);
      foot.appendChild(pagenum);
      foot.appendChild(next);
			this.facePages[i].appendChild(foot);
		} //end of for i

		this.facesSingle.appendChild(this.facePages[0]);
		document.body.appendChild(this.facesSingle);
		this.setFaceStyle(link,textField);
  },

  // locate faces
  setFaceStyle: function(link, textField){
		this.currentLink = link;
		this.facesSingle.setStyle({
				"position": 'absolute',
				"left": (link.cumulativeOffset().left) + 'px',
				"top": (link.cumulativeOffset().top) + 'px',
				"width": '244px',
		});
		this.currentField = textField;
		this.currentLink = link;
	},

  toggleFaces: function(link, textField, event){
    Event.stop(event);
    // if faces table exists, show/hide it
    // otherwise create a new table and bind it to textField
		if (!this.facesSingle){
      this.constructFacesTable(link, textField);
      this.currentField =  textField;
      this.currentLink = link;
      this.facesSingle.show();
			alert(this);
		}else{
			if (this.currentLink == link && this.facesSingle.visible()){
				this.facesSingle.hide();
			}else{
				this.setFaceStyle(link, textField);
				this.facesSingle.removeChild(this.facesSingle.firstChild);
				this.facesSingle.appendChild(this.facePages[0]);
				this.facesSingle.show();
			}
		}
  }

});

document.observe('dom:loaded', function(){
  document.body.observe('click', function(){
    if(Iyxzone.Emotion.Manager.facesSingle){
      Iyxzone.Emotion.Manager.facesSingle.hide();
    }
  });
});
