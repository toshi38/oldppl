var express = require('express');
var app = express();
var expressWs = require('express-ws')(app);
 


app.get('/', function (req, res) {
  res.sendFile(__dirname + '/src/index.html');
})

app.use(express.static('src'));


var lastListener;

app.ws('/echo', function(ws, req) {
	console.log("app.ws('/echo");
  ws.on('message', function(msg) {
    ws.send(msg);
  });
});

app.ws('/approach', function(ws, req) {
	console.log("app.ws('/echo");

	lastListener = ws;
  ws.on('message', function(msg) {
    ws.send(msg);
  });


});

 
app.listen(3000);




var WebSocket = require('ws');
var ws = new WebSocket('ws://192.168.254.19:5050');
var date = new Date();
var originalTime = date.getTime();


var lastTimeStamp = -1;




ws.on('open', function open() {
  ws.send('something');	
});

var waitingFeature;


var parseValue = function(strength){
	var normalized = strength - 60;
	var exponent = normalized / 10;
	var meter = Math.pow(2,exponent);
	return meter;
}

var lastStrength;

var actOnValue = function(data){
	var dataBits = data.split(':');
	var strength = dataBits[dataBits.length-1];
	strength = strength.split('\r')[0];
	//console.log("signal:" + strength +" after:" +  timeDiff);

	console.log( strength, " ", strength);

	if(lastListener){
		lastListener.send("" + strength);
	}

	lastStrength = strength;

	/*clearTimeOut(waitingFeature);
	waitingFeature = setTimeout( function(){ 
		console.log("No more signals ")
	}, 2000);
*/
};

var tempHistory;

ws.on('message', function(data, flags) {
	

	if( data.indexOf('---') !== 0 ){

		//First time filter of history results
		if( lastTimeStamp === -1 ){
			setTimeout( function(){

				actOnValue(tempHistory);
				lastTimeStamp = 0;
			},100);
			tempHistory = data;
		} else {
			date = new Date();
			var time = date.getTime();
			var timeDiff = time - lastTimeStamp;
			actOnValue(data);
			lastTimeStamp = time;
		}
	}
  // flags.binary will be set if a binary data is received.
  // flags.masked will be set if the data was masked.
});

