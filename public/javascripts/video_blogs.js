function replace_video() {
	var elements = document.getElementsByClassName('video-img');

  var length = elements.length;
  for (var i = 0; i < length; i ++) {
    if (length != elements.length)
      element = elements[0];//每次取0是因为每次循环elements数组会变, 每次会少一个元素.
    else
      element = elements[i];
		var alt = element.getAttribute('alt');
		
		var embed = document.createElement('embed');
		embed.setAttribute('src', alt);
		embed.setAttribute('width', 480);
		embed.setAttribute('height', 400);
		if (alt.indexOf('.swf') >0 || alt.indexOf('tudou') > 0)
			embed.setAttribute('type', 'application/x-shockwave-flash');
		embed.setAttribute('allowScriptAccess', 'always');
		embed.setAttribute('align', 'middle');
		
		element.parentNode.replaceChild(embed, element);
	}
}
