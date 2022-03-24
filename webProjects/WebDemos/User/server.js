const http = require('http');
const fs = require('fs');
const querystring = require('querystring');
const dao = require('./dao');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
 fs.readFile('index.html', (err, data) => {
 if(req.method === 'GET') {
 res.statusCode = 200;
 res.setHeader('Content-Type', 'text/html;charset=utf-8');
 res.end(data);
        }else if(req.method === 'POST') {
 var body = '';
 req.on('data', function(chunk) {body += chunk})
            .on('end', function() {
 console.log(body);
 // 解析参数
 body = querystring.parse(body);
 card = {"cardId" : body.cardId , "name" : body.name};
 dao.connectDB(card);
 
 res.statusCode = 200;
 res.setHeader('Content-Type', 'text/html;charset=utf-8');
 res.end(data);
            })
        }
    })
});

server.listen(port, hostname, () => {
 console.log(`Server running at http://${hostname}:${port}/`);
});
