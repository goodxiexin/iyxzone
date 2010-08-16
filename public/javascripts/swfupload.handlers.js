/*
 * TODO: 
 * 这个文件是我很早以前照着别人的模板改的，其实这样很不好，应该封装到一个类里，这样不会有命名问题
 * 比较好的可以参照Iyxzone.News.Builder.SwfUploader的实现
 * 如果重写，可以考虑弄个base class, 封装基本操作，然后把Iyxzone.News.Builder.SwfUploader和Iyxzone.Photo.SwfUploader都继承那个base class
 */

function abbreviateSize(size){
  if(size < 1024){
    return size + 'B';
  }else if(size < 1024 * 1024){
    return parseInt(size/1024) + 'KB';
  }else if(size < 1024 * 1024 * 1024){
    return parseInt(size/(1024*1024)) + 'MB';
  }
}

function fileQueued(file) {

	try {
		var progress = new FileProgress(file, this.customSettings.progressTarget);
		//progress.setStatus("等待");
    this.customSettings.totalSize += file.size;
    this.customSettings.photosCount += 1;
    $('total_size').innerHTML = "总计: " + abbreviateSize(this.customSettings.totalSize);
    $('total_entries').innerHTML = this.customSettings.photosCount + "张照片";

    // enable button
    if(this.customSettings.photosCount > 0){
      document.getElementById(this.customSettings.submitButtonId).disabled = false;
      document.getElementById(this.customSettings.cancelButtonId).disabled = true;
    }
	} catch (ex) {
		this.debug(ex);
	}

}

function fileQueueError(file, errorCode, message) {
	try {
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
	} catch (ex) {
  }
}

function fileDialogComplete(numFilesSelected, numFilesQueued) {
	try {
		if(numFilesSelected > 0) {
      document.getElementById(this.customSettings.submitButtonId).disabled = false;
		}else{
      document.getElementById(this.customSettings.submitButtonId).disabled = true;
	  }
    document.getElementById(this.customSettings.cancelButtonId).disabled = false;
	} catch (ex)  {
        this.debug(ex);
	}
}

function uploadStart(file) {
	try {
    var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setStatus("正在上传..");
    document.getElementById(this.customSettings.submitButtonId).disabled = true;
    document.getElementById(this.customSettings.cancelButtonId).disabled = false;
	}
	catch (ex) {}
	
	return true;
}

function uploadProgress(file, bytesLoaded, bytesTotal) {
	try {
		var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);

		var progress = new FileProgress(file, this.customSettings.progressTarget);
		progress.setStatus("正在上传(" + percent + "%)");
	} catch (ex) {
		this.debug(ex);
	}
}

function uploadSuccess(file, serverData) {
	try {
    var json = serverData.evalJSON();
    if(json.code == 1){
		  var progress = new FileProgress(file, this.customSettings.progressTarget);
		  //progress.setComplete();
		  progress.setStatus("完成");
		  this.customSettings.uploadedPhotoIds.push(json.id);
      if(this.getStats().files_queued != 0){
        document.getElementById(this.customSettings.submitButtonId).disabled = true;
        document.getElementById(this.customSettings.cancelButtonId).disabled = false;
      }
    }else{
      // TODO, error
    }
	} catch (ex) {
		this.debug(ex);
	}
}

function uploadError(file, errorCode, message) {
	try {
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
			// If there aren't any files left (they were all cancelled) disable the cancel button
	          // remove progress
      progress.disappear();

      // reshow photos details
      this.customSettings.totalSize -= file.size;
      this.customSettings.photosCount -= 1;
      $('total_size').innerHTML = "总计: " + abbreviateSize(this.customSettings.totalSize);
      $('total_entries').innerHTML = this.customSettings.photosCount + "张照片";

      // disable submit button
      if(this.getStats().files_queued != 0){
        document.getElementById(this.customSettings.submitButtonId).disabled = false;
        document.getElementById(this.customSettings.cancelButtonId).disabled = true;
      }else{
        document.getElementById(this.customSettings.submitButtonId).disabled = true;
        document.getElementById(this.customSettings.cancelButtonId).disabled = true;
      }

		  break;
		default:
			progress.setStatus("上传失败");
			break;
		}
	} catch (ex) {
        this.debug(ex);
    }
}

function uploadComplete(file) {
	if (this.getStats().files_queued === 0) {
    document.getElementById(this.customSettings.submitButtonId).disabled = false;
    document.getElementById(this.customSettings.cancelButtonId).disabled = false;
	}
}

// This event comes from the Queue Plugin
function queueComplete(numFilesUploaded) {
	var succUploads = this.getStats().successful_uploads; //numFilesUploaded + " file" + (numFilesUploaded === 1 ? "" : "s") + " uploaded.";
  // 目前只要有1张图片上传成功就记录并跳转到编辑页面	
  if(succUploads == 0){
    return;
  }

  $('total_size').innerHTML = '总计: 0KB';
  $('total_entries').innerHTML = '0张照片'; 

  var params = "";
  params += "authenticity_token=" + encodeURIComponent(this.customSettings.authenticityToken);
  params += "&album_id=" + this.customSettings.albumID;
  this.customSettings.uploadedPhotoIds.each(function(id){
    params += "&ids[]=" + id;
  });

  var url = "";
  var type = this.customSettings.albumType;
  if(type == 'PersonalAlbum'){
    url = Iyxzone.URL.editMultiplePhoto(this.customSettings.albumID, this.customSettings.uploadedPhotoIds);
  }else if(type == 'EventAlbum'){
    url = Iyxzone.URL.editMultipleEventPhoto(this.customSettings.albumID, this.customSettings.uploadedPhotoIds);
  }else if(type == 'GuildAlbum'){
    url = Iyxzone.URL.editMultipleGuildPhoto(this.customSettings.albumID, this.customSettings.uploadedPhotoIds);
  }

  new Ajax.Request(this.customSettings.recordUploadURL, {
    method: 'post',
    parameters: params,
    onSuccess: function(transport){
      var json = transport.responseText.evalJSON();
      if(json.code == 1){
        window.location.href = url;
        this.customSettings.uploadedPhotoIds = [];
      }else if(json.code == 0){
        error("发生错误，无法跳转页面");
      }
    }.bind(this)
  });
}
