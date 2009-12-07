Resizable = Class.create();

Resizable.prototype = {
	
	initialize:function(elem, box, width, height, opts){
		this.RsE  = 1;
    this.RsW  = 2;
    this.RsS  = 3;
		this.RsN	= 4;
    this.RsSE = 5;
    this.RsSW = 6;
		this.RsNE	= 7;
		this.RsNW	=	8;
		this.None = 0;
		this.opts = opts;
		this.curPosX;
    this.curPosY;
    this.oldPosX;
    this.oldPosY;
    this.clicked = false;
    this.obj = $(elem);
		this.box = $(box);
    this.resizeZoneH = 8;
    this.resizeZoneV = 8;
    this.initWidth;	
    this.initHeight; 
    this.initLeft; 
		this.initTop;
    this.minWidth   = width;
    this.minHeight  = height;
		this.boxWidth		= this.box.getWidth();
		this.boxHeight	= this.box.getHeight();
		this.boxLeft		= this.box.positionedOffset().left;
		this.boxTop			= this.box.positionedOffset().top;
    this.eventMouseDown = this.onDownAction.bindAsEventListener(this);
    this.eventMouseUp = this.onUpAction.bindAsEventListener(this);
    this.eventMouseMove = this.onMoveAction.bindAsEventListener(this);
    Event.observe(document, "mousedown", this.eventMouseDown);
    Event.observe(document, "mouseup", this.eventMouseUp);
    Event.observe(document, "mousemove", this.eventMouseMove);
    this.action;
  },

  getCursorPos:function(e){
    this.curPosX = Event.pointerX(e);
    this.curPosY = Event.pointerY(e);
  },

  onDownAction:function(e){
		this.action = this.changeCursor(e);
		if(this.action != this.None){
			if(this.opts.beforeMouseDown){
				this.opts.beforeMouseDown();
			}
			this.clicked = true;
			this.initWidth = this.obj.getWidth();
			this.initHeight = this.obj.getHeight();
			this.initLeft = this.obj.positionedOffset().left;
			this.initTop  = this.obj.positionedOffset().top;
			this.getCursorPos(e);
			this.oldPosX = this.curPosX;
			this.oldPosY = this.curPosY;
		}
  },

  onUpAction:function(e){
		if(this.clicked){
			this.clicked = false;
			if(this.opts.beforeMouseUp){
				this.opts.beforeMouseUp();
			}
		}
  },

  onMoveAction:function(e){
    if(this.clicked){
			this.getCursorPos(e);
      switch(this.action){
				case this.RsE :
          this.resizeE();
          break;
        case this.RsW :
					this.resizeW();
          break;
        case this.RsS :
          this.resizeS();
          break;
				case this.RsN :
					this.resizeN();
					break;
        case this.RsSE :
					this.resizeS();
          this.resizeE();
          break;
        case this.RsSW :
          this.resizeS();
          this.resizeW();
          break;
				case this.RsNE :
					this.resizeN();
					this.resizeE();
					break;
				case this.RsNW :
					this.resizeN();
					this.resizeW();
					break;
      }
    }else{
      this.changeCursor(e);
		}
  },

  changeCursor:function(e){
		var posX = Event.pointerX(e);
    var posY = Event.pointerY(e);
		if(posX > (this.obj.positionedOffset().left + this.obj.getWidth()- this.resizeZoneH) && 
			 posX < (this.obj.positionedOffset().left + this.obj.getWidth()) && 
			 posY > (this.obj.positionedOffset().top + this.obj.getHeight()- this.resizeZoneV) && 
			 posY < (this.obj.positionedOffset().top + this.obj.getHeight())){
			this.obj.setStyle({cursor:'se-resize'});
			return this.RsSE;
    }
    if(posX > (this.obj.positionedOffset().left) &&
			 posX < (this.obj.positionedOffset().left + this.resizeZoneH) && 
			 posY > (this.obj.positionedOffset().top + this.obj.getHeight()- this.resizeZoneV) && 
			 posY < (this.obj.positionedOffset().top + this.obj.getHeight())){
      this.obj.setStyle({cursor:'sw-resize'});
      return this.RsSW;
    }
		if(posX > (this.obj.positionedOffset().left + this.obj.getWidth() - this.resizeZoneH) &&
       posX < (this.obj.positionedOffset().left + this.obj.getWidth()) &&
       posY > (this.obj.positionedOffset().top) &&
       posY < (this.obj.positionedOffset().top + this.resizeZoneH)){
      this.obj.setStyle({cursor:'ne-resize'});
      return this.RsNE;
    }
    if(posX > (this.obj.positionedOffset().left) &&
       posX < (this.obj.positionedOffset().left + this.resizeZoneH) &&
       posY > (this.obj.positionedOffset().top) &&
       posY < (this.obj.positionedOffset().top + this.resizeZoneV)){
      this.obj.setStyle({cursor:'nw-resize'});
      return this.RsNW;
    }
    if(posX > (this.obj.positionedOffset().left + this.obj.getWidth() - this.resizeZoneH) && 
			 posX < (this.obj.positionedOffset().left + this.obj.getWidth()) &&
			 posY > (this.obj.positionedOffset().top) &&
			 posY < (this.obj.positionedOffset().top + this.obj.getHeight())){
			this.obj.setStyle({cursor:'e-resize'});
			return this.RsE;
    }
    if(posX > (this.obj.positionedOffset().left) &&
			 posX < (this.obj.positionedOffset().left + this.resizeZoneH) &&
			 posY > (this.obj.positionedOffset().top) && 
			 posY < (this.obj.positionedOffset().top + this.obj.getHeight())){
			this.obj.setStyle({cursor:'w-resize'});
      return this.RsW;
    }
    if(posY > (this.obj.positionedOffset().top + this.obj.getHeight() - this.resizeZoneV) && 
			 posY < (this.obj.positionedOffset().top + this.obj.getHeight()) &&
			 posX > (this.obj.positionedOffset().left) &&
			 posX < (this.obj.positionedOffset().left + this.obj.getWidth())){
			this.obj.setStyle({cursor:'s-resize'});
			return this.RsS;
    }
		if(posY > (this.obj.positionedOffset().top) &&
       posY < (this.obj.positionedOffset().top + this.resizeZoneV) &&
       posX > (this.obj.positionedOffset().left) &&
       posX < (this.obj.positionedOffset().left + this.obj.getWidth())){
      this.obj.setStyle({cursor:'n-resize'});
      return this.RsN;
    }

    this.obj.setStyle({cursor:'auto'});
		return this.None;
  },

  resizeE:function(){
		var ecart = this.oldPosX - this.curPosX;
    var newWidth = this.initWidth - ecart;
    if(newWidth > this.minWidth && (this.initLeft + newWidth <= this.boxLeft + this.boxWidth))
			this.obj.setStyle({width:newWidth + 'px'});
  },

  resizeW:function(){
		var ecart = this.oldPosX - this.curPosX;
    var newWidth = this.initWidth + ecart;
    var newLeft = this.initLeft - ecart;
    if(newWidth > this.minWidth && newLeft >= this.boxLeft)
			this.obj.setStyle({left:newLeft + 'px',width:newWidth + 'px'});
  },

  resizeS:function(){
    var ecart = this.oldPosY - this.curPosY;
    var newHeight = this.initHeight - ecart;
    if(newHeight > this.minHeight && (this.initTop + newHeight <= this.boxTop + this.boxHeight))
			this.obj.setStyle({height:newHeight + 'px'});
  },

	resizeN: function(){
		var ecart = this.oldPosY - this.curPosY;
		var newHeight = this.initHeight + ecart;
		var newTop = this.curPosY;
		if(newHeight > this.minHeight && (newTop >= this.boxTop))
			this.obj.setStyle({top:newTop + 'px', height:newHeight + 'px'}); 		 
	}
}

