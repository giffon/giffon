package giffon.server;

import giffon.db.SettingsFormData;
import js.npm.express.*;
import js.npm.mysql2.*;
import js.moment.Moment;
import giffon.server.ServerMain.*;
import tink.core.Error;
import giffon.Utils.*;
import haxe.*;
using StringTools;
using thx.Dates;
using tink.core.Future.JsPromiseTools;
using giffon.ResponseTools;
using giffon.server.PromiseTools;

@await
class Settings {
    static public function createRouter():Router {
        var router = new Router();
        router.get("/settings", ensureLoggedIn, handleGet);
        router.post("/settings", ensureLoggedIn, handlePost);
        router.post("/settings/socialSetVisible", ensureLoggedIn, socialSetVisible);
        return router;
    }

    @await static function handleGet(req, res:Response):Void {
        var user = res.getUser();
        res.sendPage(giffon.view.Settings, {
            socialProfiles: @await getSocialProfiles(user.user_id),
        });
    }

    @await static function socialSetVisible(req:Request, res:Response, next:Dynamic) {
        var data:SocialSetVisibleData = try {
            new SocialSetVisibleData(req.body);
        } catch (err:Dynamic) {
            trace(haxe.Json.stringify(err));
            res.sendPlainError(err, BadRequest);
            return;
        }

        var user = res.getUser();

        @await dbConnectionPool.query(
            '
                UPDATE `user_${data.social.toLowerCase()}`
                SET ?
                WHERE `user_id` = ?;
            ',
            [
                {
                    visible: data.visible,
                },
                user.user_id,
            ]
        ).handleError(next).toPromise();

        res.sendPlainText("done");
    }

    @await static function handlePost(req:Request, res:Response, next:Dynamic){
        var settingsFormData:giffon.db.SettingsFormData = try {
            new giffon.db.SettingsFormData(req.body);
        } catch (err:Dynamic) {
            trace(haxe.Json.stringify(err));
            res.sendPlainError(err, BadRequest);
            return;
        }

        var user = res.getUser();
        var changes:DynamicAccess<String> = {
            user_name: settingsFormData.user_name,
            user_primary_email: settingsFormData.user_primary_email.length > 0 ? settingsFormData.user_primary_email : null,
            user_description: settingsFormData.user_description.length > 0 ? settingsFormData.user_description : null,
        };

        if (settingsFormData.user_avatar != null) {
            var file = js.npm.image_data_uri.ImageDataUri.decode(settingsFormData.user_avatar);
            var url = @await uploadUserImage(file.dataBuffer);
            changes["user_avatar_url"] = url;
        }

        @await dbConnectionPool.query(
            "
                UPDATE `user` SET ? WHERE `user_id` = ?;
            ",
            [
                changes,
                user.user_id,
            ]
        ).handleError(next).toPromise();

        if (settingsFormData.user_url == "") {
            @await dbConnectionPool.query(
                "
                    UPDATE user_url SET is_latest=0 WHERE user_id = ?;
                ",
                [
                    user.user_id,
                ]
            ).handleError(next).toPromise();
        } else if (user.user_profile_url != settingsFormData.user_url) {
            // check the latest update time
            var results:QueryResults = (@await dbConnectionPool.query(
                "
                    SELECT time_created
                    FROM user_url
                    WHERE user_id = ?
                    ORDER BY time_created DESC
                    LIMIT 1
                ",
                [user.user_id]
            ).toPromise()).results;

            if (results != null && results.length > 0) {
                var lastUpdated:Date = results[0].time_created;
                var cantUpdateBefore:Date = lastUpdated.jump(Day, 1);
                if (Date.now().less(cantUpdateBefore)) {
                    res.sendPlainError('Cannot update custom profile URL before ${Moment.moment(cantUpdateBefore).format()}', BadRequest);
                    return;
                }
            }

            @await dbConnectionPool.query(
                "
                    START TRANSACTION;
                    UPDATE user_url SET is_latest=0 WHERE user_id = ?;
                    INSERT INTO user_url SET ?;
                    COMMIT;
                ",
                [
                    user.user_id,
                    {
                        user_id: user.user_id,
                        user_url: settingsFormData.user_url,
                    }
                ]
            ).handleError(next).toPromise();
        }

        user = @await getUser(user.user_id);

        res.sendPlainText(absPath(user.user_profile_url));
    };
}