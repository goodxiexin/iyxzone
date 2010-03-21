/**
 * TODO:
 * 点击document.body，隐藏表情 
 * Change Log
 * 1.1
 * add to 50 emotions, Mar.16,2010
 * discard parameter :facesPerRow, rows
 * add parameter facesPerPage
 */

Iyxzone.Emotion = {
  version: '1.1',

  author: ['高侠鸿','戴雨宸'],

  //faces: ['[-_-]', '[@o@]', '[-|-]', '[o_o]', '[ToT]', '[*_*]'],
	faces: [ '[惊吓]', '[晕]', '[流鼻涕]', '[挖鼻子]', '[鼓掌]', '[骷髅]', '[坏笑]', '[傲慢]', '[大哭]', '[砸头]', '[衰]', '[哭]', '[可爱]', '[冷汗]', '[抽烟]', '[擦汗]', '[亲亲]', '[糗]', '[吃惊]', '[左哼哼]', '[疑问]', '[惊恐]', '[睡觉]', '[皱眉头]', '[可怜]', '[打呵欠]', '[害羞]', '[花痴]', '[右哼哼]', '[囧]', '[大便]', '[咒骂]', '[贼笑]', '[嘘]', '[吐]', '[苦恼]', '[白眼]', '[流汗]', '[大笑]', '[羞]', '[撇嘴]', '[偷笑]', '[BS]', '[困]', '[火]', '[闭嘴]', '[抓狂]', '[强]', '[不行]', '[装酷]' ],

  facesCount: 50,

	facesPerPage: 20 ,

  facesPerRow: 10 ,

  rows: 4,

  specials: ['/', '.', '*', '+', '?', '|','(', ')', '[', ']', '{', '}', '\\'],

  escape: function(text){},

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
		var myfaces = Iyxzone.Emotion.faces;
		var facesPerPage = Iyxzone.Emotion.facesPerPage;
		var facesCount = Iyxzone.Emotion.facesCount;
		var facepage = [];
		var pageindex = -1;
		var a, img;

		var facesSingle = new Element('div', {class:"emot-box drop-wrap"});

		for (var i =0; i<facesCount; i++){
			if (i % facesPerPage == 0){
				pageindex++;
				facepage[pageindex] = new Element('div', {class:"con"});
			}	
			a = new Element('a', {title:myfaces[i]});
			img = new Element('img', {src: "/images/faces/"+ myfaces[i].slice(1,myfaces[i].length-1) +".gif",  index:i});
			a.appendChild(img);
			a.observe('click', function(e){
				var idx = parseInt(e.element().readAttribute('index'));
				Iyxzone.Emotion.Manager.currentField.value += Iyxzone.Emotion.faces[idx];
				Iyxzone.Emotion.Manager.toggleFaces(Iyxzone.Emotion.Manager.currentLink, Iyxzone.Emotion.Manager.currentField);
			}.bind(this));
			facepage[pageindex].appendChild(a);
		}

		for(var i = 0; i<facepage.length; i++){
			var first = new Element('a', {class:'first'});
			first.observe('click',function(e){
        var f = e.element().parentNode.parentNode.parentNode;
				var thispage = e.element().parentNode.parentNode;	
				f.appendChild(facepage[0]);
				f.removeChild(thispage)
      }.bind(this));
			first.appendChild(document.createTextNode("第一页"));

			var last = new Element('a', {class:'last'});
			last.appendChild(document.createTextNode("最后页"));
			last.observe('click',function(e){
        var f = e.element().parentNode.parentNode.parentNode;
				var thispage = e.element().parentNode.parentNode;	
				f.appendChild(facepage[facepage.length-1]);
				f.removeChild(thispage)
      }.bind(this));

			var prev = new Element('a',{class:'prev',page_nr: i});
			if (i!=0){
				prev.observe('click',function(e){
          var f = e.element().parentNode.parentNode.parentNode;
					var thispage = e.element().parentNode.parentNode;	
					var page_to = parseInt(e.element().readAttribute('page_nr')) -1;
					f.appendChild(facepage[page_to]);
					f.removeChild(thispage);
        });
			}

			var next = new Element('a',{class:'next',page_nr: i});
			if (i!=facepage.length-1){
				next.observe('click',function(e){var f = e.element().parentNode.parentNode.parentNode;
						var thispage = e.element().parentNode.parentNode;	
						var page_to = parseInt(e.element().readAttribute("page_nr")) +1;
						f.appendChild(facepage[page_to]);
						f.removeChild(thispage)}.bind(this));
			}

			var foot = new Element('div', {class:'pager-simple foot'});
			//add foot ---first,pre,1,2,3...,next, last
			if (facepage.length != 1){
				if (i > 0){
					foot.appendChild(first);
					foot.appendChild(prev);
				}
				var pagenum = new Element('span');
				pagenum.appendChild(document.createTextNode((i+1).toString()));
				foot.appendChild(pagenum);
				if (i < facepage.length-1){
					foot.appendChild(next);
					foot.appendChild(last);
				}
				facepage[i].appendChild(foot);
			}//end of length !=1
		} //end of for i

		facesSingle.appendChild(facepage[0]);
		document.body.appendChild(facesSingle);
		Iyxzone.Emotion.Manager.facesSingle = facesSingle;
		Iyxzone.Emotion.Manager.facePages = facepage;

		Iyxzone.Emotion.Manager.setFaceStyle(link,textField);

    return facesSingle;
  },

  // locate faces
  setFaceStyle: function(link, textField){
		Iyxzone.Emotion.Manager.currentLink = link;
		Iyxzone.Emotion.Manager.facesSingle.setStyle({
				"position": 'absolute',
				"left": (link.cumulativeOffset().left - 200) + 'px',
				"top": (link.cumulativeOffset().top) + 'px',
				"width": '200px',
				"height": '400px'
		});
		Iyxzone.Emotion.Manager.currentField= textField;
		Iyxzone.Emotion.Manager.currentLink = link;
	},

  toggleFaces: function(link, textField){
    // if faces table exists, show/hide it
    // otherwise create a new table and bind it to textField
		if (!Iyxzone.Emotion.Manager.facesSingle){
      Iyxzone.Emotion.Manager.constructFacesTable(link, textField);
      Iyxzone.Emotion.Manager.currentField =  textField;
      Iyxzone.Emotion.Manager.currentLink = link;
      Iyxzone.Emotion.Manager.facesSingle.show();
		}else{
			if (Iyxzone.Emotion.Manager.currentLink == link && Iyxzone.Emotion.Manager.facesSingle.visible()){
				Iyxzone.Emotion.Manager.facesSingle.hide();
			}else{
				Iyxzone.Emotion.Manager.setFaceStyle(link, textField);
				Iyxzone.Emotion.Manager.facesSingle.removeChild(Iyxzone.Emotion.Manager.facesSingle.firstChild);
				Iyxzone.Emotion.Manager.facesSingle.appendChild(Iyxzone.Emotion.Manager.facePages[0]);
				Iyxzone.Emotion.Manager.facesSingle.show();
			}
		}
  }

});
