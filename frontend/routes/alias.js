(function () {
  'use strict';

  module.exports = function(app){

    //console.log("USE persons !!!!!!!!!", app);



    var targetPath = '/Volumes/Disk/git/bitbucket/holy-grail/';
    var imageFolder= '/Volumes/Disk/git/bitbucket/holy-grail/static';
    var jsonFile = targetPath + 'static/presentation.json';
    var imageSource = "static";



    var express = require('express'),
      fs = require('fs'),    
      router = express.Router(),
      path = require('path'),
      rawNarration = require(jsonFile);    


    

    router.get('/', function (req, res, next) {
      console.log('ALIAS');
      res.sendFile('src/index.html');

      //console.log("SUPPLY narration");
      res.status(200).json(response);
    });


    //app.use(express.static(targetPath));

    app.use('/', router);

  }

}());
