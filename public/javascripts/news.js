Iyxzone.News = {
  version: '1.0',
  author: ['李玉山'],
  Builder: {}
};

Object.extend(Iyxzone.News.Builder, {

  editor: null,

  swfuploader: null, 

  validateTextNews: function() {
    if ($('news_title').value == '') {
      error("请填写标题")
      return false;
    }
    if ($('news_title').length > 300) {
      error("标题最长为300个字节")
      return false;
    }
    if ($('news_data').value == '') {
      error("请填写内容")
      return false;
    }
    if ($('news_data').length > 10000) {
      error("内容最长为10000个字节")
      return false;
    }
    if ($('news_game_id').value == '') {
      error("请选择与新闻相关的游戏")
      return false;
    }
    return true;
  },

  validateVideoNews: function() {
    if ($('news_title').value == '') {
      error("请填写标题")
      return false;
    }
    if ($('news_title').length > 300) {
      error("标题最长为300个字节")
      return false;
    }
    if ($('news_video_url').value == '') {
      error("请填写视频url")
      return false;
    }
    if ($('news_game_id').value == '') {
      error("请选择与新闻相关的游戏")
      return false;
    }
    return true;
  },

  validatePictureNews: function(){
    if ($('news_title').value == '') {
      error("请填写标题")
      return false;
    }
    if ($('news_title').length > 300) {
      error("标题最长为300个字节")
      return false;
    }
    if ($('news_data').value == '') {
      error("请填写新闻描述")
      return false;
    }
    if ($('news_game_id').value == '') {
      error("请选择与新闻相关的游戏")
      return false;
    }
    return true;    
  },

  prepare: function(form) {
    for(var i=0; i<this.editor.nicInstances.length; i++) {
      this.editor.nicInstances[i].saveContent();
    }
    this.parameters = $(form).serialize();
  },

  saveTextNews: function(button, form){
    Iyxzone.disableButtonThree(button, '发布中..');
    if(this.validateTextNews()) {
      this.prepare(form);
      new Ajax.Request('/admin/news', {
        method: 'post',
        parameters: this.parameters,
        onSuccess: function(transport){
          var news = transport.responseText.evalJSON();
          if(news.id < 0){
            error('发生错误');
          }else{
            window.href.location = '/admin/news';
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '发布');
    }
  },

  updateTextNews: function(button, newsID, form){
    Iyxzone.disableButtonThree(button, '修改中..')
    if (this.validateTextNews()) {
      this.prepare(form);
      new Ajax.Request('/admin/news/' + newsID, {
        method: 'put',
        parameters: this.parameters,
        onSuccess: function(transport){
          var news = transport.responseText.evalJSON();
          if(news.id < 0){
            error('发生错误');
          }else{
            window.href.location = '/admin/news';
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '修改');
    }
  },

  saveVideoNews: function(button, form){
    Iyxzone.disableButtonThree(button, '发布中..');
    if(this.validateVideoNews()) {
      new Ajax.Request('/admin/news', {
        method: 'post',
        parameters: $(form).serialize(),
        onSuccess: function(transport){
          var news = transport.responseText.evalJSON();
          if(news.id < 0){
            error('发生错误');
          }else{
            window.href.location = '/admin/news';
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '发布');
    }
  },

  updateVideoNews: function(button, newsID, form){
    Iyxzone.disableButtonThree(button, '修改中..');
    if(this.validateVideoNews()) {
      new Ajax.Request('/admin/news/' + newsID, {
        method: 'put',
        parameters: $(form).serialize(),
        onSuccess: function(transport){
          var news = transport.responseText.evalJSON();
          if(news.id < 0){
            error('发生错误');
          }else{
            window.href.location = '/admin/news';
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '修改');
    }
  },

  savePictureNews: function(button, form){
    Iyxzone.disableButtonThree(button, '发布中..');
    if(this.validatePictureNews()) {
      new Ajax.Request('/admin/news', {
        method: 'post',
        parameters: $(form).serialize(),
        onSuccess: function(transport){
          var news = transport.responseText.evalJSON();
          if(news.id < 0){
            error('发生错误');
          }else{
            this.uploadNewsPictures(news.id);
          }
        }.bind(this)
      });
    }else{
      Iyxzone.enableButtonThree(button, '发布');
    }
  },

  uploadNewsPictures: function(newsID){
    this.swfuploader.startUpload();
  },

  expand: function(data){
    $('news-data').update(data);
    $('news-expand').hide();
    $('news-hide').show();
  },

  hide: function(data){
    $('news-data').update(data);
    $('news-expand').show();
    $('news-hide').show();
  },

  initTextNews: function(textAreaID, token, albumInfos){
    this.editor = new nicEditor().panelInstance(textAreaID);
    nicEditors.albums = albumInfos;
    nicEditors.authenticity_token = token;
  },

  initPictureNews: function(token){
    // setup swfuploader
    swfu = new Iyxzone.News.Builder.SWFUploader(token);
  },

  SWFUploader: Class.create({

    swfu: null,

    initialize: function(token){
      this.token = token;

      this.settings = {
        flash_url : "/flash/swfupload.swf",
        upload_url: "/admin/news/images",
        post_params: {authenticity_token : this.token},
        file_size_limit : "2048KB",
        file_types : "*.jpg;*.gif;*.png",
        file_types_description : "All Files",
        file_upload_limit : 100,
        file_queue_limit : 0,
        custom_settings : {
          progressTarget : "fsUploadProgress",
          submitButtonId : "btnSubmit",
          cancelButtonId : "btnCancel",
          uploadedPhotoIds : [],
          authenticityToken : this.token,
          totalSize: 0,
          photosCount: 0
        },
        debug: false,

        // Button settings
        button_image_url: "/images/FullyTransparent_65x29.png",
        button_width: "120",
        button_height: "30",
        button_placeholder_id: "spanButtonPlaceHolder",
        button_cursor: SWFUpload.CURSOR.HAND,
        button_text: '点击选择照片',
        button_text_style: ".theFont { font-size: 24; color: red;}",
        button_text_left_padding: 12,
        button_text_top_padding: 3,

        // The event handler functions are defined in handlers.js
        file_queued_handler : this.fileQueued,
        file_queue_error_handler : this.fileQueueError,
        file_dialog_complete_handler : this.fileDialogComplete,
        upload_start_handler : this.uploadStart,
        upload_progress_handler : this.uploadProgress,
        upload_error_handler : this.uploadError,
        upload_success_handler : this.uploadSuccess,
        upload_complete_handler : this.uploadComplete,
        queue_complete_handler : this.queueComplete,
      };
  
      this.swfu = new SWFUpload(this.settings); 
    },

    fileQueued: function(file){
      try {
        var progress = new FileProgress(file, this.customSettings.progressTarget);
        //progress.setStatus("等待");
        this.customSettings.totalSize += file.size;
        this.customSettings.photosCount += 1;
        $('total_size').innerHTML = "总计: " + abbreviateSize(this.customSettings.totalSize);
        $('total_entries').innerHTML = this.customSettings.photosCount + "张照片";

      } catch (ex) {
        this.debug(ex);
      }
    },

    fileQueueError: function(file, errorCode, message){
      if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
        tip("上传太多文件了，最多" + message + "个文件");
        return;
      }

      var progress = new FileProgress(file, this.customSettings.progressTarget);
      progress.setError();

      switch (errorCode) {
        case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
          progress.setStatus("文件太大");
          break;
        case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
          progress.setStatus("文件不能为空");
          break;
        case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
          progress.setStatus("非法的文件类型");
          break;
        default:
          if (file !== null) {
            progress.setStatus("有问题");
          }
          break;
      }

      // remove progress
      progress.setCancelled();
    },

    fileDialogComplete: function(file){
    },

    uploadStart: function(file){
      var progress = new FileProgress(file, this.customSettings.progressTarget);
      progress.setStatus("正在上传..");
    },

    uploadProgress: function(file, bytesLoaded, bytesTotal){
      var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
      var progress = new FileProgress(file, this.customSettings.progressTarget);
      progress.setStatus("正在上传(" + percent + "%)");
    },

    uploadError: function(file, errorCode, message){
      var progress = new FileProgress(file, this.customSettings.progressTarget);
      progress.setError();

      switch (errorCode) {
      case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
        progress.setStatus("上传失败");
        break;
      case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
        progress.setStatus("上传失败");
        break;
      case SWFUpload.UPLOAD_ERROR.IO_ERROR:
        progress.setStatus("上传失败");
        break;
      case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
        progress.setStatus("上传失败");
        break;
      case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
        progress.setStatus("上传失败"); 
        break;
      case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
        progress.setStatus("上传失败");
        break;
      case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
        progress.disappear();

        this.customSettings.totalSize -= file.size;
        this.customSettings.photosCount -= 1;
        $('total_size').innerHTML = "总计: " + abbreviateSize(this.customSettings.totalSize);
        $('total_entries').innerHTML = this.customSettings.photosCount + "张照片";

        break;
      default:
        progress.setStatus("上传失败");
        break;
      }
    },

    uploadComplete: function(file){
    },

    uploadSuccess: function(file, serverData){
      var progress = new FileProgress(file, this.customSettings.progressTarget);
      //progress.setComplete();
      progress.setStatus("完成");
    },

    queueComplete: function(numFilesUploaded){
      window.href.location = '/admin/news';
    }

  })

});
