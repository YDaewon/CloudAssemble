var express = require('express');
var router = express.Router();

var app = express();
// 라우팅 수정함. 
var main_router = require('./main');
var test_router = require('./router/webDB');

var Port = 3000;
//app.use(express.json());

app.use('/', main_router);      // 연결 주소가 "/" 로 시작하면 main_router에 연결된 "main.js" 실행
app.use('/smkview', test_router);  // 연결 주소가 "/test" 로 시작하면 test_router에 연결된 "test.js" 실행

app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');
app.engine('html', require('ejs').renderFile);

var server = app.listen(Port, function(){
    console.log("Express server has started on port " + Port)
});