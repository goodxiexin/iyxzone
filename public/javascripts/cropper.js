/*
 * 这个文件是我从外面找的
 * 用来扩展Draggable的
 * 我尝试写过，但是mouse event总是处理的不好
 * 所以就用别人的把
 */

/**
 * Extend the Draggable class to allow us to pass the rendering
 * down to the Cropper object.
 */
var CropDraggable = Class.create(Draggable, {
	
	initialize: function(element) {
		this.options = Object.extend(
			{
				/**
				 * The draw method to defer drawing to
				 */
				drawMethod: function() {}
			}, 
			arguments[1] || {}
		);

		this.element = $(element);

		this.handle = this.element;

		this.delta    = this.currentDelta();
		this.dragging = false;   

		this.eventMouseDown = this.initDrag.bindAsEventListener(this);
		Event.observe(this.handle, "mousedown", this.eventMouseDown);

		Draggables.register(this);
	},
	
	/**
	 * Defers the drawing of the draggable to the supplied method
	 */
	draw: function(point) {
		var pos = Element.cumulativeOffset(this.element),
		    d = this.currentDelta();
		pos[0] -= d[0]; 
		pos[1] -= d[1];
				
		var p = [0,1].map(function(i) { 
			return (point[i]-pos[i]-this.offset[i]);
		}.bind(this));
				
		this.options.drawMethod( p );
	}
	
});


var Cropper = {};
Cropper.Img = Class.create({
	
	/**
	 * Initialises the class
	 * 
	 * @access public
	 * @param obj Image element to attach to
	 * @param obj Options
	 * @return void
	 */
	initialize: function(element, options) {
		this.options = Object.extend(
			{
				/**
				 * @var obj
				 * The pixel dimensions to apply as a restrictive ratio
				 */
				ratioDim: { x: 0, y: 0 },
				/**
				 * @var int
				 * The minimum pixel width, also used as restrictive ratio if min height passed too
				 */
				minWidth:		0,
				/**
				 * @var int
				 * The minimum pixel height, also used as restrictive ratio if min width passed too
				 */
				minHeight:		0,
				/**
				 * @var boolean
				 * Whether to display the select area on initialisation, only used when providing minimum width & height or ratio
				 */
				displayOnInit:	false,
				/**
				 * @var function
				 * onDrag hooker for user
				 * added by gaoxh
				 */
				onDragging: Prototype.emptyFunction,
				/**
				 * @var function
				 * The call back function to pass the final values to
				 */
				onEndCrop: Prototype.emptyFunction,
				/**
				 * @var boolean
				 * Whether to capture key presses or not
				 */
				captureKeys: true,
				/**
				 * @var obj Coordinate object x1, y1, x2, y2
				 * The coordinates to optionally display the select area at onload
				 */
				onloadCoords: null,
				/**
				 * @var int
				 * The maximum width for the select areas in pixels (if both minWidth & maxWidth set to same the width of the cropper will be fixed)
				 */
				maxWidth: 0,
				/**
				 * @var int
				 * The maximum height for the select areas in pixels (if both minHeight & maxHeight set to same the height of the cropper will be fixed)
				 */
				maxHeight: 0,
				/**
				 * @var boolean - default true
				 * Whether to automatically include the stylesheet (assumes it lives in the same location as the cropper JS file)
				 */
				autoIncludeCSS: false,
        /**
         * added by gaoxh
         */
        locateImgWrap: Prototype.emptyFunction
			}, 
			options || {}
		);				
		/**
		 * @var obj
		 * The img node to attach to
		 */
		this.img = $( element );
		/**
	s.options.onImgLoad(this.img, this.imgWrap);
	 * @var obj
		 * The x & y coordinates of the click point
		 */
		this.clickCoords = { x: 0, y: 0 };
		/**
		 * @var boolean
		 * Whether the user is dragging
		 */
		this.dragging = false;
		/**
		 * @var boolean
		 * Whether the user is resizing
		 */
		this.resizing = false;
		/**
		 * @var boolean
		 * Whether the user is on a webKit browser
		 */
		this.isWebKit = /Konqueror|Safari|KHTML/.test( navigator.userAgent );
		/**
		 * @var boolean
		 * Whether the user is on IE
		 */
		this.isIE = /MSIE/.test( navigator.userAgent );
		/**
		 * @var boolean
		 * Whether the user is on Opera below version 9
		 */
		this.isOpera8 = /Opera\s[1-8]/.test( navigator.userAgent );
		/**
		 * @var int
		 * The x ratio 
		 */
		this.ratioX = 0;
		/**
		 * @var int
		 * The y ratio
		 */
		this.ratioY = 0;
		/**
		 * @var boolean
		 * Whether we've attached sucessfully
		 */
		this.attached = false;
		/**
		 * @var boolean
		 * Whether we've got a fixed width (if minWidth EQ or GT maxWidth then we have a fixed width
		 * in the case of minWidth > maxWidth maxWidth wins as the fixed width)
		 */
		this.fixedWidth = ( this.options.maxWidth > 0 && ( this.options.minWidth >= this.options.maxWidth ) );
		/**
		 * @var boolean
		 * Whether we've got a fixed height (if minHeight EQ or GT maxHeight then we have a fixed height
		 * in the case of minHeight > maxHeight maxHeight wins as the fixed height)
		 */
		this.fixedHeight = ( this.options.maxHeight > 0 && ( this.options.minHeight >= this.options.maxHeight ) );
		
		// quit if the image element doesn't exist
		if( typeof this.img == 'undefined' ) { return; }
		
		// include the stylesheet
		if( this.options.autoIncludeCSS ) {
			$$('script').each(function(s) {
				if( s.src.match( /\/cropper([^\/]*)\.js/ ) ) {
					var path    = s.src.replace( /\/cropper([^\/]*)\.js.*/, '' ),
					    style   = document.createElement( 'link' );
					style.rel   = 'stylesheet';
					style.type  = 'text/css';
					style.href  = path + '/cropper.css';
					style.media = 'screen';
					document.getElementsByTagName( 'head' )[0].appendChild( style );
				}
			});   
		}
	
		// calculate the ratio when neccessary
		if( this.options.ratioDim.x > 0 && this.options.ratioDim.y > 0 ) {
			var gcd = this.getGCD( this.options.ratioDim.x, this.options.ratioDim.y );
			this.ratioX = this.options.ratioDim.x / gcd;
			this.ratioY = this.options.ratioDim.y / gcd;
			// dump( 'RATIO : ' + this.ratioX + ':' + this.ratioY + '\n' );
		}
							
		// initialise sub classes
		this.subInitialize();

		// only load the event observers etc. once the image is loaded
		// this is done after the subInitialize() call just in case the sub class does anything
		// that will affect the result of the call to onLoad()
		if( this.img.complete || this.isWebKit ) {
			this.onLoad(); // for some reason Safari seems to support img.complete but returns 'undefined' on the this.img object
		} else {
			Event.observe( this.img, 'load', this.onLoad.bindAsEventListener( this) );
		}
	},
	
	/**
	 * The Euclidean algorithm used to find the greatest common divisor
	 * 
	 * @acces private
	 * @param int Value 1
	 * @param int Value 2
	 * @return int
	 */
	getGCD : function( a , b ) {
		if( b === 0 ) { return a; }
		return this.getGCD(b, a % b );
	},
	
	/**
	 * Attaches the cropper to the image once it has loaded
	 * 
	 * @access private
	 * @return void
	 */
	onLoad: function( ) {
    var cNamePrefix = 'imgCrop_';
		
		// get the point to insert the container
		var insertPoint = this.img.parentNode;
		
		// apply an extra class to the wrapper to fix Opera below version 9
		var fixOperaClass = '';
		if( this.isOpera8 ) { fixOperaClass = ' opera8'; }
		this.imgWrap = new Element( 'div', { 'class': cNamePrefix + 'wrap' + fixOperaClass } );
		
		this.north = new Element( 'div', { 'class': cNamePrefix + 'overlay ' + cNamePrefix + 'north' }).insert(new Element( 'span' ));
		this.east  = new Element( 'div', { 'class': cNamePrefix + 'overlay ' + cNamePrefix + 'east' }).insert(new Element( 'span' ));
		this.south = new Element( 'div', { 'class': cNamePrefix + 'overlay ' + cNamePrefix + 'south' }).insert(new Element( 'span' ));
		this.west  = new Element( 'div', { 'class': cNamePrefix + 'overlay ' + cNamePrefix + 'west' }).insert(new Element( 'span' ));
		
		var overlays = [ this.north, this.east, this.south, this.west ];

		this.dragArea = new Element( 'div', { 'class': cNamePrefix + 'dragArea' } );
		
		overlays.each(function(o){this.dragArea.insert(o);}, this);
		
		this.handleN  = new Element( 'div', { 'class': cNamePrefix + 'handle ' + cNamePrefix + 'handleN' } );
		this.handleNE = new Element( 'div', { 'class': cNamePrefix + 'handle ' + cNamePrefix + 'handleNE' } );
		this.handleE  = new Element( 'div', { 'class': cNamePrefix + 'handle ' + cNamePrefix + 'handleE' } );
		this.handleSE = new Element( 'div', { 'class': cNamePrefix + 'handle ' + cNamePrefix + 'handleSE' } );
		this.handleS  = new Element( 'div', { 'class': cNamePrefix + 'handle ' + cNamePrefix + 'handleS' } );
		this.handleSW = new Element( 'div', { 'class': cNamePrefix + 'handle ' + cNamePrefix + 'handleSW' } );
		this.handleW  = new Element( 'div', { 'class': cNamePrefix + 'handle ' + cNamePrefix + 'handleW' } );
		this.handleNW = new Element( 'div', { 'class': cNamePrefix + 'handle ' + cNamePrefix + 'handleNW' } );
				
		this.selArea = new Element( 'div', { 'class': cNamePrefix + 'selArea' });
			[
				new Element( 'div', { 'class': cNamePrefix + 'marqueeHoriz ' + cNamePrefix + 'marqueeNorth' }).insert(new Element( 'span' )),
				new Element( 'div', { 'class': cNamePrefix + 'marqueeVert ' + cNamePrefix + 'marqueeEast' }).insert(new Element( 'span' )),
				new Element( 'div', { 'class': cNamePrefix + 'marqueeHoriz ' + cNamePrefix + 'marqueeSouth' }).insert(new Element( 'span' )),
				new Element( 'div', { 'class': cNamePrefix + 'marqueeVert ' + cNamePrefix + 'marqueeWest' }).insert(new Element( 'span' )),
				this.handleN,
				this.handleNE,
				this.handleE,
				this.handleSE,
				this.handleS,
				this.handleSW,
				this.handleW,
				this.handleNW,
				new Element( 'div', { 'class': cNamePrefix + 'clickArea' } )
			].each(function(o){this.selArea.insert(o);}, this);
		
				
		this.imgWrap.appendChild( this.img );
		this.imgWrap.appendChild( this.dragArea );
		this.dragArea.appendChild( this.selArea );
		this.dragArea.appendChild( new Element( 'div', { 'class': cNamePrefix + 'clickArea' } ) );

		insertPoint.appendChild( this.imgWrap );

		// add event observers
		this.startDragBind = this.startDrag.bindAsEventListener( this );
		Event.observe( this.dragArea, 'mousedown', this.startDragBind );
		
		this.onDragBind = this.onDrag.bindAsEventListener( this );
		Event.observe( document, 'mousemove', this.onDragBind );
		
		this.endCropBind = this.endCrop.bindAsEventListener( this );
		Event.observe( document, 'mouseup', this.endCropBind );
		
		this.resizeBind = this.startResize.bindAsEventListener( this );
		this.handles = [ this.handleN, this.handleNE, this.handleE, this.handleSE, this.handleS, this.handleSW, this.handleW, this.handleNW ];
		this.registerHandles( true );
		
		if( this.options.captureKeys ) {
			this.keysBind = this.handleKeys.bindAsEventListener( this );
			Event.observe( document, 'keypress', this.keysBind );
		}

		// attach the dragable to the select area
		var x = new CropDraggable( this.selArea, { drawMethod: this.moveArea.bindAsEventListener( this ) } );
		
		this.setParams();
	},
	
	/**
	 * Manages adding or removing the handle event handler and hiding or displaying them as appropriate
	 * 
	 * @access private
	 * @param boolean registration true = add, false = remove
	 * @return void
	 */
	registerHandles: function( registration ) {	
		for( var i = 0; i < this.handles.length; i++ ) {
			var handle = $( this.handles[i] );
			
			if( registration ) {
				var hideHandle	= false;	// whether to hide the handle
				
				// disable handles asappropriate if we've got fixed dimensions
				// if both dimensions are fixed we don't need to do much
				if( this.fixedWidth && this.fixedHeight ) {
					hideHandle = true;
				} else if( this.fixedWidth || this.fixedHeight ) {
					// if one of the dimensions is fixed then just hide those handles
					var isCornerHandle = handle.className.match( /([S|N][E|W])$/ ),
					    isWidthHandle  = handle.className.match( /(E|W)$/ ),
					    isHeightHandle = handle.className.match( /(N|S)$/ );
					if( isCornerHandle || ( this.fixedWidth && isWidthHandle ) || ( this.fixedHeight && isHeightHandle ) ) {
						hideHandle = true;
					}
				}
				if( hideHandle ) { 
					handle.hide(); 
				} else {
					Event.observe( handle, 'mousedown', this.resizeBind );
				}
			} else {
				handle.show();
				Event.stopObserving( handle, 'mousedown', this.resizeBind );
			}
		}
	},
		
	/**
	 * Sets up all the cropper parameters, this can be used to reset the cropper when dynamically
	 * changing the images
	 * 
	 * @access private
	 * @return void
	 */
	setParams: function() {
		/**
		 * @var int
		 * The image width
		 */
		this.imgW = this.img.width;
		/**
		 * @var int
		 * The image height
		 */
		this.imgH = this.img.height;			

		$( this.north ).setStyle( { height: 0 } );
		$( this.east ).setStyle( { width: 0, height: 0 } );
		$( this.south ).setStyle( { height: 0 } );
		$( this.west ).setStyle( { width: 0, height: 0 } );
		
		// resize the container to fit the image
		$( this.imgWrap ).setStyle( { 'width': this.imgW + 'px', 'height': this.imgH + 'px' } );
		
      
		// hide the select area
		$( this.selArea ).hide();
						
		// setup the starting position of the select area
		var startCoords = { x1: 0, y1: 0, x2: 0, y2: 0 },
		    validCoordsSet = false;
		
		// display the select area 
		if( this.options.onloadCoords !== null ) {
			// if we've being given some coordinates to 
			startCoords = this.cloneCoords( this.options.onloadCoords );
			validCoordsSet = true;
		} else if( this.options.ratioDim.x > 0 && this.options.ratioDim.y > 0 ) {
			// if there is a ratio limit applied and the then set it to initial ratio
			startCoords.x1 = Math.ceil( ( this.imgW - this.options.ratioDim.x ) / 2 );
			startCoords.y1 = Math.ceil( ( this.imgH - this.options.ratioDim.y ) / 2 );
			startCoords.x2 = startCoords.x1 + this.options.ratioDim.x;
			startCoords.y2 = startCoords.y1 + this.options.ratioDim.y;
			validCoordsSet = true;
		}
		
		this.setAreaCoords( startCoords, false, false, 1 );

    // 自己加的hook	
    if(this.options.locateImgWrap){
      this.options.locateImgWrap(this.imgWrap);
    }
	
		if( this.options.displayOnInit && validCoordsSet ) {
			this.selArea.show();
			this.drawArea();
			this.endCrop();
		}
		
		this.attached = true;
	},
	
	/**
	 * Removes the cropper
	 * 
	 * @access public
	 * @return void
	 */
	remove: function() {
		if( this.attached ) {
			this.attached = false;
			
			// remove the elements we inserted
			this.imgWrap.parentNode.insertBefore( this.img, this.imgWrap );
			this.imgWrap.parentNode.removeChild( this.imgWrap );
			
			// remove the event observers
			Event.stopObserving( this.dragArea, 'mousedown', this.startDragBind );
			Event.stopObserving( document, 'mousemove', this.onDragBind );		
			Event.stopObserving( document, 'mouseup', this.endCropBind );
			this.registerHandles( false );
			if( this.options.captureKeys ) {
				Event.stopObserving( document, 'keypress', this.keysBind );
			}
		}
	},
	
	/**
	 * Resets the cropper, can be used either after being removed or any time you wish
	 * 
	 * @access public
	 * @return void
	 */
	reset: function() {
		if( !this.attached ) {
			this.onLoad();
		} else {
			this.setParams();
		}
		this.endCrop();
	},
	
	/**
	 * Handles the key functionality, currently just using arrow keys to move, if the user
	 * presses shift then the area will move by 10 pixels
	 */
	handleKeys: function( e ) {
		var dir = { x: 0, y: 0 }; // direction to move it in & the amount in pixels
		if( !this.dragging ) {
			
			// catch the arrow keys
			switch( e.keyCode ) {
				case( 37 ) : // left
					dir.x = -1;
					break;
				case( 38 ) : // up
					dir.y = -1;
					break;
				case( 39 ) : // right
					dir.x = 1;
					break;
				case( 40 ) : // down
					dir.y = 1;
					break;
			}
			
			if( dir.x !== 0 || dir.y !== 0 ) {
				// if shift is pressed then move by 10 pixels
				if( e.shiftKey ) {
					dir.x *= 10;
					dir.y *= 10;
				}
				
				this.moveArea( [ this.areaCoords.x1 + dir.x, this.areaCoords.y1 + dir.y ] );
				this.endCrop();
				Event.stop( e ); 
			}
		}
	},
	
	/**
	 * Calculates the width from the areaCoords
	 * 
	 * @access private
	 * @return int
	 */
	calcW: function() {
		return (this.areaCoords.x2 - this.areaCoords.x1);
	},
	
	/**
	 * Calculates the height from the areaCoords
	 * 
	 * @access private
	 * @return int
	 */
	calcH: function() {
		return (this.areaCoords.y2 - this.areaCoords.y1);
	},
	
	/**
	 * Moves the select area to the supplied point (assumes the point is x1 & y1 of the select area)
	 * 
	 * @access public
	 * @param array Point for x1 & y1 to move select area to
	 * @return void
	 */
	moveArea: function( point ) {
		// dump( 'moveArea        : ' + point[0] + ',' + point[1] + ',' + ( point[0] + ( this.areaCoords.x2 - this.areaCoords.x1 ) ) + ',' + ( point[1] + ( this.areaCoords.y2 - this.areaCoords.y1 ) ) + '\n' );
		this.setAreaCoords( 
			{
				x1: point[0], 
				y1: point[1],
				x2: point[0] + this.calcW(),
				y2: point[1] + this.calcH()
			},
			true,
			false
		);
		this.drawArea();
		this.options.onDragging(
			this.areaCoords,
			{
				width: this.calcW(), 
				height: this.calcH() 
			}
		);
	},

	/**
	 * Clones a co-ordinates object, stops problems with handling them by reference
	 * 
	 * @access private
	 * @param obj Coordinate object x1, y1, x2, y2
	 * @return obj Coordinate object x1, y1, x2, y2
	 */
	cloneCoords: function( coords ) {
		return { x1: coords.x1, y1: coords.y1, x2: coords.x2, y2: coords.y2 };
	},

	/**
	 * Sets the select coords to those provided but ensures they don't go
	 * outside the bounding box
	 * 
	 * @access private
	 * @param obj Coordinates x1, y1, x2, y2
	 * @param boolean Whether this is a move
	 * @param boolean Whether to apply squaring
	 * @param obj Direction of mouse along both axis x, y ( -1 = negative, 1 = positive ) only required when moving etc.
	 * @param string The current resize handle || null
	 * @return void
	 */
	setAreaCoords: function( coords, moving, square, direction, resizeHandle ) {
		// dump( 'setAreaCoords (in) : ' + coords.x1 + ',' + coords.y1 + ',' + coords.x2 + ',' + coords.y2 );
		if( moving ) {
			// if moving
			var targW = coords.x2 - coords.x1,
			    targH = coords.y2 - coords.y1;
			
			// ensure we're within the bounds
			if( coords.x1 < 0 ) {
				coords.x1 = 0;
				coords.x2 = targW;
			}
			if( coords.y1 < 0 ) {
				coords.y1 = 0;
				coords.y2 = targH;
			}
			if( coords.x2 > this.imgW ) {
				coords.x2 = this.imgW;
				coords.x1 = this.imgW - targW;
			}
			if( coords.y2 > this.imgH ) {
				coords.y2 = this.imgH;
				coords.y1 = this.imgH - targH;
			}			
		} else {
			// ensure we're within the bounds
			if( coords.x1 < 0 ) { coords.x1 = 0; }
			if( coords.y1 < 0 ) { coords.y1 = 0; }
			if( coords.x2 > this.imgW ) { coords.x2 = this.imgW; }
			if( coords.y2 > this.imgH ) { coords.y2 = this.imgH; }
			
			// This is passed as null in onload
			if( direction !== null ) {
								
				// apply the ratio or squaring where appropriate
				if( this.ratioX > 0 ) {
					this.applyRatio( coords, { x: this.ratioX, y: this.ratioY }, direction, resizeHandle );
				} else if( square ) {
					this.applyRatio( coords, { x: 1, y: 1 }, direction, resizeHandle );
				}
										
				var mins = [ this.options.minWidth, this.options.minHeight ], // minimum dimensions [x,y]			
				    maxs = [ this.options.maxWidth, this.options.maxHeight ]; // maximum dimensions [x,y]
		
				// apply dimensions where appropriate
				if( mins[0] > 0 || mins[1] > 0 || maxs[0] > 0 || maxs[1] > 0) {
				
					var coordsTransX = { a1: coords.x1, a2: coords.x2 },
					    coordsTransY = { a1: coords.y1, a2: coords.y2 },
					    boundsX      = { min: 0, max: this.imgW },
					    boundsY      = { min: 0, max: this.imgH };

					// handle squaring properly on single axis minimum dimensions
					if( (mins[0] !== 0 || mins[1] !== 0) && square ) {
						if( mins[0] > 0 ) {
							mins[1] = mins[0];
						} else if( mins[1] > 0 ) {
							mins[0] = mins[1];
						}
					}
					
					if( (maxs[0] !== 0 || maxs[0] !== 0) && square ) {
						// if we have a max x value & it is less than the max y value then we set the y max to the max x (so we don't go over the minimum maximum of one of the axes - if that makes sense)
						if( maxs[0] > 0 && maxs[0] <= maxs[1] ) {
							maxs[1] = maxs[0];
						} else if( maxs[1] > 0 && maxs[1] <= maxs[0] ) {
							maxs[0] = maxs[1];
						}
					}
					
					if( mins[0] > 0 ) { this.applyDimRestriction( coordsTransX, mins[0], direction.x, boundsX, 'min' ); }
					if( mins[1] > 1 ) { this.applyDimRestriction( coordsTransY, mins[1], direction.y, boundsY, 'min' ); }
					
					if( maxs[0] > 0 ) { this.applyDimRestriction( coordsTransX, maxs[0], direction.x, boundsX, 'max' ); }
					if( maxs[1] > 1 ) { this.applyDimRestriction( coordsTransY, maxs[1], direction.y, boundsY, 'max' ); }
					
					coords = { x1: coordsTransX.a1, y1: coordsTransY.a1, x2: coordsTransX.a2, y2: coordsTransY.a2 };
				}
				
			}
		}
		
		// dump( 'setAreaCoords (out) : ' + coords.x1 + ',' + coords.y1 + ',' + coords.x2 + ',' + coords.y2 + '\n' );
		this.areaCoords = coords;
	},
	
	/**
	* Applies the supplied dimension restriction to the supplied coordinates along a single axis
	 * 
	 * @access private
	 * @param obj Single axis coordinates, a1, a2 (e.g. for the x axis a1 = x1 & a2 = x2)
	 * @param int The restriction value
	 * @param int The direction ( -1 = negative, 1 = positive )
	 * @param obj The bounds of the image ( for this axis )
	 * @param string The dimension restriction type ( 'min' | 'max' )
	 * @return void
	 */
	applyDimRestriction: function( coords, val, direction, bounds, type ) {
		var check;
		if( type == 'min' ) { check = ( ( coords.a2 - coords.a1 ) < val ); }
		else { check = ( ( coords.a2 - coords.a1 ) > val ); }
		if( check ) {
			if( direction == 1 ) { coords.a2 = coords.a1 + val; }
			else { coords.a1 = coords.a2 - val; }
			
			// make sure we're still in the bounds (not too pretty for the user, but needed)
			if( coords.a1 < bounds.min ) {
				coords.a1 = bounds.min;
				coords.a2 = val;
			} else if( coords.a2 > bounds.max ) {
				coords.a1 = bounds.max - val;
				coords.a2 = bounds.max;
			}
		}
	},
		
	/**
	 * Applies the supplied ratio to the supplied coordinates
	 * 
	 * @access private
	 * @param obj Coordinates, x1, y1, x2, y2
	 * @param obj Ratio, x, y
	 * @param obj Direction of mouse, x & y : -1 == negative 1 == positive
	 * @param string The current resize handle || null
	 * @return void
	 */
	applyRatio : function( coords, ratio, direction, resizeHandle ) {
		// dump( 'direction.y : ' + direction.y + '\n');
		var newCoords;
		if( resizeHandle == 'N' || resizeHandle == 'S' ) {
			// dump( 'north south \n');
			// if moving on either the lone north & south handles apply the ratio on the y axis
			newCoords = this.applyRatioToAxis( 
				{ a1: coords.y1, b1: coords.x1, a2: coords.y2, b2: coords.x2 },
				{ a: ratio.y, b: ratio.x },
				{ a: direction.y, b: direction.x },
				{ min: 0, max: this.imgW }
			);
			coords.x1 = newCoords.b1;
			coords.y1 = newCoords.a1;
			coords.x2 = newCoords.b2;
			coords.y2 = newCoords.a2;
		} else {
			// otherwise deal with it as if we're applying the ratio on the x axis
			newCoords = this.applyRatioToAxis( 
				{ a1: coords.x1, b1: coords.y1, a2: coords.x2, b2: coords.y2 },
				{ a: ratio.x, b: ratio.y },
				{ a: direction.x, b: direction.y },
				{ min: 0, max: this.imgH }
			);
			coords.x1 = newCoords.a1;
			coords.y1 = newCoords.b1;
			coords.x2 = newCoords.a2;
			coords.y2 = newCoords.b2;
		}
		
	},
	
	/**
	 * Applies the provided ratio to the provided coordinates based on provided direction & bounds,
	 * use to encapsulate functionality to make it easy to apply to either axis. This is probably
	 * quite hard to visualise so see the x axis example within applyRatio()
	 * 
	 * Example in parameter details & comments is for requesting applying ratio to x axis.
	 * 
	 * @access private
	 * @param obj Coords object (a1, b1, a2, b2) where a = x & b = y in example
	 * @param obj Ratio object (a, b) where a = x & b = y in example
	 * @param obj Direction object (a, b) where a = x & b = y in example
	 * @param obj Bounds (min, max)
	 * @return obj Coords object (a1, b1, a2, b2) where a = x & b = y in example
	 */
	applyRatioToAxis: function( coords, ratio, direction, bounds ) {
		var newCoords = Object.extend( coords, {} ),
				calcDimA = newCoords.a2 - newCoords.a1, // calculate dimension a (e.g. width)
				targDimB = Math.floor( calcDimA * ratio.b / ratio.a ), // the target dimension b (e.g. height)
				targB = null, // to hold target b (e.g. y value)
				targDimA = null, // to hold target dimension a (e.g. width)
				calcDimB = null; // to hold calculated dimension b (e.g. height)
		
		// dump( 'newCoords[0]: ' + newCoords.a1 + ',' + newCoords.b1 + ','+ newCoords.a2 + ',' + newCoords.b2 + '\n');
				
		if( direction.b == 1 ) { // if travelling in a positive direction
			// make sure we're not going out of bounds
			targB = newCoords.b1 + targDimB;
			if( targB > bounds.max ) {
				targB = bounds.max;
				calcDimB = targB - newCoords.b1; // calcuate dimension b (e.g. height)
			}
			
			newCoords.b2 = targB;
		} else { // if travelling in a negative direction
			// make sure we're not going out of bounds
			targB = newCoords.b2 - targDimB;
			if( targB < bounds.min ) {
				targB = bounds.min;
				calcDimB = targB + newCoords.b2; // calcuate dimension b (e.g. height)
			}
			newCoords.b1 = targB;
		}
		
		// dump( 'newCoords[1]: ' + newCoords.a1 + ',' + newCoords.b1 + ','+ newCoords.a2 + ',' + newCoords.b2 + '\n');
			
		// apply the calculated dimensions
		if( calcDimB !== null ) {
			targDimA = Math.floor( calcDimB * ratio.a / ratio.b );
			
			if( direction.a == 1 ) { newCoords.a2 = newCoords.a1 + targDimA; }
			else { newCoords.a1 = newCoords.a1 = newCoords.a2 - targDimA; }
		}
		
		// dump( 'newCoords[2]: ' + newCoords.a1 + ',' + newCoords.b1 + ','+ newCoords.a2 + ',' + newCoords.b2 + '\n');
			
		return newCoords;
	},
	
	/**
	 * Draws the select area
	 * 
	 * @access private
	 * @return void
	 */
	drawArea: function( ) {	
		/*
			NOTE: I'm not using the Element.setStyle() shortcut as they make it 
			quite sluggish on Mac based browsers
		*/
		// dump( 'drawArea        : ' + this.areaCoords.x1 + ',' + this.areaCoords.y1 + ',' + this.areaCoords.x2 + ',' + this.areaCoords.y2 + '\n' );
		var areaWidth     = this.calcW(),
		    areaHeight    = this.calcH();
		
		/*
			Calculate all the style strings before we use them, allows reuse & produces quicker
			rendering (especially noticable in Mac based browsers)
		*/
		var px = 'px',
		    params = [
			this.areaCoords.x1 + px, // the left of the selArea
			this.areaCoords.y1 + px, // the top of the selArea
			areaWidth + px,          // width of the selArea
			areaHeight + px,         // height of the selArea
			this.areaCoords.x2 + px, // bottom of the selArea
			this.areaCoords.y2 + px, // right of the selArea
			(this.img.width - this.areaCoords.x2) + px, // right edge of selArea
			(this.img.height - this.areaCoords.y2) + px // bottom edge of selArea
		];
				
		// do the select area
		var areaStyle    = this.selArea.style;
		areaStyle.left   = params[0];
		areaStyle.top    = params[1];
		areaStyle.width  = params[2];
		areaStyle.height = params[3];

		// position the north, east, south & west handles
		var horizHandlePos = Math.ceil( (areaWidth - 6) / 2 ) + px,
		    vertHandlePos = Math.ceil( (areaHeight - 6) / 2 ) + px;
		
		this.handleN.style.left = horizHandlePos;
		this.handleE.style.top  = vertHandlePos;
		this.handleS.style.left = horizHandlePos;
		this.handleW.style.top  = vertHandlePos;
		
		// draw the four overlays
		this.north.style.height = params[1];
		
		var eastStyle     = this.east.style;
		eastStyle.top     = params[1];
		eastStyle.height  = params[3];
		eastStyle.left    = params[4];
		eastStyle.width   = params[6];

		var southStyle    = this.south.style;
		southStyle.top    = params[5];
		southStyle.height = params[7];

		var westStyle     = this.west.style;
		westStyle.top     = params[1];
		westStyle.height  = params[3];
		westStyle.width   = params[0];

		// call the draw method on sub classes
		this.subDrawArea();
		
		this.forceReRender();
	},
	
	/**
	 * Force the re-rendering of the selArea element which fixes rendering issues in Safari 
	 * & IE PC, especially evident when re-sizing perfectly vertical using any of the south handles
	 * 
	 * @access private
	 * @return void
	 */
	forceReRender: function() {
		if( this.isIE || this.isWebKit) {
			var n = document.createTextNode(' ');
			var d,el,fixEL,i;
		
			if( this.isIE ) { fixEl = this.selArea; }
			else if( this.isWebKit ) {
				fixEl = document.getElementsByClassName( 'imgCrop_marqueeSouth', this.imgWrap )[0];
				/* 
					we have to be a bit more forceful for Safari, otherwise the the marquee &
					the south handles still don't move
				*/ 
				d = new Element( 'div' );
				d.style.visibility = 'hidden';
				
				var classList = ['SE','S','SW'];
				for( i = 0; i < classList.length; i++ ) {
					el = document.getElementsByClassName( 'imgCrop_handle' + classList[i], this.selArea )[0];
					if( el.childNodes.length ) { el.removeChild( el.childNodes[0] ); }
					el.appendChild(d);
				}
			}
			fixEl.appendChild(n);
			fixEl.removeChild(n);
		}
	},
	
	/**
	 * Starts the resize
	 * 
	 * @access private
	 * @param obj Event
	 * @return void
	 */
	startResize: function( e ) {
		this.startCoords = this.cloneCoords( this.areaCoords );
		
		this.resizing = true;
		this.resizeHandle = Event.element( e ).classNames().toString().replace(/([^N|NE|E|SE|S|SW|W|NW])+/, '');
		// dump( 'this.resizeHandle : ' + this.resizeHandle + '\n' );
		Event.stop( e );
	},
	
	/**
	 * Starts the drag
	 * 
	 * @access private
	 * @param obj Event
	 * @return void
	 */
	startDrag: function( e ) {
		this.selArea.show();
		this.clickCoords = this.getCurPos( e );

		this.setAreaCoords( { x1: this.clickCoords.x, y1: this.clickCoords.y, x2: this.clickCoords.x, y2: this.clickCoords.y }, false, false, null );

		this.dragging = true;
		this.onDrag( e ); // incase the user just clicks once after already making a selection
		Event.stop( e );
	},
	
	/**
	 * Gets the current cursor position relative to the image
	 * 
	 * @access private
	 * @param obj Event
	 * @return obj x,y pixels of the cursor
	 */
	getCurPos: function( e ) {
		// get the offsets for the wrapper within the document
		// get the offsets for the wrapper within the document
		var el = this.imgWrap, wrapOffsets = Element.cumulativeOffset( el );
		// remove any scrolling that is applied to the wrapper (this may be buggy) - don't count the scroll on the body as that won't affect us
		while( el.nodeName != 'BODY' ) {
			wrapOffsets[1] -= el.scrollTop  || 0;
			wrapOffsets[0] -= el.scrollLeft || 0;
			el = el.parentNode;
		}
		return { 
			x: Event.pointerX(e) - wrapOffsets[0],
			y: Event.pointerY(e) - wrapOffsets[1]
		};
	},
	                               
	/**                            
	 * Performs the drag for both   resize & inital draw dragging
	 *
	 * @access private             
	 * @param obj Event
	 * @return void
	 */
	onDrag: function( e ) {
		if( this.dragging || this.resizing ) {
			var resizeHandle = null,
					curPos = this.getCurPos( e ),
					newCoords = this.cloneCoords( this.areaCoords ),
					direction = { x: 1, y: 1 };
			
			if( this.dragging ) {
				if( curPos.x < this.clickCoords.x ) { direction.x = -1; }
				if( curPos.y < this.clickCoords.y ) { direction.y = -1; }
				
				this.transformCoords( curPos.x, this.clickCoords.x, newCoords, 'x' );
				this.transformCoords( curPos.y, this.clickCoords.y, newCoords, 'y' );
			} else if( this.resizing ) {
				resizeHandle = this.resizeHandle;
				// do x movements first
				if( resizeHandle.match(/E/) ) {
					// if we're moving an east handle
					this.transformCoords( curPos.x, this.startCoords.x1, newCoords, 'x' );
					if( curPos.x < this.startCoords.x1 ) { direction.x = -1; }
				} else if( resizeHandle.match(/W/) ) {
					// if we're moving an west handle
					this.transformCoords( curPos.x, this.startCoords.x2, newCoords, 'x' );
					if( curPos.x < this.startCoords.x2 ) { direction.x = -1; }
				}
									
				// do y movements second
				if( resizeHandle.match(/N/) ) {
					// if we're moving an north handle	
					this.transformCoords( curPos.y, this.startCoords.y2, newCoords, 'y' );
					if( curPos.y < this.startCoords.y2 ) { direction.y = -1; }
				} else if( resizeHandle.match(/S/) ) {
					// if we're moving an south handle
					this.transformCoords( curPos.y, this.startCoords.y1, newCoords, 'y' );
					if( curPos.y < this.startCoords.y1 ) { direction.y = -1; }
				}
				
			}
		
			this.setAreaCoords( newCoords, false, e.shiftKey, direction, resizeHandle );
			this.drawArea();
			this.options.onDragging(
				this.areaCoords,
				{
					width: this.calcW(), 
					height: this.calcH() 
				}
			);
			Event.stop( e ); // stop the default event (selecting images & text) in Safari & IE PC
		}
	},
	
	/**
	 * Applies the appropriate transform to supplied co-ordinates, on the
	 * defined axis, depending on the relationship of the supplied values
	 * 
	 * @access private
	 * @param int Current value of pointer
	 * @param int Base value to compare current pointer val to
	 * @param obj Coordinates to apply transformation on x1, x2, y1, y2
	 * @param string Axis to apply transformation on 'x' || 'y'
	 * @return void
	 */
	transformCoords : function( curVal, baseVal, coords, axis ) {
		var newVals = [ curVal, baseVal ];
		if( curVal > baseVal ) { newVals.reverse(); }
		coords[ axis + '1' ] = newVals[0];
		coords[ axis + '2' ] = newVals[1];
	},
	
	/**
	 * return area coordinates
	 * added by gaoxh
	 */
	areaCoords: function() {
	  return this.areaCoords;
	},

	/**
	 * Ends the crop & passes the values of the select area on to the appropriate 
	 * callback function on completion of a crop
	 * 
	 * @access private
	 * @return void
	 */
	endCrop : function() {
		this.dragging = false;
		this.resizing = false;
		
		this.options.onEndCrop(
			this.areaCoords,
			{
				width: this.calcW(), 
				height: this.calcH() 
			}
		);
	},
	
	/**
	 * Abstract method called on the end of initialization
	 * 
	 * @access private
	 * @abstract
	 * @return void
	 */
	subInitialize: function() {},
	
	/**
	 * Abstract method called on the end of drawArea()
	 * 
	 * @access private
	 * @abstract
	 * @return void
	 */
	subDrawArea: function() {}
});




/**
 *	继承了Cropper.Img， 增加了preview
 *  但是只有一个preview
 */
Cropper.ImgWithPreview = Class.create(Cropper.Img, {
	
	subInitialize: function() {
		this.hasPreviewImg = false;
		if( typeof(this.options.previewWrap) != 'undefined' && this.options.previewWidth > 0 && this.options.previewHeight > 0 ) {
			this.options.displayOnInit = true;
			this.hasPreviewImg = true;
		  this.setPreviewWrap();
		}
	},
	
	subDrawArea: function() {
		if( this.hasPreviewImg ) {
      // get the ratio of the select area to the src image
      var calcWidth = this.calcW(),
          calcHeight = this.calcH();
      // ratios for the dimensions of the preview image
      var dimRatio = { 
        x: this.imgW / calcWidth, 
        y: this.imgH / calcHeight 
      }; 
      //ratios for the positions within the preview
      var posRatio = { 
        x: calcWidth / this.options.previewWidth,
        y: calcHeight / this.options.previewHeight
      };
      
      // setting the positions in an obj before apply styles for rendering speed increase
      var calcPos = {
        w: Math.ceil( this.options.previewWidth * dimRatio.x ) + 'px',
        h: Math.ceil( this.options.previewHeight * dimRatio.y ) + 'px',
        x: '-' + Math.ceil( this.areaCoords.x1 / posRatio.x )  + 'px',
        y: '-' + Math.ceil( this.areaCoords.y1 / posRatio.y ) + 'px'
      };
      
      var previewStyle = this.previewImg.style;
      previewStyle.width = calcPos.w;
      previewStyle.height= calcPos.h;
      previewStyle.left = calcPos.x;
      previewStyle.top = calcPos.y;
    }
  },

  setPreviewWrap: function(){
    this.previewWrap = $(this.options.previewWrap);
    this.previewImg = this.img.cloneNode( false );
    this.previewImg.id = 'imgCrop_' + this.previewImg.id;
    this.previewWrap.addClassName( 'imgCrop_previewWrap' );
    this.previewWrap.setStyle({ 
      width: this.options.previewWidth+ 'px',
      height: this.options.previewHeight + 'px'
    });
    this.previewWrap.appendChild( this.previewImg );
  },

  reset: function($super){
    // reset previewWrap
    if(this.options.previewWrap){
      $(this.options.previewWrap).update('');
      this.setPreviewWrap();
    }

    // reset Other
    $super();
  }    

});
