Iyxzone.MiniBlog = {
  version: '1.0',
  
  author: ['高侠鸿'],
  
  Forwarder: {},
  
  Builder: {},
  
  Presentor: {},
  
  Pub: {},
  
  Searcher: {},
  
  Slider: {},
  
  Topic: {},

  Category: {}

};

// follow idol in mini blog page
Object.extend(Iyxzone.MiniBlog, {

  confirmFollowingIdol: function(idolID, login, btn){
    Iyxzone.Facebox.confirmWithCallback("你确定要成为 <b>" + login + "</b> 的粉丝吗? 这样你可以在主页上看到他的新鲜事", null, null, function(){
      this.followIdol(idolID, login, btn);
    });
  },

  followIdol: function(idolID, login, btn){
    new Ajax.Request(Iyxzone.URL.followIdol(idolID), {
      method: 'post',
      onLoading: function(){
        btn.writeAttribute('onclick', '');
      },
      onComplete: function(){},
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          alert('成功');
          btn.writeAttribute('onclick', 'alert("你已经是粉丝了");');
        }else if(json.code == 0){
          error('发生错误，请稍后再试试');
          btn.writeAttribute('onclick', 'Iyxzone.MiniBlog.confirmFollowingIdol(' + idolID + ',' + '"' + login + '", this);');
        }
      }.bind(this)
    });
  }

});

Object.extend(Iyxzone.MiniBlog.Category, {

  url: null,

  curTab: null,

  cache: new Hash(),

  init: function(type, url){
    this.cache.set(type, $('mini_blogs_list').innerHTML);
    this.setTab(type);
    this.setUrl(url);
  },

  setUrl: function(url){
    this.url = url;
  },

  setTab: function(type){
    this.curTab = type;

    var types = ['all', 'original', 'text', 'image', 'video'];

    for(var i=0;i<types.length;i++){
      $('mini_blog_category_' + types[i]).writeAttribute('class', '');
    }

    $('mini_blog_category_' + type).addClassName("selected");   
  },

  loading: function(){
    $('mini_blogs_list').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"></div>';
  },

  fetch: function(type){
    this.cache.set(this.curTab, $('mini_blogs_list').innerHTML);

    this.setTab(type);
    
    var info = this.cache.get(type);
    if(info){
      $('mini_blogs_list').innerHTML = info;
      return;
    }

    new Ajax.Request(this.url, {
      method: 'get',
      parameters: {type: type},
      onLoading: function(transport){
        this.loading();
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set(type, transport.responseText);
        if(this.curTab == type){
          $('mini_blogs_list').innerHTML = transport.responseText;
        }
      }.bind(this)
    });
  }
});

Object.extend(Iyxzone.MiniBlog.Topic, {

  form: null,

  cancel: function(){
    if(this.form){
      this.form.remove();
    }
  },

  newTopic: function(link){
    $('topic_list_panel').insert({bottom: '<div class="topicAddIpt"><div class="fix"><a href="#" onclick="Iyxzone.MiniBlog.Topic.cancel();" class="icon-active right"></a></div><div class="con fix"><input type="text" id="new_topic_name" value="请添加关注的话题" class="textfield"/><span class="button03"><span><button onclick="Iyxzone.MiniBlog.Topic.create($(this));">发布</button></span></span></div></div>'});
    var children = $('topic_list_panel').childElements();
    this.form = children[children.length - 1];
    this.form.setStyle({
      'position': 'absolute',
      'left': (link.cumulativeOffset().left - 180) + 'px',
      'top': (link.cumulativeOffset().top) + 'px'
    });
    this.form.show();
  },

  create: function(btn){
    var name = $('new_topic_name').value;
    new Ajax.Request('/mini_topic_attentions', {
      method: 'post',
      parameters: {'name': name},
      onLoading: function(){
        Iyxzone.disableButton(btn, '...');
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
    new Ajax.Request('/mini_topic_attentions/' + id, {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('attention_' + id).remove();
        }else{
          tip('发生错误');
        }
      }.bind(this)
    });
  },

  getHTML: function(name, id){
    return '<li id="attention_' + id + '"><a href="javascript:void(0)"><strong onclick="window.location.href = \'/mini_blogs/search?key=' + encodeURIComponent(name) + '\';">' + name + '</strong><em class="icon-active" onclick="Iyxzone.MiniBlog.Topic.destroy(' + id + ');"></em></a></li>';
  },

  // 下面2个用于搜索结果页面
  follow: function(name){
    new Ajax.Request('/mini_topic_attentions', {
      method: 'post',
      parameters: {'name': name},
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      }.bind(this),
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('follow_topic').update('<a onclick="Iyxzone.MiniBlog.Topic.unfollow(' + json.id + ');; return false;" href="#"><span class="i iNoFollow"></span>取消关注该话题（已经关注）</a>');
        }else{
          error('发生错误');
        }
      }.bind(this)
    });
  },

  unfollow: function(name, id){
    new Ajax.Request('/mini_topic_attentions/' + id, {
      method: 'delete',
      onLoading: function(){
        Iyxzone.changeCursor('wait');
      },
      onComplete: function(){
        Iyxzone.changeCursor('default');
      },
      onSuccess: function(transport){
        var json = transport.responseText.evalJSON();
        if(json.code == 1){
          $('follow_topic').update('<a onclick="Iyxzone.MiniBlog.Topic.follow(\'' + name + '\'); return false;" href="#"><span class="icon-friend02"></span>关注该话题</a>');
        }else{
          tip('发生错误');
        }
      }.bind(this)
    });
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
        if(!/[ |\r|\n|\t]/.exec(value.substr(i,i))){
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

  curTab: null,

  cache: new Hash(),

  init: function(type){
    this.curTab = type;
    this.cache.set(type, $('mini_blogs_list').innerHTML);
  },

  setTab: function(type){
    var types = ['recent','hot', 'sexy', 'random', 'same_game'];
    
    for(var i=0;i<types.length;i++){
      $('mini_blog_category_' + types[i]).writeAttribute('class', '');
    }

    $('mini_blog_category_' + type).addClassName('hover');

    this.curTab = type;    
  },

  loading: function(type){
    $('mini_blogs_list').innerHTML = '<div class="ajaxLoading"><img src="/images/ajax-loader.gif"></div>';
  },

  fetch: function(type){
    this.cache.set(this.curTab, $('mini_blogs_list').innerHTML);

    this.setTab(type);

    var info = this.cache.get(type);
    if(info){
      $('mini_blogs_list').innerHTML = info;
      return;
    }

    new Ajax.Request('/mini_blogs/' + type, {
      method: 'get',
      onLoading: function(transport){
        this.loading();
      }.bind(this),
      onSuccess: function(transport){
        this.cache.set(type, transport.responseText);
        if(type == this.curTab){
          $('mini_blogs_list').innerHTML = transport.responseText;
        }
      }.bind(this)
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

Object.extend(Iyxzone.MiniBlog.Presentor, {

  cache: new Hash(),

  showVideo: function(id, url, thumbnail, embedHTML){
    var panel = $('mb_' + id + '_img');
    var origCon = panel.previous();
    
    this.cache.set(id, panel.innerHTML);

    var width = panel.getWidth() - 20;
    var height = width * 320 / 380;
    var embed = embedHTML.gsub(/width=\"\d+\"/, "width=" + width).gsub(/height=\"\d+\"/, "height="+height);

    var html = '';
    html += '<div class="round02 round_r_t s-dialog" id="mb_' + id + '_img"><div class="round_l_t"><div class="round_r_b"><div class="round_l_b"><div class="round_m jl-round_m"><div class="round_body">';
    html += '<div class="mCon fix">';
    html += '<div class="op"><a class="w-l" href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Presentor.showPreview(' + id + ')"><span class="i iToggleUp"></span>收起</a><a href="' + url + '" target="_blank"><span class="i iViewOrig"></span>查看原视频</a></div>';
    html += '<div class="bd">' + embed + '</div>';
    html += '</div>';
    html += '</div></div></div></div></div></div>';

    panel.remove();
    Element.insert(origCon, {'after': html}); 
  },

  showImage: function(id, src, width, height){
    var panel = $('mb_' + id + '_img');
    var origCon = panel.previous();
    
    this.cache.set(id, panel.innerHTML);

    var panelWidth = panel.getWidth();
    if(width > panelWidth - 20){
      height = (panelWidth - 20) * height / width;
      width = panelWidth - 20;
    }

    var html = '';
    html += '<div class="round02 round_r_t s-dialog" id="mb_' + id + '_img"><div class="round_l_t"><div class="round_r_b"><div class="round_l_b"><div class="round_m jl-round_m"><div class="round_body">';
    html += '<div class="mCon fix">';
    html += '<div class="op"><a class="w-l" href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Presentor.showPreview(' + id + ')"><span class="i iToggleUp"></span>收起</a><a href="' + src + '" target="_blank"><span class="i iViewOrig"></span>查看原图</a></div>';
    html += '<div class="bd"><img width="' + width + '" height="' + height + '" alt="" class="zoomIn" src="' + src + '"/><div>';
    html += '</div>';
    html += '</div></div></div></div></div></div>';

    panel.remove();
    Element.insert(origCon, {'after': html}); 
  },

  showPreview: function(id){
    var html = this.cache.get(id);
    if(html){
      var panel = $('mb_' + id + '_img');
      var origCon = panel.previous();
      var origHTML = '<div class="mCon fix" id="mb_' + id + '_img">' + html + '</div>';
      panel.remove();
      Element.insert(origCon, {'after': origHTML});
    }
  },

  showVideoInForward: function(id, url, thumbnail, embedHTML){
    var panel = $('mb_' + id + '_img');
    var hd = panel.previous();

    this.cache.set(id, panel.innerHTML);

    // calc new width and height
    var width = panel.getWidth() - 20;
    var height = (width * 320) / 380;
    var embed = embedHTML.gsub(/width=\"\d+\"/, "width=" + width).gsub(/height=\"\d+\"/, "height="+height);
    
    var op = '<div class="op"><a class="w-l" href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Presentor.showPreviewInForward(' + id + ')"><span class="i iToggleUp"></span>收起</a><a href="javascript:void(0)" target="_blank" href="' + url + '"><span class="i iViewOrig"></span>查看原视频</a></div>';
    panel.update(embed);
    Element.insert(panel, {'before': op});
    hd.addClassName('jl-cutline');
  },

  showImageInForward: function(id, src, width, height){
    var panel = $('mb_' + id + '_img');
    var hd = panel.previous();

    this.cache.set(id, panel.innerHTML);

    // calc height and width
    var panelWidth = panel.getWidth();
    if(width > panelWidth - 40){
      height = height * (panelWidth - 40) / width;
      width = panelWidth - 40;
    }

    var op = '<div class="op"><a class="w-l" href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Presentor.showPreviewInForward(' + id + ')"><span class="i iToggleUp"></span>收起</a><a href="javascript:void(0)" target="_blank" href="' + src + '"><span class="i iViewOrig"></span>查看原图</a></div>';
    panel.update('<img width="' + width + '" height="' + height + '" class="zoomIn" src="' + src + '" onclick="Iyxzone.MiniBlog.Presentor.back(' + id + ')"/>');
    Element.insert(panel, {'before': op});
    hd.addClassName('jl-cutline');
  },

  showPreviewInForward: function(id){
    var html = this.cache.get(id);
    if(html){
      var panel = $('mb_' + id + '_img');
      var hd = panel.previous();
      panel.update(html);
      panel.previous().remove();
      hd.writeAttribute('class', 'hd');
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
    var html = '<a href="#"><span class="i iPic"></span>' + fileName.substr(0,10) + '</a><a href="javascript:void(0)" onclick="Iyxzone.MiniBlog.Builder.delImage(' + id + ');" class="icon-active"></a>';
    $('publisher_image').update(html);
 
    // show image preview
    var div = new Element('div', {'class': "mBlogEditZ", 'id':"publisher_image_preview"});
    div.update('<table class="trimBox"><tbody><tr><td></td><td class="arrUp"></td><td></td></tr><tr><td class="t-l"></td><td class="t-c"></td><td class="t-r"></td></tr><tr><td class="m-l">&nbsp;</td><td class="m-c"><img src="' + url + '"/></td><td class="m-r">&nbsp;</td></tr><tr><td class="b-l"></td><td class="b-c"></td><td class="b-r"></td></tr></tbody></table></div>');
    document.body.appendChild(div); 
  
    div.setStyle({
      'position': 'absolute',
      'zIndex': 1001,
      'left': $('publisher_image').cumulativeOffset().left + 'px',
      'top': ($('publisher_image').cumulativeOffset().top + 20) + 'px'
    });
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
    $('publisher_image_preview').remove();
  },

  newVideo: function(){
    var div = new Element('div', {'class': 'z-box mBlogEditV'});
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
      $('mini_blog_text_area').focus();
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
        if(!/[ |\r|\n|\t]/.exec(value.substr(i,i))){
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
