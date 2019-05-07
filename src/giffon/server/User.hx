package giffon.server;

import js.npm.express.*;
import js.npm.mysql2.*;
import react.*;
import react.ReactMacro.jsx;
import thx.Decimal;
import hashids.Hashids;
import giffon.server.ServerMain.*;
import giffon.config.*;
import giffon.browser.*;
import tink.core.Error;
using tink.core.Future.JsPromiseTools;
using giffon.ResponseTools;
using giffon.server.PromiseTools;

@await
class User {
    static public function createRouter():Router {
        var router = new Router();
        router.get("/user/:pageUser_hashid", handleGet);
        return router;
    }

    @await static function handleGet(req, res:Response, next):Void {
        var pageUser_hashid = req.params.pageUser_hashid;
        var pageUser_id = @await getUserIdFromHash(pageUser_hashid);
        if (pageUser_id == null) {
            res.sendPlainError("There is no such user.", 404);
            return;
        }
        var pageUser = @await getUser(pageUser_id);
        var wishes = @await getWishes(pageUser_id);
        res.sendPage(giffon.view.User, {
            pageUser: pageUser,
            wishes: wishes,
        });
    }
}