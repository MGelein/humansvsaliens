var http = require('http');
var index = 0;
var hue = 0.3;
var saturation = 1;
var brightness = 1;

index = process.argv[2];
hue = process.argv[3];
saturation = process.argv[4];
brightness = process.argv[5];

console.log("index" + ': ' + process.argv[2]);
console.log("hue" + ': ' + process.argv[3]);
console.log("saturation" + ': ' + process.argv[4]);
console.log("brightness" + ': ' + process.argv[5]);

http.createServer(function (req, res) {
  res.write(String(index));
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
