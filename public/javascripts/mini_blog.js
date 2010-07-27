Iyxzone.MiniBlog = {
  version: '1.0',
  author: ['高侠鸿'],
  Forwarder: {},
  Builder: {},
  Presenter: {},
  Pub: {},
  Searcher: {},
  Slider: {},
  Topic: {},
  fetch: function(type, uid){
    var types = ['all', 'original', 'text', 'image', 'video'];

    for(var i=0;i<types.length;i++){
      $('mini_blog_category_' + types[i]).writeAttribute('class', '');
    }

    new Ajax.Request('/mini_blogs/list', {
      method: 'get',
      parameters: {type: type, uid: uid},
      onLoading: function(transport){
        $('mini_blog_category_' + type).addClassName("selected");
        $('mini_blogs_list').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"></div>';
      },
      onSuccess: function(transport){
        $('mini_blogs_list').innerHTML = transport.responseText;
        facebox.watchClickEvents();
      }
    });
  }
};

Object.extend(Iyxzone.MiniBlog.Topic, {

  form: null,

  cancel: function(){
    if(this.form){
      this.form.remove();
    }
  },

  new: function(link){
    var div = new Element('div');
    div.innerHTML = '<div class="topicAddIpt"><div class="fix"><a href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Topic.cancel();" class="icon-active right"/></div><div class="con fix"><input type="text" value="" id="new_topic_name" class="textfield"/><span class="button03"><span><button onclick="Iyxzone.MiniBlog.Topic.create($(this));">发布</button></span></span></div></div>';
    this.form = div.childElements()[0];
    $('topic_list_panel').appendChild(this.form);
      this.form.setStyle({
      position: 'abosulte',
      left: (link.positionedOffset().left - 124) + 'px',
      top: (link.positionedOffset().top) + 'px'
    });
    this.form.show();
  },

  create: function(btn){
    var name = $('new_topic_name').value;

    new Ajax.Request('/mini_topic_attentions', {
      method: 'post',
      parameters: {'attention[topic_name]': name},
      onLoading: function(){
//        Iyxzone.disableButton(btn, '发送中..');
      },
      onComplete: function(){
        this.cancel();
      }.bind(this),
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('topic_list').insert({bottom: this.getHTML(name, json.id)});
        }else{
          error('发生错误');
        }
      }.bind(this)
    });
  },

  destroy: function(id){
  
  },

  getHTML: function(name, id){
    return '<li><a href="/mini_blogs/search?key=' + encodeURIComponent(name) + '">' + name + '<em class="icon-active" onclick="Iyxzone.MiniBlog.Topic.destroy(' + id + ');"></em></a></li>';
  }

});

Object.extend(Iyxzone.MiniBlog.Forwarder, {

  checkTextLength: function(field, max){
    var value = field.value;
    var count = value.gsub(/[ |\r|\n|\t]+/, '').length;
    var delta = count - max;
    if(delta > 0){
      var len = value.length;
      for(var i=len-1;i>0;i--){
        if(!value.substr(i, i).match(/[ |\r|\n|\t]/)){
          delta--;
          if(delta == 0){
            field.value = value.substr(0, i);
            break;
          }
        }
      }
    }else{
      $('forward_words_count').innerHTML = (140 - count);
    }    
  },

  forward: function(id, button, at){
    new Ajax.Request('/mini_blogs/' + id + '/forward', {
      method: 'post',
      onLoading: function(transport){
        Iyxzone.disableButton(button, '发送..');
      },
      parameters: {at: at, content: $('forward_content').value}
    });
  }

});

Object.extend(Iyxzone.MiniBlog.Pub, {

  fetch: function(type){
    var types = ['hot', 'sexy', 'random', 'same_game'];
    
    for(var i=0;i<types.length;i++){
      $('mini_blog_category_' + types[i]).writeAttribute('class', '');
    }

    new Ajax.Request('/mini_blogs/' + type, {
      method: 'get',
      onLoading: function(transport){
        $('mini_blog_category_' + type).addClassName("hover");
        $('mini_blogs_list').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"></div>';
      },
      onSuccess: function(transport){
        $('mini_blogs_list').innerHTML = transport.responseText;
        facebox.watchClickEvents();
      }
    });
  }

});

Object.extend(Iyxzone.MiniBlog.Searcher, {
  
  filter: function(category){
    var url = window.location.href;
    var start = url.indexOf('key=');
    var end = url.indexOf('&', start+4);
    if(end < 0)
      end = url.length;
    var key = url.substr(start+4, end - (start+4));
 
    url = "/mini_blogs/search?key=" + key;
    if(category != 'all')
      url += '&category=' + category;
    window.location.href = url; 
  }

});

Object.extend(Iyxzone.MiniBlog.Slider, {

  miniBlogs: [], // each element is {mini blog content, poster id, poster login, poster fans count}

  curPos: 0,

  interval: 10000, // 10 seconds

  cache: [],
  
  init: function(panel, info){
    this.curPos = 0;
    this.miniBlogs = info;
    this.panel = panel;
    this.count = info.length;
    this.timer = null;
    this.cache = new Array(this.count);
    for(var i=0;i<this.count;i++){
      this.cache[i] = null;
    }
  },

  start: function(){
    if(this.miniBlogs.length == 0)
      return;
    this.panel.update(this.getHTML());
    this.curPos = 0;
    this.timer = setTimeout(this.showMiniBlog.bind(this), this.interval);
  },

  showMiniBlog: function(){
    // store html
    this.cache[this.curPos] = this.panel.innerHTML;

    // advance pos
    this.curPos = (this.curPos + 1) % this.count;

    // show new html
    this.panel.hide();
    this.panel.update(this.getHTML());
    new Effect.Appear(this.panel, {duration: 2.0});

    // advance pointer
    this.timer = setTimeout(this.showMiniBlog.bind(this), this.interval);
  },

  getHTML: function(){
    var html = this.cache[this.curPos];
    if(!html){
      html = this.constructHTML(this.miniBlogs[this.curPos]);
      this.cache[this.curPos] = html;
    }
    return html;
  },

  constructHTML: function(miniBlog){
    return '<div class="topImg"><img class="imgbox01" alt="" src="' + miniBlog.poster_avatar + '"/><div class="op"></div></div><div class="topCon"><h4 class="topSubTitle"><a href="/mini_blogs?uid=' + miniBlog.poster_id + '">' + miniBlog.poster_login + '</a></h4><div class="topSubText">' + miniBlog.content.substr(0, 100) + '...</div><div class="time">(' + miniBlog.time + ')</div></div>';
  }

});

Object.extend(Iyxzone.MiniBlog.Presenter, {

  cache: new Hash(),

  showVideo: function(id, thumbnail, embedHTML, forward){
    if(!this.cache.get(id)){
      this.cache.set(id, $('mini_blog_' + id + '_images').innerHTML);
    }

    // calc new width and height
    var embed = embedHTML.gsub(/width=\"\d+\"/, "width=380").gsub(/height=\"\d+\"/, "height=320");

    if(forward){
      $('mini_blog_' + id + '_images').update('<div class="sp op"><a class="w-l" href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Presenter.back(' + id + ')"><span class="i iToggleUp"></span>收起</a><div class="bd">' + embed + '</div>');
    }else{
      $('mini_blog_' + id + '_images').update('<div class="mConWrap"><div class="mConBgT"><div class="mConBgB"><div class="mCon fix"><div class="mTrans"><div class="hd"><div class="sp"><a href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Presenter.back(' + id + ')" ><span class="i iToggleUp"></span>收起</a></div></div><div>' + embed + '</div></div></div></div></div></div>');
    }
  },

  back: function(id){
    var html = this.cache.get(id);
    if(html){
      $('mini_blog_' + id + '_images').update(html);
    }
  },

  showImage: function(id, src, width, height, forward){
    if(!this.cache.get(id)){
      this.cache.set(id, $('mini_blog_' + id + '_images').innerHTML);
    }

    // calc height and width
    if(width > 380){
      height = height * 380 / width;
      width = 380;
    }

    if(forward){
      $('mini_blog_' + id + '_images').update('<div class="sp op"><a class="w-l" href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Presenter.back(' + id + ')"><span class="i iToggleUp"></span>收起</a><div class="bd"><img width="' + width + '" height="' + height + '" class="zoomIn" src="' + src + '" onclick="Iyxzone.MiniBlog.Presenter.back(' + id + ')"/></div>');
    }else{
      $('mini_blog_' + id + '_images').update('<div class="mConWrap"><div class="mConBgT"><div class="mConBgB"><div class="mCon fix"><div class="mTrans"><div class="sp"><a href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Presenter.back(' + id + ');"><span class="i iToggleUp"></span>收起</a></div><div class="bd"><img src="' + src + '" width=' + width + ' height=' + height + ' class="zoomOut" onclick="Iyxzone.MiniBlog.Presenter.back(' + id + ')" /></div></div></div></div></div>');
    }
  }

});

Object.extend(Iyxzone.MiniBlog.Builder, {

  category: 'text', // default is text

  imageID: null,

  imagePublishPanel: null,

  linkIDs: [],
  
  videoPusblishPanel: null,

  newEmotion: function(link, event){
    Emotion.Manager.toggleFaces(link, $('mini_blog_text_area'), event);
  },

  newImage: function(){
  },

  imageSelected: function(){
    $('publisher_image_form').submit();
    $('publisher_image').childElements()[0].update('正在上传图片');
  },

  imageUploaded: function(id, fileName, url){
    this.imageID = id;

    // show image name and delete icon
    var html = '<a href="#"><span class="i iPic"></span>' + fileName + '</a><a href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Builder.delImage(' + id + ');" class="icon-active"></a>';
  
    // show image preview
    html += '<div class="mBlogEditZ"><table class="trimBox"><tbody><tr><td></td><td class="arrUp"></td><td></td></tr><tr><td class="t-l"></td><td class="t-c"></td><td class="t-r"></td></tr><tr><td class="m-l">&nbsp;</td><td class="m-c"><img src="' + url + '"/></td><td class="m-r">&nbsp;</td></tr><tr><td class="b-l"></td><td class="b-c"></td><td class="b-r"></td></tr></tbody></table></div>';
    
    $('publisher_image').update(html);
  },

  delImage: function(id){
    new Ajax.Request('/mini_images/' + id, {
      method: 'delete',
      onLoading: function(transport){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(transport){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function (transport){
        var code = transport.responseText.evalJSON().code;
        if(code == 1){
          this.cancelImage();
          this.imagePublishPanel = null;
        }else if(code == 0){
          error('删除失败');
        }
      }.bind(this)
    });
  },

  cancelImage: function(){
    this.imageID = null;
    $('publisher_image').innerHTML = this.imagePublishPanel;
  },

  newVideo: function(){
    var div = new Element('div', {class: 'z-box mBlogEditV'});
    div.update('<div class="z-t"><div class="fix"><span class="l"><strong></strong></span><span class="r"></span></div><div class="arrUp"></div></div><div class="z-m rows s_clear"><div class="box01 s_clear"><div class="z-con"> <a href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Builder.cancelVideo()" class="icon-active"></a><div>请输入<a target="_blank" href="http://www.youku.com">优酷网</a>、<a target="_blank" href="http://www.tudou.com">土豆网</a>、<a target="_blank" href="http://video.sina.com.cn">新浪播客</a>、<a target="_blank" href="http://www.ku6.com/">酷6网</a>等视频网站的视频播放页链接</div><div class="fix space"><span class="textfield w-l"><input type="text" id="publisher_video_url" onclick="$(this).clear();" value="http://"/></span><span class="button"><span><button onclick="Iyxzone.MiniBlog.Builder.createVideo();" id="publisher_video_url_btn">确定</button></span></span></div></div></div><div class="bg"></div></div><div class="z-b"><span class="l"><strong></strong></span><span class="r"></span></div>');
    $('publisher_video').appendChild(div);
    this.videoPublishPanel = div;
  },

  createVideo: function(){
    new Ajax.Request('/mini_links', {
      parameters: {url: $('publisher_video_url').value},
      onLoading: function(transport){
        Iyxzone.disableButton($('publisher_video_url_btn'), '确定');
      },
      onComplete: function(transport){
        Iyxzone.enableButton($('publisher_video_url_btn'), '确定');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.video == 1){
          Iyxzone.insertAtCursor($('mini_blog_text_area'), json.url + " ");
          this.cancelVideo();
        }else{
          var div = new Element('div');
          div.update('<div class="space red">无法识别的视频url</div><div class="space"><a href="javascript:void(0)" onclick="Iyxzone.MiniBloger.Builder.cancelVideo();" class="red">取消操作</a> 或者 <a href="javascript:void(0)" onclick="Iyxzone.insertAtCursor($(\'mini_blog_text_area\'), \'' + json.url + ' \');Iyxzone.MiniBlog.Builder.cancelVideo();">作为普通连接发布</a></div>');
          $('publisher_video_url').up().up().up().appendChild(div);
        }
      }.bind(this)
    });
  },

  cancelVideo: function(){
    this.videoPublishPanel.remove();
  },

  newTopic: function(){
    var str = '#请在这里输入自定义话题#';
    Iyxzone.insertAtCursor($('mini_blog_text_area'), str);
    var start = Iyxzone.getCurPos($('mini_blog_text_area'));
    if(start >= 0){
      Iyxzone.selectText($('mini_blog_text_area'), (start - str.length + 1), start  - 1);
    }
  },

  publish: function(at){
    if($('mini_blog_text_area').value.gsub(/[ |\r|\n|\t]+/, '').length == 0){
      notice('写点什么吧，求你了～～');
      return;
    } 
    
    new Ajax.Request('/mini_blogs', {
      method: 'post',
      parameters: {'mini_blog[content]': $('mini_blog_text_area').value, 'mini_image_id': this.imageID, 'at': at},
      onLoading: function(transport){
        Iyxzone.disableButtonThree($('publish_btn'), '发送..');
      },
      onComplete: function(transport){
        Iyxzone.enableButtonThree($('publish_btn'), '发布');
      },
      onSuccess: function(transport){
        if(this.imageID){
          this.cancelImage();
        }
        $('mini_image_uploaded_data').clear();
        $('mini_blog_text_area').clear();
        $('mini_blog_text_area').focus();
      }.bind(this)
    });
  },

  init: function(text){
    $('mini_image_uploaded_data').clear();
    this.imagePublishPanel = $('publisher_image').innerHTML;

    if(text){
      Iyxzone.insertAtCursor($('mini_blog_text_area'), text);
    }
  },

  checkTextLength: function(field, max){
    var value = field.value;
    var count = value.gsub(/[ |\r|\n|\t]+/, '').length;
    var delta = count - max;
    if(delta > 0){
      var len = value.length;
      for(var i=len-1;i>0;i--){
        if(!value.substr(i, i).match(/[ |\r|\n|\t]/)){
          delta--;
          if(delta == 0){
            field.value = value.substr(0, i);
            break;
          }
        }
      }
    }else{
      $('mini_blog_words_count').innerHTML = (140 - count);
    }
  } 
});
