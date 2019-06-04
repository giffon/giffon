package giffon.server;

import js.npm.express.*;
import giffon.server.ServerMain.*;
import tink.core.Error;
using tink.core.Future.JsPromiseTools;
using giffon.ResponseTools;
using giffon.server.PromiseTools;

class Settings {
    static public function createRouter():Router {
        var router = new Router();
        router.get("/settings", ensureLoggedIn, handleGet);
        router.post("/settings", ensureLoggedIn, handlePost);
        return router;
    }

    static function handleGet(req, res:Response):Void {
        res.sendPage(giffon.view.Settings);
    }

    @await static function handlePost(req:Request, res:Response, next:Dynamic){
        var settingsFormData:giffon.db.SettingsFormData = try {
            dataclass.JsonConverter.fromJson(giffon.db.SettingsFormData, req.body);
        } catch (err:Dynamic) {
            trace(haxe.Json.stringify(err));
            res.sendPlainError(err, BadRequest);
            return;
        }

        var user = res.getUser();

        @await dbConnectionPool.query(
            "
                UPDATE `user` SET ?
                WHERE `user_id` = ?;
            ",
            [{
                user_name: settingsFormData.user_name,
                user_primary_email: settingsFormData.user_primary_email.length > 0 ? settingsFormData.user_primary_email : null,
                user_description: settingsFormData.user_description.length > 0 ? settingsFormData.user_description : null,
            }, user.user_id]
        ).handleError(next).toPromise();

        res.sendPlainText(absPath('/user/${user.user_hashid}'));
    };
}