// index.js

const http = require('http');
const fs = require('fs');
const port = 3000;

const server = http.createServer((req, res) => {
  fs.readFile(__dirname + req.url, function (err,data) {
    if (err) {
      res.writeHead(404);
      res.end(JSON.stringify(err));
      return;
    }
    res.writeHead(200);
    res.end(data);
  });
});

server.listen(port,() => {
  console.log(`Server is running on http://localhost:${port}`);
});