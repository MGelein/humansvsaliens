var http = require('http');
var index = 0;
var hue = 0.3;
var saturation = 1;
var brightness = 1;

http.createServer(function (req, res) {
  res.write(String(hue));
  res.end();
}).listen(1000);

http.createServer(function (req, res) {
  res.write(String(hue));
  res.end();
}).listen(1001);

http.createServer(function (req, res) {
  res.write(String(saturation));
  res.end();
}).listen(1002);

http.createServer(function (req, res) {
  res.write(String(brightness));
  res.end();
}).listen(1003); 
