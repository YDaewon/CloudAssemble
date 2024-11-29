var express = require('express');
var router = express.Router();

var mysql = require('mysql');

router.get('/', function (req, res, next) {
    connection = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '    ',
        database: 'notsmk',
        port: 637
    });
    connection.connect();
    console.log('Connecting MariaDB');
    connection.query('select * from areas', function (err, rows, fields) {
        connection.end();
        if (!err) {         // 쿼리 성공
            var result = JSON.stringify(rows);
            res.send(result);
        }
        else {              // 쿼리 실패
            console.log(err);
            res.send(err);
        }
    });
    console.log('to enter Smoking areas into a Web');
});

module.exports = router;
