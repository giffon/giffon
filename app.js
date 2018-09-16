const express = require("express");
const app = express();

app.use(express.static('www', {
    dotfiles: 'ignore',
    redirect: true
}));

module.exports.app = app;

if (require.main === module) {
    app.listen(8000, () => console.log('listening on port 8000!'));
}
