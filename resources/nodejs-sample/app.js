const http = require('http');
const yaml = require('js-yaml')
const fs = require('fs');

// read yaml config
const config = yaml.load(fs.readFileSync('./config.yaml', 'utf8'));

if ("message" in config) {
  console.log(`Config - message: ${config.message}`)
}

if ("port" in config) {
  console.log(`Config - port: ${config.port}`)
}

if ("hostname" in config) {
  console.log(`Config - host: ${config.hostname}`)
}

const message = config.message
const hostname = config.hostname
const port = config.port

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end(`Message read from config: ${message}`);
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});


// handle signal as Node won't handle them by default
// Source: https://medium.com/@becintec/building-graceful-node-applications-in-docker-4d2cd4d5d392
const shutdown = (signal, value) => {
  console.log("shutdown!");
  server.close(() => {
    console.log(`server stopped by ${signal} with value ${value}`);
    process.exit(128 + value);
  });
};

// The signals we want to handle
const signals = {
  'SIGHUP': 1,
  'SIGINT': 2,
  'SIGTERM': 15
}

// Create a listener for each of the signals that we want to handle
Object.keys(signals).forEach((signal) => {
  process.on(signal, () => {
    console.log(`process received a ${signal} signal`);
    shutdown(signal, signals[signal]);
  });
});