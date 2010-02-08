Iyxzone.Photo = {
  version: '1.0',

  author: ['高侠鸿'],

  Tagger: Class.create({}),

  SlideManager: {},

  Slide: Class.create({})  
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
    this.textboxList = new TextBoxList(input, {});
    
    // custom auto completer
    new Iyxzone.Friend.Autocompleter(this.textboxList.getMainInput(), this.friendList, '/auto_complete_for_photo_tags', {
      method: 'get',
      emptyText: '没有匹配的好友...',
      afterUpdateElement: this.afterSelectFriend.bind(this),
      onInputFocus: this.showTips.bind(this),
      comp: this.textboxList.holder
    });

  },

  showTips: function(){
    this.friendList.innerHTML = '输入你好友的拼音';
    this.friendList.setStyle({
      position: 'absolute',
      left: this.textboxList.holder.positionedOffset().left + 'px',
      top: (this.textboxList.holder.positionedOffset().top + this.textboxList.holder.getHeight()) + 'px',
      width: (this.textboxList.holder.getWidth() - 10) + 'px',
      maxHeight: '200px',
      overflow: 'auto',
      padding: '5px',
      background: 'white',
      border: '1px solid #E7F0E0'
    });
    this.friendList.show();
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
    this.friendItems.innerHTML = '<img src="/images/loading.gif" style="text-align:center"/>';
    new Ajax.Request('/friend_table_for_photo_tags?game_id=' + gameID, {
      method: 'get',
      onSuccess: function(transport){
        this.friendItems.innerHTML = transport.responseText;
      }.bind(this)
    });
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
      if(this.friendItems.innerHTML == ''){
        this.friendItems.innerHTML = '<img src="/images/loading.gif" style="text-align:center"/>';
        new Ajax.Request('/friend_table_for_photo_tags?game_id=all', {
          method: 'get',
          onSuccess: function(transport){
            this.friendItems.innerHTML = transport.responseText;
            // add events to all checkbox
            
          }.bind(this)
        });
      }
    }else{
      this.friendTable.hide();
    }
  },

  afterSelectFriend: function(input, selectedLI){
    var id = selectedLI.readAttribute('id');
    var profileID = selectedLI.readAttribute('profileID');
    var login = selectedLI.innerHTML;
    this.add({id: id, profileID: profileID, login: login});
    input.clear();
  },

  afterClickFriend: function(friendID, profileID, login){
    this.toggleFriends();
    this.add({id: friendID, profileID: profileID, login: login});
  },

  reset: function(){
    this.textboxList.getMainInput().clear();
    this.textboxList.disposeAll();
    this.friendID = 0;
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
    }.bind(this));

    this.mousemoveBind = this.showNearestTagWithContent.bindAsEventListener(this);
    Event.observe(this.photo, 'mousemove', this.mousemoveBind); 
  },

  insertTag: function(tagInfo){
    // save tag info
    this.tagInfos.set(tagInfo.photo_tag.id, {
      id: tagInfo.photo_tag.id,
      width: tagInfo.photo_tag.width,
      height: tagInfo.photo_tag.height,
      left: tagInfo.photo_tag.x,
      top: tagInfo.photo_tag.y,
      content: tagInfo.photo_tag.content,
      tagged_user_id: tagInfo.photo_tag.tagged_user.id,
      tagged_user_login: tagInfo.photo_tag.tagged_user.login,
      poster_id: tagInfo.photo_tag.poster.id,
      poster_login: tagInfo.photo_tag.poster.login
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
    var li = new Element('li', {id: 'tag_' + tagInfo.photo_tag.id});
		var rectTag = new Element('strong');
    var posterLink = new Element('a', {href: '/profiles/' + tagInfo.photo_tag.poster.id}).update(tagInfo.photo_tag.poster.login);
    var taggedUserLink = new Element('a', {href: '/profiles/' + tagInfo.photo_tag.tagged_user.id}).update(tagInfo.photo_tag.tagged_user.login);
		rectTag.appendChild(posterLink);
		rectTag.innerHTML += ('标记了');
		rectTag.appendChild(taggedUserLink);
		rectTag.innerHTML += (' : ' + tagInfo.photo_tag.content);
		li.appendChild(rectTag);

    if(this.isLoading){
      this.tagsHolder.innerHTML = '';
      Element.insert(this.tagsHolder, {bottom: li});
      this.isLoading = false;
    }else{
      Element.insert(this.tagsHolder, {bottom: li});
    }

    // add tag events
    Event.observe('tag_' + tagInfo.photo_tag.id, 'mouseover', function(e){
      this.showTagWithContent(tagInfo.photo_tag.id);
    }.bind(this));
    Event.observe('tag_' + tagInfo.photo_tag.id, 'mouseout', function(e){
      this.hideTagWithContent(tagInfo.photo_tag.id);
    }.bind(this));
    if(this.isCurrentUser){
      var deleteLink = new Element('a', {href:'#', class: 'icon-active'});
			var spaceBar = new Element('span');
      li.appendChild(deleteLink);
			li.appendChild(spaceBar);
      deleteLink.observe('click', function(e){
        facebox.show_confirm_with_callbacks('你确定要删除这个标价吗?', this.remove.bind(this), tagInfo.photo_tag.id);// this.remove(tagInfo.photo_tag.id);
      }.bind(this));
    }
  },

  start: function(){
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
    new Ajax.Request('/photo_tags/' + tagID, {
      method: 'delete',
      parameters: 'authenticity_token=' + encodeURIComponent(this.token),
      onSuccess: function(transport){
        if($('square_'+tagID)) $('square_'+tagID).remove();
        if($('content_'+tagID)) $('content_'+tagID).remove();
        $('tag_' + tagID).remove();
        this.tagInfos.unset(tagID);
      }.bind(this)
    });
  },

  save: function(){
    if(this.validate()){
      var params = "";
      params = $('tag_form').serialize();
      params += "&tag[tagged_user_id]=" + this.friendSelector.friendID;
      params += "&tag[x]=" + this.cropImg.areaCoords.x1;
      params += "&tag[y]=" + this.cropImg.areaCoords.y1;
      params += "&tag[width]=" + this.cropImg.calcW();
      params += "&tag[height]=" + this.cropImg.calcH();
      params += "&tag[photo_id]=" + this.photoID;
      params += "&tag[photo_type]=" + this.type;
      new Ajax.Request('/photo_tags', {
        method: 'post', 
        parameters: params,
        onSuccess: function(transport){
          this.friendSelector.reset();
          this.contentInput.clear();
          var tagInfo = transport.responseText.evalJSON();
          this.insertTag(tagInfo);
        }.bind(this)
      });
    } 
  },

  showNearestTagWithContent: function(event){
    var distance = 100000000;
    var tagID = -1;
    var photoX = this.photo.positionedOffset().left;
    var photoY = this.photo.positionedOffset().top;
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
    var info = $('content_' + tagID);
    if(square) square.hide();
    if(info) info.hide();
  },

  showTagWithContent: function(tagID){
    var tag = this.tagInfos.get(tagID);
    var pos = this.photo.positionedOffset();
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
      position: 'absolute',
      width: width + 'px',
      height: height + 'px',
      left: (x + pos.left) + 'px',
      top: (y + pos.top) + 'px',
      border: '2px solid #eeeeee',
      display: 'block',
      zIndex: 4});
    var info = $('content_' + tagID);
    if(!info){
      info = new Element('div', {id: 'content_' + tagID}).update(tag.content);
      document.body.appendChild(info);
    }
    info.setStyle({
      position: 'absolute',
      color: 'white',
      background: 'black',
      left: (x + width + pos.left) + 'px',
      top: (y + pos.top) + 'px',
      display: 'block',
      zIndex: 4});
  },

  reset: function(){
    this.cropImg.remove();
    this.controlPanel.hide();
    Event.observe(this.photo, 'mousemove', this.mousemoveBind);
  }

});

Iyxzone.Photo.Slide = Class.create({
  
  initialize: function(photoType, ids, urls, windowSize, frames, currentPhotoID){
    this.windowSize = windowSize; 
    this.photoType = photoType + 's'; 
    this.loadingImage = new Image();
    this.loadingImage.src = '/images/loading.gif';

    this.photoURLs = urls;
    this.photoIDs = ids;
    this.frames = frames;

    this.mappings = new Hash(); // photo id => image object

    if(this.photoIDs.length <= this.windowSize){
      var pos = Math.floor((this.windowSize - this.photoIDs.length)/2);
      for(var i=0;i<this.photoIDs.length;i++){
        this.loading(pos + i);
      }
      for(var i=0;i<this.photoIDs.length;i++){
        this.loadImage(pos + i, i);
      }
    }else{
      for(var i=0;i<this.photoIDs.length;i++){
        if(this.photoIDs[i] == currentPhotoID){
          this.pos = (i - Math.floor(windowSize/2) + this.photoIDs.length) % (this.photoIDs.length);
          break;
        }
      }
      for(var i=0;i<this.windowSize;i++){
        this.loading(i);
      }
      for(var i=0;i<this.windowSize;i++){
        this.loadImage(i, (this.pos + i) % (this.photoIDs.length));
      }
    }
  },

  loading: function(idx){
    this.frames[idx].innerHTML = "<img src='" + this.loadingImage.src + "'/>";
  },

  loadImage: function(idx, photoIdx){
    var img = this.mappings.get(this.photoIDs[photoIdx]);
    if(!img){
      img = new Image();
      img.src = this.photoURLs[photoIdx];
      this.mappings.set(this.photoIDs[photoIdx], img);
    }
    this.frames[idx].innerHTML = "<a href='http://localhost:3000/" + this.photoType + "/" + this.photoIDs[photoIdx] +"'><img src='" +  img.src +"' class='imgbox01' width=50 height=50/></a>";
  },

  next: function(){
    for(var i = 0; i < this.windowSize; i++){
      this.loading(i);
    }
    this.pos = (this.pos + 1) % (this.photoIDs.length);
    for(var i = 0; i < this.windowSize; i++){
      this.loadImage(i, (this.pos + i) % (this.photoIDs.length) );
    }
  },

  prev: function(){
    for(var i = 0; i < this.windowSize; i++){
      this.loading(i);
    }
    this.pos = (this.pos - 1 + this.photoIDs.length) % (this.photoIDs.length);
    for(var i = 0; i < this.windowSize; i++){
      this.loadImage(i, (this.pos + i) % (this.photoIDs.length) );
    }
  } 
});

// simply wrap a hash
Object.extend(Iyxzone.Photo.SlideManager, {
  
  mappings: new Hash(),

  set: function(key, slide){
    return this.mappings.set(key, slide);
  },

  get: function(key){
    return this.mappings.get(key);
  }

});
