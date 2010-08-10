Iyxzone.Photo = {
  version: '1.0',

  author: ['高侠鸿'],

  Tagger: Class.create({}),

  Slide: Class.create({}), // 纵向的图片浏览

  Slide3: Class.create({}) // 纵向的图片浏览，而且不不切换url的
};

Iyxzone.Photo.FriendSelector = Class.create({

  initialize: function(toggleButton, input, friendList, friendTable, friendItems, gameSelector, token){
    this.friendID = 0;
    this.toggleButton = $(toggleButton);
    this.friendList = $(friendList);
    this.friendTable = $(friendTable);
    this.friendItems = $(friendItems);
    this.gameSelector = $(gameSelector);
    this.token = token;
    
    // toggle button event
    Event.observe(this.toggleButton, 'click', function(e){
      this.toggleFriends();
    }.bind(this));
    
    // game selector event
    Event.observe(this.gameSelector, 'change', function(){
      this.getFriends();
    }.bind(this));

    // set text box list
    this.textboxList = new TextBoxList(input, {
      onBoxDispose: this.removeBox.bind(this),
      holderClassName: 'friend-select-list s_clear',
      bitClassName: ''
    });
   
    // set event
    var inputs = $$('input');
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox'){
        inputs[i].checked = false;
        inputs[i].observe('click', this.afterCheckFriend.bindAsEventListener(this));
      }
    }
 
    // custom auto completer
    var pinyins = [];
    var names = [];
    var ids = [];

    this.friendItems.childElements().each(function(li){
      pinyins.push(li.down('input').readAttribute('pinyin'));
      names.push(li.down('input').readAttribute('login'));
      ids.push(li.down('input').value);
    }.bind(this));

    new Iyxzone.Friend.Autocompleter(this.textboxList.getMainInput(), this.friendList, {
      ids: ids,
      names: names,
      pinyins: pinyins,
      emptyText: '没有匹配的好友...',
      tipText: '输入你好友的姓名或者拼音',
      afterUpdateElement: this.afterSelectFriend.bind(this),
      comp: this.textboxList.holder
    });
  },

  removeBox: function(el, input){
    var friendID = input.value;

    this.friendID = 0;

    var inputs = $$('input');
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox'){
        inputs[i].checked = false;
      }
    }

  },

  add: function(info){
    if(this.textboxList.bits.size() != 0){
      this.textboxList.disposeAll();
    }
    this.textboxList.add(info.id, info.login);
    this.friendID = info.id;
  },

  getFriends: function(){
    var gameID = this.gameSelector.value;
    var friends = this.friendItems.childElements();
    friends.each(function(f){
      var info = f.readAttribute('info').evalJSON();
      var games = info.games;
      if(gameID == 'all' || games.include(gameID)){
        f.show();
      }else{
        f.hide();
      }
    }.bind(this)); 
  },

  toggleFriends: function(){
    if(!this.friendTable.visible()){
      var pos = this.toggleButton.positionedOffset();
      this.friendTable.setStyle({
        position: 'absolute',
        left: (pos.left + this.toggleButton.getWidth() - this.friendTable.getWidth()) + 'px',
        top: (pos.top + this.toggleButton.getHeight()) + 'px'
      });
      this.friendTable.show();
    }else{
      this.friendTable.hide();
    }
  },

  afterSelectFriend: function(input, selectedLI){
    var id = selectedLI.readAttribute('id');
    var login = selectedLI.childElements()[0].innerHTML;

    var inputs = $$('input');
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox'){
        inputs[i].checked = false;
        if(inputs[i].value == id)
          inputs[i].checked = true;
      }
    }

    this.add({id: id, login: login});
    input.clear();
  },

  afterCheckFriend: function(mouseEvent){
    var checkbox = mouseEvent.target;
    
    var inputs = $$('input');
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox' && inputs[i] != checkbox){
        inputs[i].checked = false;
      }
    }

    this.toggleFriends();
    this.add({id: checkbox.value, login: checkbox.readAttribute('login')});
  },

  reset: function(){
    this.textboxList.getMainInput().clear();
    this.textboxList.disposeAll();
    this.friendID = 0;

    var inputs = $$('input');
    for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == 'checkbox'){
        inputs[i].checked = false;
      }
    }
  }

});


/*
 * 以后搞不好需要一页面里显示多个photo tag，
 * 因此实现为类，而不是静态类
 */
Iyxzone.Photo.Tagger = Class.create({

  initialize: function(type, photoID, controlPanel, confirmButton, cancelButton, tagInfos, tagsHolder, isCurrentUser, contentInput, toggleButton, friendInput, friendList, friendTable, friendItems, gameSelector, token, options){
    this.options = Object.extend({
        ratio: 0.2
      }, options || {}
    );

    this.type = type;
    this.photoID = photoID;
    this.photo = $('photo_' + this.photoID);
    this.controlPanel = $(controlPanel);
    this.contentInput = $(contentInput);
    this.confirmButton = $(confirmButton);
    this.cancelButton = $(cancelButton);    
    this.tagInfos = new Hash();
    this.tagsHolder = $(tagsHolder);
    this.isCurrentUser = isCurrentUser;
    this.token = token;
    this.started = false;
 
    /*
     * save and insert all tag
     */
    this.isLoading = true;
    if(tagInfos.length != 0)
      this.tagsHolder.innerHTML = '<img src="/images/loading.gif" />';
    for(var i=0;i<tagInfos.length;i++){
      this.insertTag(tagInfos[i]);
    }

    /*
     * create text box list
     */
    this.friendSelector = new Iyxzone.Photo.FriendSelector(toggleButton, friendInput, friendList, friendTable, friendItems, gameSelector, token);

    /*
     * confirm button events 
     */
    Event.observe(this.confirmButton, 'click', function(e){
      Event.stop(e);
      this.save();  
    }.bind(this));

    /*
     * cancel button event
     */
    Event.observe(this.cancelButton, 'click', function(e){
      Event.stop(e);
			this.reset();
      this.started = false;
    }.bind(this));

    this.mousemoveBind = this.showNearestTagWithContent.bindAsEventListener(this);
    Event.observe(this.photo, 'mousemove', this.mousemoveBind); 
  },

  insertTag: function(tagInfo){
    // save tag info
    this.tagInfos.set(tagInfo.id, {
      id: tagInfo.id,
      width: tagInfo.width,
      height: tagInfo.height,
      left: tagInfo.x,
      top: tagInfo.y,
      content: tagInfo.content,
      tagged_user_id: tagInfo.tagged_user.id,
      tagged_user_login: tagInfo.tagged_user.login,
      poster_id: tagInfo.poster.id,
      poster_login: tagInfo.poster.login
    });

    /*
      <li>
        <div class="rect-box">
          <div class="rect-wrap"><div class="rect">
            <a class="icon-active" href="#"></a>
            <a href="#">张一</a> 标记了 <a href="#">吕诃</a> ：11 
          </div></div>
        </div>
      </li>
    */
    var li = new Element('li', {id: 'tag_' + tagInfo.id});
		var rectTag = new Element('strong');
    var posterLink = new Element('a', {href: '/profiles/' + tagInfo.poster.id}).update(tagInfo.poster.login);
    var taggedUserLink = new Element('a', {href: '/profiles/' + tagInfo.tagged_user.id}).update(tagInfo.tagged_user.login);
		rectTag.appendChild(posterLink);
		rectTag.innerHTML += ('标记了');
		rectTag.appendChild(taggedUserLink);
		rectTag.innerHTML += (' : ' + tagInfo.content.escapeHTML());
		li.appendChild(rectTag);

    if(this.isLoading){
      this.tagsHolder.innerHTML = '';
      Element.insert(this.tagsHolder, {bottom: li});
      this.isLoading = false;
    }else{
      Element.insert(this.tagsHolder, {bottom: li});
    }

    // add tag events
    Event.observe('tag_' + tagInfo.id, 'mouseover', function(e){
      this.showTagWithContent(tagInfo.id);
    }.bind(this));
    Event.observe('tag_' + tagInfo.id, 'mouseout', function(e){
      this.hideTagWithContent(tagInfo.id);
    }.bind(this));
    if(this.isCurrentUser){
      var deleteLink = new Element('a', {href:'javascript: void(0)', 'class': 'icon-active'});
			var spaceBar = new Element('span');
      li.appendChild(deleteLink);
			li.appendChild(spaceBar);
      deleteLink.observe('click', function(e){
        Iyxzone.Facebox.confirmWithCallback('你确定要删除这个标签吗?', null, null, function(){
          this.remove(tagInfo.id);
        }.bind(this));
      }.bind(this));
    }
  },

  start: function(){
    if(this.started){
      return;
    }

    var min = 0;
    if(this.photo.getWidth() < this.photo.getHeight()){
      min = this.photo.getWidth() * this.options.ratio;
    }else{
      min = this.photo.getHeight() * this.options.ratio;
    }

    // initialize image crop
    this.cropImg = new Cropper.Img('photo_' + this.photoID, {
      //onEndCrop: this.onEndCrop.bind(this), //this.onEndCrop.bindAsEventListener(this),
      onDragging: this.onDragging.bind(this),
      minWidth: min,
      minHeight: min,
      displayOnInit: true,
      onloadCoords: {
        x1: this.photo.getWidth() - min,
        y1: 0,
        x2: this.photo.getWidth(),
        y2: min
      }
    });
    this.onDragging({x1: this.photo.getWidth() - min, y1: 0}, {width: min, height: min});
    
    // 开始圈人的时候就不能自动看到框框了
    Event.stopObserving(this.photo, 'mousemove', this.mousemoveBind);

    this.started = true;
  },

  /*
   * let control panel always stand by crop div
   */
  onDragging: function(coords, dimensions){
    var pos = Element.cumulativeOffset(this.photo); 
    this.controlPanel.setStyle({
      position: 'absolute',
      left: (pos.left + coords.x1 + dimensions.width + 2) + 'px',
      top: (pos.top + coords.y1) + 'px',
      zIndex: 200
    });
    this.controlPanel.show();
  }, 

  validate: function(){
    if(this.friendSelector.friendID == 0){
      error('你需要选择一个好友');
      return false;
    }
    return true;
  },

  remove: function(tagID){
    new Ajax.Request(Iyxzone.URL.deletePhotoTag(tagID), {
      method: 'delete',
      parameters: 'authenticity_token=' + encodeURIComponent(this.token),
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.Facebox.close();
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          if($('square_'+tagID)) $('square_'+tagID).remove();
          if($('content_'+tagID)) $('content_'+tagID).remove();
          $('tag_' + tagID).remove();
          this.tagInfos.unset(tagID);
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  save: function(){
    Iyxzone.disableButton(this.confirmButton, '保存中');
    
    if(this.validate()){
      var params = "";
      var taggedUserID = this.friendSelector.friendID;
      var x = this.cropImg.areaCoords.x1;
      var y = this.cropImg.areaCoords.y1;
      var width = this.cropImg.calcW();
      var height = this.cropImg.calcH();

      params = $('tag_form').serialize();
      params += "&tag[tagged_user_id]=" + taggedUserID;
      params += "&tag[x]=" + x;
      params += "&tag[y]=" + y;
      params += "&tag[width]=" + width;
      params += "&tag[height]=" + height;
      
      new Ajax.Request(Iyxzone.URL.createPhotoTag(this.type, this.photoID), {
        method: 'post', 
        parameters: params,
        onLoading: function(){
          Iyxzone.changeCursor('wait');
        },
        onComplete: function(){
          Iyxzone.changeCursor('default');
          Iyxzone.enableButton(this.confirmButton, '保存');
        }.bind(this), 
        onSuccess: function(transport){
          this.friendSelector.reset();
          this.contentInput.clear();
          var json = transport.responseText.evalJSON();
          if(json.code == 0){
            error("发生错误，请稍后再试");
          }else if(json.code == 1){
            this.insertTag(json.tag);
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButton(this.confirmButton, '保存');
    } 
  },

  showNearestTagWithContent: function(event){
    var distance = 100000000;
    var tagID = -1;
    var photoX = this.photo.cumulativeOffset().left;
    var photoY = this.photo.cumulativeOffset().top;
    var mouseX = event.pointerX();
    var mouseY = event.pointerY();

    this.tagInfos.each(function(pair){
      var x = photoX + pair.value.left;
      var width = pair.value.width;
      var y = photoY + pair.value.top;
      var height = pair.value.height;
      if(mouseX >= x && mouseX <= x + width && mouseY >=y && mouseY <= y + height){
        var deltaX = (x + width/2) - mouseX; 
        var deltaY = (y + height/2) - mouseY; 
        var delta = ((x + width/2) - mouseX) * ((x + width/2) - mouseX) + ((y + height/2) - mouseY) * ((y + height/2) - mouseY);
        if(delta < distance){
          distance = delta;
          tagID = pair.key;
        }
      }else{
        if(pair.key == this.currentTagID){
          this.hideTagWithContent(this.currentTagID);
          this.currentTagID = -1;
        }
      }
    }.bind(this));

    if(tagID >= 0){
      this.currentTagID = tagID;
      this.showTagWithContent(tagID);
    }
  },

  hideTagWithContent: function(tagID){
    var square = $('square_' + tagID);
    var info = $('tag_content_' + tagID);
    if(square) square.hide();
    if(info) info.hide();
  },

  showTagWithContent: function(tagID){
    var tag = this.tagInfos.get(tagID);
    var pos = this.photo.cumulativeOffset();
    var x = tag.left;
    var y = tag.top;
    var width = tag.width;
    var height = tag.height;
    var square = $('square_' + tagID);
    if(!square){
      square = new Element('div', {className: 'square-class', id: 'square_' + tagID});
      document.body.appendChild(square);
    }
    square.setStyle({
      'position': 'absolute',
      'width': width + 'px',
      'height': height + 'px',
      'left': (x + pos.left) + 'px',
      'top': (y + pos.top) + 'px',
      'border': '2px solid #eeeeee',
      'display': 'block',
      'zIndex': 4});
    var info = $('tag_content_' + tagID);
    if(!info){
      info = new Element('div', {id: 'tag_content_' + tagID}).update(tag.content);
      document.body.appendChild(info);
    }
    info.setStyle({
      'position': 'absolute',
      'color': 'white',
      'background': 'black',
      'left': (x + width + pos.left) + 'px',
      'top': (y + pos.top) + 'px',
      'display': 'block',
      'zIndex': 4});
  },

  reset: function(){
    this.cropImg.remove();
    this.controlPanel.hide();
    Event.observe(this.photo, 'mousemove', this.mousemoveBind);
  }

});

Iyxzone.Photo.Slide = Class.create({
  
  initialize: function(photoType, currentID, ids, urls, frames, downBtn, upBtn){
    this.photo = $('photo_' + currentID);
    this.photoType = photoType + 's';
    this.downBtn = downBtn;
    this.upBtn = upBtn;
    this.loadingImage = new Image();
    this.loadingImage.src = '/images/loading.gif';
    this.blankImage = new Image();
    this.blankImage.src = '/images/photo/nopic50x50.png';

    // 帮定事件到photo上
    this.photo.observe('mousemove', this.mouseOnPhoto.bind(this));
    this.photo.observe('click', this.clickOnPhoto.bind(this));
    this.photo.observe('mouseoff', this.mouseOffPhoto.bind(this));  
  
    // 只保存图片的url，到了需要的时候再去加载图片
    this.urls = urls;
    this.ids = ids;
    this.currentID = currentID; // 当前照片的id
    this.idPos = 0; // 正中间那张照片对应的id在ids中的位置
    this.mappings = new Hash(); // photo id => image object
    this.frames = frames; 
   
    this.upTimer = null;
    this.downTimer = null;
 
    for(var i=0;i<this.ids.length;i++){
      if(this.ids[i] == this.currentID){
        this.idPos = i;
        break;
      }
    }

    var pos = Math.floor(frames.length/2);     
    
    for(var i=0;i<this.frames.length;i++){
      var p = (this.idPos + i - pos);
      if(p >= 0 && p < this.ids.length){
        this.loadImage(i, p);
      }else{
        this.setBlank(i);
      }
    }

    this.setBtnEvents();
    this.changeBtn();
  },

  getSide: function(event){
    var mouseX = event.pointerX();
    var photoLeft = this.photo.cumulativeOffset().left;
    var photoWidth = this.photo.width;
    var delta = mouseX - photoLeft;
    if(delta < photoWidth/2){
      return 'left'; //left
    }else if(delta > photoWidth/2 && delta < photoWidth){
      return 'right'; //right
    } 
    return -1; // impossible
  },

  mouseOnPhoto: function(event){
    var side = this.getSide(event);
    if(side == 'left'){
        this.photo.writeAttribute('style', "cursor:url(/images/skin/left.cur), auto;");
    }else if(side == 'right'){
        this.photo.writeAttribute('style', "cursor:url(/images/skin/right.cur), auto;");
    }
  },

  mouseOffPhoto: function(event){
    Iyxzone.changeCursor('default');
  },

  clickOnPhoto: function(event){
    var side = this.getSide(event);
    if(side == 'left'){
      var idPos = (this.idPos - 1 + this.ids.length) % this.ids.length;
    }else if(side == 'right'){
      var idPos = (this.idPos + 1) % this.ids.length;
    }
    window.location.href = "/" + this.photoType + "/" + this.ids[idPos];
  },

  setBtnEvents: function(){
    this.downBtn.observe('click', this.scrollDown.bindAsEventListener(this));
    this.upBtn.observe('click', this.scrollUp.bindAsEventListener(this));
  },

  changeBtn: function(){
    if(this.idPos == 0){
      this.downBtn.className = 'btn downbtn-gray';
    }else{
      this.downBtn.className = 'btn downbtn';
    }
    
    if(this.idPos == this.ids.length - 1){
      this.upBtn.className = 'btn upbtn-gray';
    }else{
      this.upBtn.className = 'btn upbtn';
    }
  },

  setBlank: function(idx){
    this.frames[idx].innerHTML = "<a href='#'><img src='" + this.blankImage.src + "' class='imgbox01'/></a>";
  },

  loadImage: function(idx, photoIdx){
    this.frames[idx].innerHTML = "<img src='" + this.loadingImage.src + "'/>";
    var img = this.mappings.get(this.ids[photoIdx]);
    if(!img){
      img = new Image();
      img.src = this.urls[photoIdx];
      this.mappings.set(this.ids[photoIdx], img);
    }
    if(this.currentID == this.ids[photoIdx]){
      this.frames[idx].addClassName('now');
    }
    this.frames[idx].innerHTML = "<a href='/" + this.photoType + "/" + this.ids[photoIdx] +"'><img src='" +  img.src +"' class='imgbox01' width='50px' height='50px'/></a>";
  },

  scrollDown: function(){
    if(this.idPos == 0 || this.downTimer != null){
      return;
    }

    var div = this.frames[0].up();
    new Effect.Morph(div, {style: 'top: 0px', duration: 0.5});
    this.downTimer = setTimeout(this.afterScrollDown.bind(this), 550);
    
    this.idPos--;
    this.changeBtn();
  },

  afterScrollDown: function(){
    // insert frame to the top and reset div position
    var frame = new Element('div', {'class': 'img'});
    Element.insert(this.frames[0], {before: frame});
    this.frames = frame.up().childElements();
    var p = this.idPos - Math.floor((this.frames.length-1)/2);
    if(p >= 0){
      this.loadImage(0, p);
    }else{
      this.setBlank(0);
    }
    frame.up().setStyle({'top': '-67px'});

    // remove last frame
    var len = this.frames.length;
    this.frames[len - 1].remove();
    this.frames.splice(len - 1, 1);

    // reset timer
    this.downTimer = null;
  },

  scrollUp: function(){
    if(this.idPos == this.ids.length - 1 || this.upTimer != null)
      return;

    var div = this.frames[0].up();
    new Effect.Morph(div, {style: 'top: -134px', duration: 0.5});
    this.upTimer = setTimeout(this.afterScrollUp.bind(this), 550);

    this.idPos++;
    this.changeBtn();
  },

  afterScrollUp: function(){
    // remove first frame
    this.frames[0].remove();
    this.frames.splice(0, 1);
    this.frames[0].up().setStyle({'top': '-67px'});

    // add last frame
    var frame = new Element('div', {'class': 'img'});
    Element.insert(this.frames[this.frames.length - 1], {after: frame});
    this.frames = frame.up().childElements();
    var p = this.idPos + this.frames.length - 2 - Math.floor((this.frames.length - 3)/2);
    if(p < this.ids.length){
      this.loadImage(this.frames.length - 1, p);
    }else{
      this.setBlank(this.frames.length - 1);
    }
  
    // reset timer
    this.upTimer = null;
  }

});

Iyxzone.Photo.Slide3 = Class.create({
  
  initialize: function(currentID, photoInfos, frames, downBtn, upBtn){
    this.downBtn = downBtn;
    this.upBtn = upBtn;
    this.loadingImage = new Image();
    this.loadingImage.src = '/images/loading.gif';
    this.blankImage = new Image();
    this.blankImage.src = '/images/photo/nopic50x50.png';

    // 只保存图片的url，到了需要的时候再去加载图片
    this.urls = [];
    this.thumbnails = [];
    this.ids = [];
    this.notations = [];
    this.widths = [];
    this.heights =[];
    this.currentID = currentID; // 当前照片的id
    this.mappings = new Hash(); // photo id => image object
    this.thumbnailMappings = new Hash();
    this.frames = frames; 
  
    for(var i=0;i<photoInfos.length;i++){
      var info = photoInfos[i];
      this.ids.push(info.id);
      this.urls.push(info.url);
      this.thumbnails.push(info.thumbnail_url);
      this.notations.push(info.notation);
      this.widths.push(info.width);
      this.heights.push(info.height);
    }
 
    this.upOffset = 0;
    this.downOffset = 0;

    this.idPos = 0; 
    for(var i=0;i<this.ids.length;i++){
      if(this.ids[i] == this.currentID){
        this.idPos = i;
        break;
      }
    }

    var pos = Math.floor(frames.length/2);     
   
    this.frames[pos].addClassName('now');
 
    for(var i=0;i<this.frames.length;i++){
      var p = (this.idPos + i - pos);
      if(p >= 0 && p < this.ids.length){
        this.loadImage(i, p);
      }else{
        this.setBlank(i);
      }
    }

    this.updatePhotoInfo(this.idPos);
    this.setBtnEvents();
    this.changeBtn();
  },

  getSide: function(event){
    var mouseX = event.pointerX();
    var photoLeft = this.photo.cumulativeOffset().left;
    var photoWidth = this.photo.width;
    var delta = mouseX - photoLeft;
    
    if(delta < photoWidth/2){
      return 'left'; //left
    }else if(delta > photoWidth/2 && delta < photoWidth){
      return 'right'; //right
    } 
    return -1; // impossible
  },

  mouseOnPhoto: function(event){
    var side = this.getSide(event);
    if(side == 'left'){
        this.photo.writeAttribute('style', "cursor:url(/images/skin/left.cur), auto;");
    }else if(side == 'right'){
        this.photo.writeAttribute('style', "cursor:url(/images/skin/right.cur), auto;");
    }
  },

  mouseOffPhoto: function(event){
    Iyxzone.changeCursor('default');
  },

  clickOnPhoto: function(event){
    var side = this.getSide(event);
    var pos = Math.floor(this.frames.length / 2);
    if(side == 'left'){
      if(this.idPos == 0){
      }else{
        this.scrollDown(1);
      }
    }else if(side == 'right'){
      if(this.idPos == this.ids.length - 1){
      }else{
        this.scrollUp(1);
      }
    }
  },

  setBtnEvents: function(){
    this.downBtn.observe('click', function(event){
      this.scrollDown(1);
    }.bind(this));
    this.upBtn.observe('click', function(event){
      this.scrollUp(1);
    }.bind(this));
  },

  changeBtn: function(){
    if(this.idPos == 0){
      this.downBtn.className = 'btn downbtn-gray';
    }else{
      this.downBtn.className = 'btn downbtn';
    }
    
    if(this.idPos == this.ids.length - 1){
      this.upBtn.className = 'btn upbtn-gray';
    }else{
      this.upBtn.className = 'btn upbtn';
    }
  },

  setBlank: function(idx){
    this.frames[idx].innerHTML = "<a href='javascript:void(0)'><img src='" + this.blankImage.src + "' class='imgbox01'/></a>";
  },

  cacheThumbnail: function(idx){
    var img = this.thumbnailMappings.get(this.ids[idx]);
    if(!img){
      img = new Image();
      img.src = this.thumbnails[idx];
      this.thumbnailMappings.set(this.ids[idx], img);
    }
  },

  getThumbnailElement: function(idx){
    var url = this.thumbnails[idx];
    
    // cache thumbnail
    this.cacheThumbnail(url);

    // build thumbnail img tag
    var img = new Element('img', {'src' : url});
    img.setStyle({'width': '50px', 'height': '50px'});
    img.addClassName('imgbox01');
    return img;
  },

  cacheImage: function(idx){
    var img = this.mappings.get(this.ids[idx]);
    if(!img){
      img = new Image();
      img.src = this.urls[idx];
      this.mappings.set(this.ids[idx], img);
    }
  },

  getImageElement: function(idx){
    var url = this.urls[idx];

    // cache image
    this.cacheImage(idx);

    // construct img tag
    var el = new Element('img', {src: url});
    var width = this.widths[idx];
    var height = this.heights[idx];
    if(width < 500){
      el.setStyle({"width": width, "height": height});
    }else{
      width = 500;
      height = height * 500 / width;
      el.setStyle({"width": width, "height": height});
    }
    return el;  
  },

  updatePhotoInfo: function(index){
    var img = this.getImageElement(index);
    $('picture').update('');
    $('picture').appendChild(img);
      
    if(this.notations[index] && this.notations[index] != '')
      $('notation').update(this.notations[index].escapeHTML().gsub('\n', '<br/>'));

    this.photo = $('picture').childElements()[0];
    this.photo.observe('mousemove', this.mouseOnPhoto.bind(this));
    this.photo.observe('click', this.clickOnPhoto.bind(this));
    this.photo.observe('mouseoff', this.mouseOffPhoto.bind(this));  
  },

  scrollUp: function(offset){
    if(this.downOffset != 0 || this.upOffset != 0 || this.idPos == this.ids.length - 1){
      return;
    }

    var pos = Math.floor(this.frames.length/2);
    this.frames[pos].writeAttribute('class', 'img');
    this.upOffset = offset;
    this.frames[pos + offset].addClassName('now');
    this.updatePhotoInfo(this.idPos + offset);
    this.startScrollUp();
  },

  scrollDown: function(offset){
    if(this.downOffset != 0 || this.upOffset != 0 || this.idPos == 0){
      return;
    }

    var pos = Math.floor(this.frames.length/2);
    this.frames[pos].writeAttribute('class', 'img');
    this.downOffset = offset;
    this.frames[pos - offset].addClassName('now');
    this.updatePhotoInfo(this.idPos - offset);
    this.startScrollDown();
  },

  loadImage: function(idx, photoIdx){
    // load thumbnail
    this.frames[idx].innerHTML = "<img src='" + this.loadingImage.src + "'/>";
   
    // set thumbnail 
    var img = this.getThumbnailElement(photoIdx);
    var a = new Element('a', {href: 'javascript:void(0)', index: photoIdx});
    a.appendChild(img);
    this.frames[idx].update(a);

    // set thumbnail events
    a.observe('click', function(e){
      var index = parseInt(e.target.up('a').readAttribute('index'));
      var idPos = this.idPos;
      
      if(index == idPos){
      }else if(index < idPos){
        this.scrollDown(idPos - index);
      }else if(index > idPos){
        this.scrollUp(index - idPos);
      }
    }.bind(this));
  },

  startScrollDown: function(){
    if(this.idPos == 0){
      return;
    }

    var div = this.frames[0].up();
    new Effect.Morph(div, {
      style: 'top: 0px', 
      duration: 0.5,
      afterFinish: this.afterScrollDown.bind(this)
    });
    
    this.idPos = this.idPos - 1;
    this.changeBtn();
  },

  afterScrollDown: function(){
    // insert frame to the top and reset div position
    var frame = new Element('div', {'class': 'img'});
    Element.insert(this.frames[0], {before: frame});
    this.frames = frame.up().childElements();
    var p = this.idPos - Math.floor((this.frames.length-1)/2);
    if(p >= 0){
      this.loadImage(0, p);
    }else{
      this.setBlank(0);
    }
    frame.up().setStyle({'top': '-67px'});

    // remove last frame
    var len = this.frames.length;
    this.frames[len - 1].remove();
    this.frames.splice(len - 1, 1);

    // reset timer
    this.downOffset--;
    if(this.downOffset != 0){
      this.startScrollDown();
    }      
  },

  startScrollUp: function(){
    if(this.idPos == this.ids.length - 1)
      return;

    var div = this.frames[0].up();
    new Effect.Morph(div, {
      style: 'top: -134px', 
      duration: 0.5, 
      afterFinish: this.afterScrollUp.bind(this)
    });

    this.idPos++;
    this.changeBtn();
  },

  afterScrollUp: function(){
    // remove first frame
    this.frames[0].remove();
    this.frames.splice(0, 1);
    this.frames[0].up().setStyle({'top': '-67px'});

    // add last frame
    var frame = new Element('div', {'class': 'img'});
    Element.insert(this.frames[this.frames.length - 1], {after: frame});
    this.frames = frame.up().childElements();
    var p = this.idPos + this.frames.length - 2 - Math.floor((this.frames.length - 3)/2);
    if(p < this.ids.length){
      this.loadImage(this.frames.length - 1, p);
    }else{
      this.setBlank(this.frames.length - 1);
    }
  
    // reset timer
    this.upOffset--;
    if(this.upOffset != 0){
      this.startScrollUp();
    }
  }

});
