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

    static public function sendPlainText(res:Response, text:String, code:Int = 200):Void {
        res.status(code);
        res.type("text/plain");
        res.send(text);
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

    static public function sendPage(res:Response, page, ?props:Dynamic):Void {
        if (props == null)
            props = {};
        props.expressResponse = res;
        var element = React.createElement(page, props);
        res.send("<!DOCTYPE html>" + ReactDOMServer.renderToStaticMarkup(cast element));
    }
}