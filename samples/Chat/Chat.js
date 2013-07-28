Elm.Native.Chat = function(elm){
    'use strict';

    elm.Native = elm.Native || {};

    var applyStyle = function(style,e_){
	
	var attr = 'style';

	var e = elm.JavaScript.fromElement(e_);

	var w = elm.Prelude.widthOf(e_);

	var h = elm.Prelude.heightOf(e_);
	

	console.log(elm);

	var old = e.getAttribute(attr) || "";

	e.setAttribute(attr,old+';'+elm.JavaScript.fromString(style));

	console.log(e);

	return elm.Native.Graphics.Input.toElement(w,h,e);

    };

    return elm.Native.Chat = 
	{
	    applyStyle : F2(applyStyle)
	};
}
