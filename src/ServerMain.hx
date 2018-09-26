import js.Node.*;
import js.npm.express.*;

class ServerMain {
    static function main():Void {
        var require:Dynamic = untyped __js__("require");
        var isMain = require.main == module;

        var app = Express.GetApplication();

        if (!isMain) {
            var awsServerlessExpressMiddleware = require('aws-serverless-express/middleware');
            app.use(untyped awsServerlessExpressMiddleware.eventContext());
        }

        app.set("view engine", "html");

        app.use(untyped new Static("www", {
            dotfiles: Ignore,
            redirect: true
        }));

        module.exports.app = app;

        if (isMain) {
            var port = 3000;
            app.listen(port, function(){
                trace('listening on port $port');
            });
        }
    }
}