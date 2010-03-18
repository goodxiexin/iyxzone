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

  linkToFieldsMappings: new Hash(),

  linkToFacesMappings: new Hash(),

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

		var faces = new Element('div', {class:'a', standwith:''});

		for (var i =0; i<facesCount; i++){
			if (i % facesPerPage == 0){
				pageindex++;
				facepage[pageindex] = new Element('div', {class:'b'});
			}	
			a = new Element('a', {title:myfaces[i], href:'#'});
			var thisattr = a.readAttribute('title');
			img = new Element('img', {src: "/images/faces/"+ thisattr.slice(1,thisattr.length-1) +".gif",  index:i});
			a.appendChild(img);
			a.observe('click', function(e){
					var idx = parseInt(e.element().readAttribute('index'));
					textField.value += Iyxzone.Emotion.faces[idx];
					this.toggleFaces(link, textField);
					}.bind(this));
			facepage[pageindex].appendChild(a);
		}

		for(var i = 0; i<facepage.length; i++){
			var first = new Element('a', {class:'first'} );
			first.observe('click',function(e){var f = e.element().parentNode.parentNode.parentNode;
					var thispage = e.element().parentNode.parentNode;	
					f.appendChild(facepage[0]);
					f.removeChild(thispage)}.bind(this));
			first.appendChild(document.createTextNode("第一页"));
			var last = new Element('a', {class:'last'});
			last.appendChild(document.createTextNode("最后页"));
			last.observe('click',function(e){var f = e.element().parentNode.parentNode.parentNode;
					var thispage = e.element().parentNode.parentNode;	
					f.appendChild(facepage[facepage.length-1]);
					f.removeChild(thispage)}.bind(this));

			var prev = new Element('a',{class:'prev',page_nr: i});
			//prev.appendChild(document.createTextNode("上一页"));
			if (i!=0){
				prev.observe('click',function(e){var f = e.element().parentNode.parentNode.parentNode;
						var thispage = e.element().parentNode.parentNode;	
						var page_to = parseInt(e.element().readAttribute('page_nr')) -1;
						f.appendChild(facepage[page_to]);
						f.removeChild(thispage)});
			}

			var next = new Element('a',{class:'next',page_nr: i});
			//next.appendChild(document.createTextNode("下一页"));
			if (i!=facepage.length-1){
				next.observe('click',function(e){var f = e.element().parentNode.parentNode.parentNode;
						var thispage = e.element().parentNode.parentNode;	
						var page_to = parseInt(e.element().readAttribute("page_nr")) +1;
						alert(page_to)
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
				for (var j=0; j< facepage.length; j++){
					var pagenum = new Element('span',{ page_nr: j});
					pagenum.appendChild(document.createTextNode((j+1).toString()));
					//pagenum = document.createTextNode((j+1).toString());
					foot.appendChild(pagenum);

					pagenum.observe('click',function(e){
							var page_to = parseInt(e.target.readAttribute('page_nr'));
							var f = e.element().parentNode.parentNode.parentNode;
							var thispage = e.element().parentNode.parentNode;	
							f.removeChild(thispage);
							f.appendChild(facepage[page_to]);
							});

				}
				if (i < facepage.length-1){
					foot.appendChild(next);
					foot.appendChild(last);
				}
				facepage[i].appendChild(foot);
			}//end of length !=1
		} //end of for i
		//link.setAttribute ('href', 'javascript:alert("LinkButton1");');
		//<div class="pager-simple foot"><a href="#" class="prev">上一页</a><span>1</span><a href="#" class="next">下一页</a></div> 
		// <div class="pager-simple foot"><a href="#" class="first">上一页</a><span>1</span><a href="#" class="last">下一页</a></div> 

		faces.appendChild(facepage[0]);
		document.body.appendChild(faces);
    

    // locate faces
    /*faces.setStyle({
      position: 'absolute',
      left: (link.cumulativeOffset().left - 200) + 'px',
      top: (link.cumulativeOffset().top) + 'px',
      width: '200px',
      height: '40px'
    });*/
		this.setFaceStyle(link,textField, faces);

    // set click events
    // this must be done after faces are appended in document.body
    var icons = faces.getElementsByClassName('emotion-icon');
    for(var i=0;i<icons.length;i++){
      icons[i].observe('click', function(e){
        var idx = parseInt(e.element().readAttribute('index'));
        textField.value += Iyxzone.Emotion.faces[idx];
        this.toggleFaces(link, textField);
      }.bind(this));
    }

    return faces;
  },


    // locate faces
    setFaceStyle: function(link, textField, facesSingle){
			facesSingle.setStyle({
      position: 'absolute',
      left: (link.cumulativeOffset().left - 200) + 'px',
      top: (link.cumulativeOffset().top) + 'px',
      width: '200px',
      height: '40px'
    });
			facesSingle.setAttribute('standwith', textField.toString() );
		},

  toggleFaces: function(link, textField){
    // get corresponding faces
    var faces = this.linkToFacesMappings.get(link);

    // if faces table exists, show/hide it
    // otherwise create a new table and bind it to textField
		if (!faces){
      var faces = this.constructFacesTable(link, textField);
      this.linkToFieldsMappings.set(link, textField);
      this.linkToFacesMappings.set(link, faces);
      faces.show();
		}
		else{
			if (faces.readAttribute('standwith') == textField.toString() && faces.visible()){
				faces.hide();
			}
			else{
				this.setFaceStyle(link, textField, faces);
				faces.show();
			}
		}
  }

});
