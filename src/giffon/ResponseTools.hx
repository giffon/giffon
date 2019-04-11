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
        haxe.Log.trace(err + "\n" + haxe.CallStack.toString(haxe.CallStack.exceptionStack()), pos);
        res.status(code);
        res.type("text/plain");
        res.send(err);
    }
}