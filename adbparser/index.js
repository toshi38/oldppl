// parser.js
var stream = require('stream');

var Transform = require('stream').Transform;

var parser = new Transform();
parser._transform = function(data, encoding, done) {
  this.push(data);
  console.log("hej:" + data);
  //done();
};


parser.on('data', function(chunk){
	console.log('DAAAT', chunk);
});


var writable = stream.Writable ||
  require('readable-stream').Writable;;

writable.on('data', function(chunk){
	console.log("hipp", chunk);
});

// Pipe the streams
process.stdin
.pipe(writable);


// Some programs like `head` send an error on stdout
// when they don't want any more data
parser.on('error', process.exit);

parser.on('end', function(){
	console.log(ENDDDDD);
})