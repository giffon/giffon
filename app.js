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
    const port = 3000;
    app.listen(port, () => console.log('listening on port ' + port));
}
