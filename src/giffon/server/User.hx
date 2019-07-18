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
import haxe.io.*;
using tink.core.Future.JsPromiseTools;
using giffon.ResponseTools;
using giffon.server.PromiseTools;
using StringTools;

@await
class User {
    static public function createRouter():Router {
        var router = new Router();
        router.get("/user/:pageUser_url", handleGetByUrl);
        router.get("/user", handleGetByHashId);
        router.get("/:pageUser_url", handleGetByUrl);
        return router;
    }

    @await static function handleGetByUrl(req:Request, res:Response, next):Void {
        var pageUser_url = req.params.pageUser_url;
        var pageUser_id = @await getUserIdFromUrl(pageUser_url);
        if (pageUser_id == null) {
            res.sendPlainError("There is no such user.", 404);
            return;
        }
        var pageUser = @await getUser(pageUser_id);

        if ("/" + pageUser.user_profile_url != req.path) {
            var base = switch (req.baseUrl) {
                case null, "": "/";
                case _: req.baseUrl;
            }
            res.redirect(Path.join([base, pageUser.user_profile_url]));
            return;
        }
        var wishes = @await getWishes(pageUser_id);
        var socialProfiles = @await getSocialProfiles(pageUser_id);
        res.sendPage(giffon.view.User, {
            pageUser: pageUser,
            wishes: wishes,
            socialProfiles: socialProfiles,
        });
    }

    @await static function handleGetByHashId(req:Request, res:Response, next):Void {
        var pageUser_hashid = req.query.id;
        var pageUser_id = @await getUserIdFromHash(pageUser_hashid);
        if (pageUser_id == null) {
            res.sendPlainError("There is no such user.", 404);
            return;
        }
        var pageUser = @await getUser(pageUser_id);
        if (!pageUser.user_profile_url.startsWith("user?")) {
            res.redirect(pageUser.user_profile_url);
            return;
        }
        var wishes = @await getWishes(pageUser_id);
        var socialProfiles = @await getSocialProfiles(pageUser_id);
        res.sendPage(giffon.view.User, {
            pageUser: pageUser,
            wishes: wishes,
            socialProfiles: socialProfiles,
        });
    }
}