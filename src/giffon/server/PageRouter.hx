package giffon.server;

import giffon.db.AuthMethod;
import haxe.*;
import js.npm.express.*;
import js.npm.passport.*;
import tink.core.Error;
import giffon.view.*;
import giffon.server.ServerMain.*;
import haxe.io.*;
using Lambda;
using tink.core.Future.JsPromiseTools;
using giffon.RequestTools;
using giffon.ResponseTools;
using giffon.server.PromiseTools;

@await
class PageRouter {
    @await static public function createRouter():Router {
        var router = new Router();
        router.use(function(req:Request, res:Response, next){
            res.locals.base = req.baseUrl;
            next();
        });
        router.get("/", @await function(req:Request, res:Response) {
            res.sendPage(Index, {
                recentWishes: @await getRecentWishes(10),
            });
        });
        router.get("/terms", function(req, res:Response) {
            res.sendPage(Terms);
        });
        router.get("/privacy", function(req, res:Response) {
            res.sendPage(Privacy);
        });
        router.get("/use-cases/video-creators", function(req, res:Response) {
            res.sendPage(UseCasesVideoCreators);
        });
        router.get("/use-cases/oss-developers", function(req, res:Response) {
            res.sendPage(UseCasesOssDevs);
        });
        router.get("/signin", function(req:Request, res:Response){
            switch (req.query.redirectTo) {
                case null:
                    //pass
                case redirectTo:
                    req.session.redirectTo = redirectTo;
            }
            res.sendPage(SignIn);
        });
        for (auth_method in Type.allEnums(giffon.db.AuthMethod)) {
            var authOptions = switch (auth_method) {
                case Facebook:
                    {
                        scope: ["email"],
                    };
                case Google:
                    {
                        scope: ["email profile"],
                    };
                case _:
                    {};
            }
            var auth_method_lower = auth_method.getName().toLowerCase();
            var pName = switch(auth_method) {
                case Twitch: "twitch.js";
                case _: auth_method_lower;
            };
            router.get('/signin/${auth_method_lower}',
                function(req:Request, res:Response, next) {
                    switch (req.query.redirectTo) {
                        case null:
                            //pass
                        case redirectTo:
                            req.session.redirectTo = redirectTo;
                    }
                    next();
                },
                Passport.authenticate(pName, authOptions)
            );
        }

        router.get("/disconnect/:auth_method", ensureLoggedIn, @await function(req:Request, res:Response, next) {
            var auth_method = req.params.auth_method;
            var authMethod = AuthMethodTools.fromString(auth_method);
            if (authMethod == null) {
                res.sendPlainError("unknown auth method", NotFound);
                return;
            }
            var user = res.getUser();
            var socialProfiles = @await getSocialProfiles(user.user_id);
            var social_profile = socialProfiles[authMethod];

            var numConnected = [for (k in socialProfiles.keys()) if (socialProfiles[k] != null) 1].length;
            if (numConnected <= 1) {
                res.sendPlainError('Cannot disconnect the only social connection.', BadRequest);
                return;
            }

            if (social_profile == null) {
                res.sendPlainError('User has no existing ${auth_method} connection.', BadRequest);
                return;
            }

            @await dbConnectionPool.query(
                'DELETE FROM user_${auth_method} WHERE user_id = ? && ${auth_method}_id = ?',
                [res.getUser().user_id, social_profile.profile.id]
            ).toPromise();

            var base = switch (req.baseUrl) {
                case null, "": "/";
                case _: req.baseUrl;
            }
            res.redirect(Path.join([base, "settings"]));
        });

        router.get("/signout", function(req:Request, res) {
            var base = switch (req.baseUrl) {
                case null, "": "/";
                case _: req.baseUrl;
            }
            var redirectTo = switch (req.query.redirectTo) {
                case null:
                    base;
                case r: r;
            }
            req.logout();
            res.cookie("doneSignOut", "1");
            res.redirect(redirectTo);
        });

        router.get("/home", ensureLoggedIn, @await function(req:Request, res:Response) {
            try {
                var wishes = @await getWishes(res.getUser().user_id);
                res.render("home", {
                    wishes: wishes
                });
            } catch (err:Dynamic) {
                trace(err);
                res.sendPlainError(err);
                return;
            }
        });

        router.use(giffon.server.Admin.createRouter());
        router.use(giffon.server.Wish.createRouter());
        router.use(giffon.server.MakeAWish.createRouter());
        router.use(giffon.server.Settings.createRouter());
        router.use(giffon.server.User.createRouter());
        return router;
    }
}