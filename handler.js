const awsServerlessExpress = require('aws-serverless-express');
const app = require('./app.js').app;
const binaryMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/svg+xml',
    'image/x-icon',
    'text/html',
    'application/javascript',
    'text/css'
];
const server = awsServerlessExpress.createServer(app, null, binaryMimeTypes);
module.exports.express = (event, context) => awsServerlessExpress.proxy(server, event, context);