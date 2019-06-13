var http = require('http');
var value = 0.3;

http.createServer(function (req, res) {
  res.write(String(value)); //write a response to the client
  res.end(); //end the response
}).listen(1337); //the server object listens on port 8080
