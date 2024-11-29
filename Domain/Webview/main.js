// 라우터 수정하면서 약간 변경됨. 기능은 동일함.
var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var connection;
router.get('/init', function (req, res){
    console.log('send geojson');
    res.sendFile(__dirname +'/geojsons/gumigeo.geojson');
});
router.get('/', function (req, res) {
    console.log('Terminal Home');
    var request = require('request');
    var url = 'http://api.data.go.kr/openapi/tn_pubr_public_prhsmk_zn_api?serviceKey=';
    request({
        url: url,
        method: 'GET'
    }, function (error, response, body) {
        console.log('Reponse received');
        res.render('index', {
            title: "Home",
            sdata: JSON.parse(body),
        })
    });
    console.log('get non smokingarea');
});

module.exports = router;
