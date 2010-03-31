function myGetText(node){
	var r = document.createRange();
	r.setStartAfter(node);
	r.setStartBefore(node);
	alert(r.toString());
}

