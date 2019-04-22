package giffon;

import js.npm.express.*;
import react.*;

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
            var stack = jsError.stack;
            js.Node.console.log(stack);
            res.send(err + "\n" + stack);
        } else {
            var stack = haxe.CallStack.toString(haxe.CallStack.exceptionStack());
            js.Node.console.log(stack);
            res.send(err + "\n" + stack);
        }
    }

    static public function sendPage(res:Response, page):Void {
        var element = React.createElement(page, {
            expressResponse: res
        });
        res.send("<!DOCTYPE html>" + ReactDOMServer.renderToStaticMarkup(cast element));
    }
}