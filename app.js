const express = require("express");
const app = express();

app.get("/", function (req, res) {
    res.send("hello world");
});

module.exports.app = app;

if (require.main === module) {
    app.listen(8000, () => console.log('listening on port 8000!'));
}
