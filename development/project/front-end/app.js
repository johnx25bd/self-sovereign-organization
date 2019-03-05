const express = require('express')
const app = express();
const path = require('path');
const server = require('http').createServer(app);
const events = require('events');
const eventEmitter = new events.EventEmitter();

let port = process.env.PORT;
if (port == null || port == "") {
  port = 8000;
}

// Configure web server and middleware
server.listen(port)

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname + '/index.html'));
});

app.use(express.static('.'));
