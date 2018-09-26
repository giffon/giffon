const isMain = require.main === module;
const express = require("express");
if (!isMain) {
    const awsServerlessExpressMiddleware = require('aws-serverless-express/middleware');
    app.use(awsServerlessExpressMiddleware.eventContext());
}
const app = express();

app.set('view engine', 'html');

app.use(express.static('www', {
    dotfiles: 'ignore',
    redirect: true
}));

module.exports.app = app;

if (isMain) {
    const port = 3000;
    app.listen(port, () => console.log('listening on port ' + port));
}
