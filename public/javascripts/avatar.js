Iyxzone.Avatar = {

  version: '1.4',

  author: '高侠鸿',

  Builder: {}

};

// edit, update photo, set cover
Object.extend(Iyxzone.Avatar, {

  updatePhoto: function(at, btn, form, photoID, albumID){
    // check description
    var desc = $('photo_notation').value;
    if(desc.value != '' && desc.length > this.wrapHeight){
      $('errors').innerHTML = "照片描述最长this.wrapHeight个字";
      return;
    }
    
    new Ajax.Request(Iyxzone.URL.updateAvatar(photoID), {
      method: 'put',
      parameters: $(form).serialize(),
      onLoading: function(){
        Iyxzone.disableButton(btn, "请等待..");
      },
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          if(at == 'album'){
            window.location.href = Iyxzone.URL.showAvatarAlbum(albumID);
          }else if(at == 'photo'){
            window.location.href = Iyxzone.URL.showAvatar(photoID);
          }
        }else if(json.code == 0){
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  deletePhoto: function(photoID, albumID){
    new Ajax.Request(Iyxzone.URL.deleteAvatar(photoID), {
      method: 'delete',
      onLoading: function(){},
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = Iyxzone.URL.showAvatarAlbum(albumID);
        }else{
          error("发生错误，请稍后再试");
        }
      }.bind(this)
    });
  },

  confirmDeletingPhoto: function(photoID, albumID){
    Iyxzone.Facebox.confirmWithCallback("你确定要删除这张图片吗", null, null, function(){
      this.deletePhoto(photoID, albumID);
    }.bind(this));
  }

});

Object.extend(Iyxzone.Avatar.Builder, {

  cropper: null,

  smallPreviewOptions: null, // cropper options for small preview

  smallPreviewSize: null, // size of small preview

  largePreviewOptions: null, // cropper options for large preview

  largePreviewSize: null, // size of large preview

  curMode: null, // 'large' or 'small'

  origWidth: null, // origin width of img
  
  origHeight: null, // origin height of img

  width: null, // current width of img

  height: null, // current height of img

  ratio: null, // ratio of img

  src: null, // img src

  name: null, // img filename

  wrapWidth: null, // panel width

  wrapHeight: null, // panel height

  editLarge: function(){
    if(this.curMode == 'large')
      return;

    $$('div[class="avtL"]')[0].writeAttribute('class', 'avtL selected');
    $$('div[class="avtM selected"]')[0].writeAttribute('class', 'avtM');    
    this.curMode = 'large';
    this.smallPreviewOptions.onloadCoords = this.cropper.areaCoords;
    this.resetCropper(this.largePreviewOptions);
  },

  editSmall: function(){
    if(this.curMode == 'small')
      return;

    $$('div[class="avtL selected"]')[0].writeAttribute('class', 'avtL');
    $$('div[class="avtM"]')[0].writeAttribute('class', 'avtM selected');    
    this.curMode = 'small';
    this.largePreviewOptions.onloadCoords = this.cropper.areaCoords;
    this.resetCropper(this.smallPreviewOptions);
  },

  imageSelected: function(){
    $('avatar_form').submit();

    $('desc').hide();

    // build avatar edit panel
    var div = new Element('div', {'class': "box04 avtEditor", 'id': 'editor'});
    div.update("<div class='ajaxLoading'><img src='/images/ajax-loader.gif'/></div>");
    $('panel').appendChild(div);
  
    Iyxzone.changeCursor('wait');
  },

  buildEditPanel: function(){
    var html = '';
    html += '<div class="tips">拖动下方方框，调整头像显示</div>';
    html += '<div class="avtWrap fix">';
    html += '<div class="panel">';
    html += '<div class="edt"><img id="avatar-img" src="' + this.src + '" alt="" width="' + this.width + '" height="' + this.height + '"></div>';
    html += '<div class="zoomBar">';
    html += '</div>';
    html += '</div>';
    html += '<div class="preview">';
    html += '<div class="avtM selected">';
    html += '<div class="bd">';
    html += '<a href="javascript:void(0)"><span class="i iArrLeft"></span><div id="smallPreview"></div></a>';
    html += '</div>';
    html += '<div class="ft"><span>小头像预览</span><a href="javascript:void(0)" class="op" onclick="Iyxzone.Avatar.Builder.editSmall();">编辑</a></div>';
    html += '</div>';
    html += '<div class="avtL">';
    html += '<div class="bd">';
    html += '<a href="javascript:void(0)"><span class="i iArrLeft"></span><div id="largePreview" style="width:' + this.largePreviewSize + "px;height:" + this.largePreviewSize + 'px"></div></a>';  
    html += '</div>';
    html += '<div class="ft"><span>大头像预览</span><a href="javascript:void(0)" class="op" onclick="Iyxzone.Avatar.Builder.editLarge();">编辑</a></div>';
    html += '</div>';
    html += '</div>';
    html += '</div>';
    html += '<div class="submit fix">';
    html += '<span class="button04"><span>';
    html += '<button onclick="Iyxzone.Avatar.Builder.saveStep1();">生成头像</button>';
    html += '</span></span>';
    html += '</div>';
                    
    $('editor').update(html);        
  },

  calcWH: function(){
    if(this.origWidth <= this.wrapWidth && this.origHeight <= this.wrapHeight){
      this.ratio = 1;
      this.width = this.origWidth;
      this.height = this.origHeight;
    }else if(this.origWidth <= this.wrapWidth && this.origHeight > this.wrapHeight){
      this.ratio = this.origHeight / this.wrapHeight;
      this.height = this.wrapHeight;
      this.width = this.origWidth / this.ratio;
    }else if(this.origHeight > this.wrapWidth && this.origHeight <= this.wrapHeight){
      this.ratio = this.origWidth / this.wrapWidth;
      this.width = this.wrapWidth;
      this.height = this.origHeight / this.ratio;
    }else{
      var ratio1 = this.origWidth / this.wrapWidth;
      var ratio2 = this.origHeight / this.wrapHeight;
      if(ratio2 > ratio1){
        this.ratio = ratio2;
      }else{
        this.ratio = ratio1;
      }
      this.width = this.origWidth / this.ratio;
      this.height = this.origHeight / this.ratio;
    }
  },

  imageUploaded: function(id, src, name, width, height){
    var comp, size, x1, y1, x2, y2;

    Iyxzone.changeCursor('default');

    this.avatarID = id;
    this.src = src;
    this.name = name;
    this.origWidth = width;
    this.origHeight = height;
    
    this.calcWH();

    this.buildEditPanel();

    comp = (this.width < this.height) ? this.width : this.height;
    size = (comp < this.smallPreviewSize) ? comp : this.smallPreviewSize;
    x1 = (this.width - size) / 2;
    y1 = (this.height - size) / 2;
    x2 = (this.width + size) / 2;
    y2 = (this.height + size) /2; 

    this.smallPreviewOptions = {
      'previewWrap': 'smallPreview', 
      'previewWidth': this.smallPreviewSize,
      'previewHeight': this.smallPreviewSize,
      'minWidth': size,
      'minHeight': size,
      'ratioDim': {'x': size, 'y': size},
      'onloadCoords': {'x1': x1, 'y1': y1, 'x2': x2, 'y2': y2},
      'locateImgWrap': function(imgWrap){
        imgWrap.setStyle({'left': ((this.wrapWidth-this.width)/2) + 'px', 'top': ((this.wrapHeight-this.height)/2) + 'px'});
      }.bind(this)
    };
   
    size = (comp < this.largePreviewSize) ? comp : this.largePreviewSize;
    x1 = (this.width - size) / 2;
    y1 = (this.height - size) / 2;
    x2 = (this.width + size) / 2;
    y2 = (this.height + size) /2; 

    this.largePreviewOptions = {
      'previewWrap': 'largePreview',
      'previewWidth': this.largePreviewSize,
      'previewHeight': this.largePreviewSize,
      'minWidth': size,
      'minHeight': size,
      'ratioDim': {'x': size, 'y': size}, 
      'onloadCoords': {'x1': x1, 'y1': y1, 'x2': x2, 'y2': y2},
      'locateImgWrap': function(imgWrap){
        imgWrap.setStyle({'left': ((this.wrapWidth-this.width)/2) + 'px', 'top': ((this.wrapHeight-this.height)/2) + 'px'});
      }.bind(this)
    };
    
    this.cropper = new Cropper.ImgWithPreview('avatar-img', this.smallPreviewOptions);
    this.curMode = 'small';

    // set large preview manually
    // 这时候的x1, y1, x2, y2是large preview的
    $('largePreview').addClassName('imgCrop_previewWrap');
    var img = new Element('img', {'src': this.src, 'width': (this.width/size)*this.largePreviewSize, 'height': (this.height/size)*this.largePreviewSize, 'style': "left: -" + (this.largePreviewSize/size)*x1 + 'px;top:-' + (this.largePreviewSize/size)*y1 + 'px;'});
    $('largePreview').appendChild(img);
  },

  resetCropper: function(options){
    this.cropper.options = Object.extend(this.cropper.options, options || {});
    this.cropper.remove();
    this.cropper.reset();
  },

  buildSavePanel: function(){
    var smallCoords = null;
    var largeCoords = null;
    var sRatio = {};
    var lRatio = {};
    var html = '';
    
    smallCoords = (this.curMode == 'small') ? this.cropper.areaCoords : this.smallPreviewOptions.onloadCoords;
    largeCoords = (this.curMode == 'large') ? this.cropper.areaCoords : this.largePreviewOptions.onloadCoords;

    sRatio.x = (smallCoords.x2 - smallCoords.x1) / this.smallPreviewSize;
    sRatio.y = (smallCoords.y2 - smallCoords.y1) / this.smallPreviewSize;
    lRatio.x = (largeCoords.x2 - largeCoords.x1) / this.largePreviewSize;
    lRatio.y = (largeCoords.y2 - largeCoords.y1) / this.largePreviewSize;

    html += '<div class="tips">系统为你生成两种尺寸的头像</div>';
    html += '<div class="avtWrap fix">';
    html += '<div class="avtShowM">';
    html += '你的小头像<br/>';
    html += '<div style="width:' + this.smallPreviewSize + 'px;height:' + this.smallPreviewSize + 'px;"><img alt="" src="' + this.src + '" style="width:' + (this.width/sRatio.x) + 'px;height:' + (this.height/sRatio.y) + 'px;left:-' + (smallCoords.x1/sRatio.x) + 'px;top:-' + (smallCoords.y1/sRatio.y) + 'px"   /></div>';
    html += '</div>';
    html += '<div class="avtShowL">';
    html += '你的大头像将出现在个人主页<br/>';
    html += '<div style="width:' + this.largePreviewSize + 'px;height:' + this.largePreviewSize + 'px;"><img alt="" src="' + this.src + '" style="width:' + (this.width/lRatio.x) + 'px;height:' + (this.height/lRatio.y) + 'px;left:-' + (largeCoords.x1/lRatio.x) + 'px;top:-' + (largeCoords.y1/lRatio.y) + 'px"   /></div>';
    html += '</div>';
    html += '</div>';
    html += '<div class="submit fix">';
    html += '<span class="button04 w-l"><span>';
    html += '<button onclick="Iyxzone.Avatar.Builder.saveStep2(this);">保存头像</button>';
    html += '</span></span>';
    html += '<span class="button04 button04-gray"><span>';
    html += '<button onclick="Iyxzone.Avatar.Builder.backToEdit();">返回编辑</button>';
    html += '</span></span>';
    html += '</div>';
    html += '</div>';

    $('save-avatar').update(html);
  },

  saveStep1: function(){
    $('editor').hide();

    if($('save-avatar') == null){
      var div = new Element('div', {'id': 'save-avatar', 'class': 'box04 avtResult'});
      div.update('<div class="ajaxLoading"><img src="/images/ajax-loader.gif"/></div>');
      $('panel').appendChild(div);
    }

    this.buildSavePanel();
    $('save-avatar').show();
  },

  saveStep2: function(btn){
    var smallCoords = null;
    var largeCoords = null;
    var params = "";
    var editBtn = null;
    var x1, y1, x2, y2;

    smallCoords = (this.curMode == 'small') ? this.cropper.areaCoords : this.smallPreviewOptions.onloadCoords;
    largeCoords = (this.curMode == 'large') ? this.cropper.areaCoords : this.largePreviewOptions.onloadCoords;
    x1 = smallCoords.x1 * this.ratio;
    x2 = smallCoords.x2 * this.ratio;
    y1 = smallCoords.y1 * this.ratio;
    y2 = smallCoords.y2 * this.ratio;
    params += "small[x1]=" + x1 + "&small[x2]=" + x2 + "&small[y1]=" + y1 + "&small[y2]=" + y2;
    x1 = largeCoords.x1 * this.ratio;
    x2 = largeCoords.x2 * this.ratio;
    y1 = largeCoords.y1 * this.ratio;
    y2 = largeCoords.y2 * this.ratio;
    params += "&large[x1]=" + x1 + "&large[x2]=" + x2 + "&large[y1]=" + y1 + "&large[y2]=" + y2;
    params += "&authenticity_token=" + encodeURIComponent(this.token);
    editBtn = $(btn).up().up().next().down('button');

    new Ajax.Request(Iyxzone.URL.cropAvatar(this.avatarID), {
      method: 'put',
      parameters: params,
      onLoading: function(){
        Iyxzone.disableButton(btn, '正在保存.');
        Iyxzone.disableButton(editBtn, '返回编辑');        
        Iyxzone.changeCursor('wait'); 
      }.bind(this),
      onComplete: function(){
        Iyxzone.changeCursor('default');
      }.bind(this),
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          window.location.href = this.successURL;
        }else if(json.code == 0){
          error("保存的时候发生错误");
          Iyxzone.enableButton(btn, '正在保存.');
          Iyxzone.enableButton(editBtn, '返回编辑');        
        }
      }.bind(this)
    });
  },

  backToEdit: function(){
    $('save-avatar').hide();
    $('editor').show();
  },

  init: function(token, wrapWidth, wrapHeight, smallPreviewSize, largePreviewSize, successURL){
    this.token = token;
    this.wrapWidth = wrapWidth;
    this.wrapHeight = wrapHeight;
    this.smallPreviewSize = smallPreviewSize;
    this.largePreviewSize = largePreviewSize;
    this.successURL = successURL;
  }

});

