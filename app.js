const express = require("express");
const awsServerlessExpressMiddleware = require('aws-serverless-express/middleware');
const app = express();

app.set('view engine', 'html');

app.use(awsServerlessExpressMiddleware.eventContext());
app.use(express.static('www', {
    dotfiles: 'ignore',
    redirect: true
}));

module.exports.app = app;

if (require.main === module) {
    app.listen(8000, () => console.log('listening on port 8000!'));
}
