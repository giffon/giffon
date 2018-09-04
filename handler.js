const app = require('./app.js').app;
const serverless = require("serverless-http");
module.exports.handler = serverless(app);