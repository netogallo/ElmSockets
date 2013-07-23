Elm Sockets
===

This is a small utility library that allows the usage of Socket.io to communicate with Elm. Files must be compiled including the SocketIO.js and the socket.io.js files.

#Building

Elm must be installed. If not see [Elm Language](www.elm-lang.org).

##Library Only
To build only the Socket.IO bindings for Elm run:
 
 * make

##Samples
To build the sample projects using Elm Sockets you need [node.js](nodejs.org) installed. This is anyways a requirement to use Socket.io. Once node.js is installed, you can build samples with:

   * make samples

To run the samples, go to the samples/ folder and run "node app.js" in the shell. You should be able to browse the samples by opening "localhost:8888" in your browser.

#Usage

To compile a project that uses Elm Socket you must include the socket.io.js file as well as the file out/SocketIO.js. The compilation command should look like:

 * elm --import-js="/path/to/out/SocketIO.js" --import-js="/path/to/node_modules/socket.io-client/dist/socket.io.js" myFile.elm

Chekc out more samples in the samples/ directory. Chat shows how to build an application that passes chat messagees. It requires the node.js app to forward the messages though.