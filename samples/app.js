
var http = require("http"),
url = require("url"),
path = require("path"),
fs = require("fs")
port = process.argv[2] || 8888;

 
var app = http.createServer(function(request, response) {
 
var uri = url.parse(request.url).pathname
, filename = path.join(process.cwd(), uri);
path.exists(filename, function(exists) {
if(!exists) {
response.writeHead(404, {"Content-Type": "text/plain"});
response.write("404 Not Found\n");
response.end();
return;
}
 
if (fs.statSync(filename).isDirectory()) filename += '/index.html';
 
fs.readFile(filename, "binary", function(err, file) {
if(err) {
response.writeHead(500, {"Content-Type": "text/plain"});
response.write(err + "\n");
response.end();
return;
}
 
response.writeHead(200);
response.write(file, "binary");
response.end();
});
});
}).listen(parseInt(port, 10));
 
console.log("Static file server running at\n => http://localhost:" + port + "/\nCTRL + C to shutdown");

var io = require('socket.io').listen(app);

var count = 0;

var dateUpdater = function(socket){

    socket.emit('myDate',count);
    count = count + 1;

    setTimeout(function(){dateUpdater(socket);},500);
}

io.sockets.on('connection', function (socket) {
    console.log('connection!');

    socket.on('chatOut',function(chat){

	console.log(chat);
	socket.emit('chatIn',chat);
	socket.broadcast.emit('chatIn',chat);
    });
});
