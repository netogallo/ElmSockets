Elm.Native.SocketIO = function(elm){
    'use strict';

    var List = Elm.Native.List(elm);
    
    var sockets = {};

    var signalEvents = {};

    var Signal = Elm.Signal(elm);

    var JS = Elm.JavaScript(elm);

    elm.Native = elm.Native || {};
    if(elm.Native.SocketIO) 
	return elm.Native.SocketIO;

    function getSocket(host){

	if(sockets[host])
	    return sockets[host];

	var socket = io.connect(host);
	sockets[host] = {socket:socket,events:{}}
			

	return sockets[host];
    }

    function getRecvSignal(socketHolder,recvEvent){

	if(socketHolder.events[recvEvent])
	    return socketHolder.events[recvEvent];

	var signal = Signal.constant(List.Nil);

	socketHolder.socket.on(recvEvent,
			       function(signal,elm){

				   return function(data){
				       elm.notify(signal.id,data);
				   };
			       }(signal,elm));

	socketHolder.events[recvEvent] = {signal:signal};

	return socketHolder.events[recvEvent];
    }

    function socketOnUntyped(_host,_sendEvent,_recvEvent,data){

	var host = JS.fromString(_host);
	var sendEvent = JS.fromString(_sendEvent);
	var recvEvent = JS.fromString(_recvEvent);
	var socket = getSocket(host);
	console.log(socket);
	if(data){

	    socket.socket.emit(sendEvent,data);
	}

	var recvSignal = getRecvSignal(socket,recvEvent);

	return recvSignal.signal;

    }

    return elm.Native.SocketIO = 
	{
	    socketOnUntyped:F4(socketOnUntyped),
	    log : function(v){console.log(v);return v}
	};
};
