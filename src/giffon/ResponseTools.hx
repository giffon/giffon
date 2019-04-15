package giffon;

import js.npm.express.*;

class ResponseTools {
    static public function getUser(res:Response):Null<giffon.db.User> {
        return res.locals.user;
    }

    static public function setUser(res:Response, user:giffon.db.User):Void {
        res.locals.user = user;
    }

    static public function sendPlainError(res:Response, err:Dynamic, code:Int = 500, ?pos:haxe.PosInfos):Void {
        res.status(code);
        res.type("text/plain");

        var jsError = Std.instance(err, js.Error);
        if (jsError != null) {
            js.Node.console.log(jsError.stack);
            res.send(jsError.stack);
        } else {
            res.send(err);
        }
    }
}