package giffon;

import js.npm.express.*;
import haxe.io.*;
import react.*;
using StringTools;
using js.npm.validator.Validator;

class RequestTools {
    static public function getRedirectTo(req:Request, clearIfExists = true):Null<String> {
        return req.session == null ? null : switch (req.session.redirectTo) {
            case null:
                null;
            case redirectTo if (isValidRedirectTo(redirectTo)):
                if (clearIfExists)
                    req.session.redirectTo = null;
                redirectTo;
            case _:
                null;
        }
    }

    static function isValidRedirectTo(redirectTo:String):Bool {
        if (redirectTo == null)
            return true;

        if (redirectTo.startsWith("/"))
            return true;

        if (redirectTo.isURL({
            protocols: ["https", "http"],
            host_whitelist: ["giffon.io"],
        }))
            return true;

        return false;
    }
}