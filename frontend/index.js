var express = require('express')
var app = express()
 


app.get('/', function (req, res) {
  res.sendFile(__dirname + '/src/index.html');
})

app.use(express.static('src'));

 
app.listen(3000);