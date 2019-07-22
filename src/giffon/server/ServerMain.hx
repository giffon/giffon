package giffon.server;

import js.Node.*;
import js.npm.express.*;
import js.npm.mysql2.*;
import js.npm.mysql2.promise.*;
import js.npm.passport.*;
import js.npm.passport.strategy.*;
import js.npm.image_data_uri.ImageDataUri;
import js.npm.stripe.Stripe;
import hashids.Hashids;
import haxe.io.*;
import haxe.*;
import thx.Decimal;
import tink.core.Error;
import tink.CoreApi;
import haxe.Constraints;
import giffon.config.*;
import giffon.view.*;
import giffon.lang.Language;
using js.npm.validator.Validator;
using tink.core.Future.JsPromiseTools;
using giffon.RequestTools;
using giffon.ResponseTools;
using giffon.server.PromiseTools;
using Lambda;
using StringTools;

@await
class ServerMain {
    static public var canonicalBase(default, never) = "https://giffon.io";
    static public var base(default, never) = switch (Stage.stage) {
        case Production:
            canonicalBase;
        case Master:
            "https://master.giffon.io";
        case _:
            null;
    }
    static public function absPath(path:String):String {
        if (path.startsWith("https://") || path.startsWith("http://")) {
            return path;
        }
        return switch (base) {
            case null: path;
            case _: Path.join([base, path]);
        }
    }

    static public function ensureLoggedIn(req:Request, res:Response, next:Dynamic):Void {
        if (res.getUser() == null) {
            var base = switch (req.baseUrl) {
                case null, "": "/";
                case _: req.baseUrl;
            }
            res.redirect(Path.join([base, "signin"]) + "?redirectTo=" + Path.join([base, req.path]).urlEncode());
        } else {
            next();
        }
    }

    @await static public function ensureAdmin(req:Request, res:Response, next:Dynamic):Void {
        var user = res.getUser();
        if (user == null) {
            var base = switch (req.baseUrl) {
                case null, "": "/";
                case _: req.baseUrl;
            }
            res.redirect(Path.join([base, "signin"]) + "?redirectTo=" + Path.join([base, req.path]).urlEncode());
            return;
        }

        var roles = @await getRoles(user.user_id);

        if (!roles.exists(function (r) return r.match(Admin))) {
            res.sendPlainError("User is not an Admin.", Forbidden);
            return;
        }

        next();
    }

    static public var dbConnectionPool:Pool;
    static public var stripe:Stripe;

    @async static public function getStripeCustomerIdFromUser(user:{user_id:Int, user_primary_email:Null<String>}):Null<String> {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `stripe_customer_id`
                FROM `user_stripe`
                WHERE `user_id` = ?
            ",
            [user.user_id]
        ).toPromise()).results;

        if (results != null && results.length > 0) {
            if (results.length > 1)
                throw 'There are ${results.length} Stripe customers with user_id = ${user.user_id}.';
            return results[0].stripe_customer_id;
        }

        var customers = (@await stripe.customers.list({
            email: user.user_primary_email,
            limit: 5
        }).toPromise()).data;

        if (customers == null || customers.length < 1) {
            var customerInfo:DynamicAccess<Dynamic> = {};
            if (user.user_primary_email != null)
                customerInfo["email"] = user.user_primary_email;
            var customer = @await stripe.customers.create(customerInfo).toPromise();

            @await dbConnectionPool.query(
                "
                    INSERT INTO `user_stripe`
                    SET ?
                ",
                {
                    user_id: user.user_id,
                    stripe_customer_id: customer.id
                }
            ).toPromise();

            return customer.id;
        }

        if (customers.length > 1)
            throw 'There are ${customers.length} Stripe customers with email = ${user.user_primary_email}.';

        var stripe_customer_id = customers[0].id;
        @await dbConnectionPool.query(
            "
                INSERT INTO `user_stripe`
                SET ?
            ",
            {
                user_id: user.user_id,
                stripe_customer_id: stripe_customer_id
            }
        ).toPromise();

        return stripe_customer_id;
    }

    @async static function getUserIdFromPassportProfile(profile:js.npm.passport.Profile):Null<Int> {
        var p = switch(profile.provider) {
            case "twitch.js": "twitch";
            case p = "facebook" | "github" | "twitter" | "gitlab" | "google" | "youtube":
                p;
            case p:
                trace("unknown provider: " + p);
                return null;
        }
        var results:QueryResults = (@await dbConnectionPool.query(
            'SELECT user_id FROM user_${p} WHERE ${p}_id=?', 
            [profile.id]
        ).toPromise()).results;
        if (results != null && results.length != 0) {
            if (results.length != 1) {
                throw 'There are ${results.length} Giffon user associated with the ${p} account ${profile.id}.';
            }
            return results[0].user_id;
        }
        return null;
    }

    @async static function getUserIdFromEmail(email:Null<String>):Null<Int> {
        if (email == null)
            return null;

        if (!Validator.isEmail(email))
            throw '$email is not valid email address';

        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `user_id`
                FROM user
                WHERE `user_primary_email` = ?
            ",
            [email]
        ).toPromise()).results;

        if (results == null || results.length == 0) {
            return null;
        } else if (results.length > 1) {
            throw 'There are ${results.length} users with the email address ${email}.';
        } else {
            return results[0].user_id;
        }
    }

    @async static public function getUserIdFromHash(user_hashid:String):Null<Int> {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `user_id`
                FROM user
                WHERE `user_hashid` = ?
            ",
            [user_hashid]
        ).toPromise()).results;

        if (results == null || results.length == 0) {
            return null;
        } else if (results.length > 1) {
            throw 'There are ${results.length} users with the hashid ${user_hashid}.';
        } else {
            return results[0].user_id;
        }
    }

    @async static public function getUserIdFromUrl(user_url:String):Null<Int> {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `user_id`
                FROM user_url
                WHERE `user_url` = ?
            ",
            [user_url]
        ).toPromise()).results;

        if (results == null || results.length == 0) {
            return null;
        } else if (results.length > 1) {
            throw 'There are ${results.length} users with the url ${user_url}.';
        } else {
            return results[0].user_id;
        }
    }

    @async static public function getWishIdFromHash(wish_hashid:String):Null<Int> {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `wish_id`
                FROM wish
                WHERE `wish_hashid` = ?
            ",
            [wish_hashid]
        ).toPromise()).results;

        if (results == null || results.length == 0) {
            return null;
        } else if (results.length > 1) {
            throw 'There are ${results.length} wishes with the hashid ${wish_hashid}.';
        } else {
            return results[0].wish_id;
        }
    }

    @async static public function getWish(wish_id:Int):giffon.db.Wish {
        var wish_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT
                    `wish_id`,
                    `user_id`,
                    `wish_hashid`,
                    `wish_title`,
                    `wish_description`,
                    `wish_target_date`,
                    `wish_state`,
                    `wish_currency`,
                    `wish_banner_url`,
                    `wish_additional_cost_description`,
                    `wish_additional_cost_amount`
                FROM wish
                WHERE `wish_id` = ?
            ",
            [wish_id]
        ).toPromise()).results;
        if (wish_results == null || wish_results.length < 1)
            return null;
        if (wish_results.length > 1)
            throw 'There are ${wish_results.length} wishes with wish_id = ${wish_id}.';
        var wish = wish_results[0];
        var supporter_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT pledge_total.user_id, pledge_total_amount, pledge_date, pledge_visibility
                FROM
                (
                    SELECT user_id, SUM(pledge_amount) AS pledge_total_amount, MAX(pledge_time_created) AS pledge_date
                    FROM pledge
                    WHERE wish_id = ?
                    GROUP BY user_id
                    HAVING pledge_total_amount > 0
                ) AS pledge_total
                LEFT JOIN
                (
                    SELECT p1.user_id, p1.pledge_visibility
                    FROM pledge p1 LEFT JOIN pledge p2
                    ON (p1.user_id = p2.user_id AND p1.wish_id = p2.wish_id AND p1.pledge_id < p2.pledge_id)
                    WHERE p2.pledge_id IS NULL AND p1.wish_id = ?
                ) AS pledge_last
                ON pledge_total.user_id = pledge_last.user_id
                ORDER BY pledge_total_amount DESC, pledge_date ASC
            ",
            [wish.wish_id, wish.wish_id]
        ).toPromise()).results;
        var item_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT item.`item_id`, `item_url`, `item_url_screenshot`, `item_name`, `item_price`, `item_currency`, `item_quantity`
                FROM item
                INNER JOIN wish_item ON item.item_id=wish_item.item_id
                WHERE wish_item.wish_id = ?
            ",
            [wish.wish_id]
        ).toPromise()).results;

        var wish_owner = @await getUser(wish.user_id);

        var wish_pledged = Decimal.zero;
        var pledge_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT SUM(`pledge_amount`) AS `total_pledge`
                FROM `pledge`
                WHERE `wish_id` = ?
            ",
            [wish_id]
        ).toPromise()).results;
        if (pledge_results != null && pledge_results.length != 0) {
            if (pledge_results.length != 1) {
                throw 'SUM(`pledge_amount`) returned ${pledge_results.length} results.';
            }
            wish_pledged = switch (pledge_results[0].total_pledge) {
                case null: Decimal.zero;
                case str: Decimal.fromString(str).trim();
            }
        }
        var wish_additional_cost_amount = switch(wish.wish_additional_cost_amount) {
            case null:
                Decimal.zero;
            case amount:
                Decimal.fromString(amount);
        };
        var wish_total_price = item_results.fold(function(item, total:Decimal) return total + Decimal.fromString(item.item_price) * Decimal.fromInt(item.item_quantity), Decimal.zero).trim();

        var supporters = [];
        for (supporter in supporter_results) {
            supporters.push({
                user: @await getUser(supporter.user_id),
                pledge_amount: Decimal.fromString(supporter.pledge_total_amount).trim(),
                pledge_date: supporter.pledge_date,
                pledge_visibility: giffon.db.PledgeVisibility.createByName(supporter.pledge_visibility),
            });
        }

        var wish:giffon.db.Wish = {
            wish_id: wish.wish_id,
            wish_hashid: wish.wish_hashid,
            wish_title: wish.wish_title,
            wish_description: wish.wish_description,
            wish_target_date: wish.wish_target_date,
            wish_state: wish.wish_state,
            wish_owner: wish_owner,
            wish_currency: giffon.db.Currency.createByName(wish.wish_currency),
            wish_banner_url: wish.wish_banner_url,
            wish_total_price: wish_total_price,
            wish_total_needed: null,
            wish_pledged: wish_pledged,
            wish_progress: null,
            items: item_results.map(function(item){
                return {
                    item_id: item.item_id,
                    item_url: item.item_url,
                    item_url_screenshot: switch (item.item_url_screenshot) {
                        case null: null;
                        case v: ImageDataUri.encode(v, "PNG");
                    },
                    item_name: item.item_name,
                    item_price: Decimal.fromString(item.item_price).trim(),
                    item_currency: giffon.db.Currency.createByName(item.item_currency),
                    item_quantity: item.item_quantity,
                }
            }),
            wish_additional_cost_amount: wish_additional_cost_amount,
            wish_additional_cost_description: wish.wish_additional_cost_description,
            supporters: supporters,
            appliedCoupons: @await getCouponsAppliedToWish(wish.wish_id),
        };
        if (!wish.items.foreach(function(itm) return itm.item_currency == wish.wish_currency)) {
            throw "All items should be in the same currency";
        }
        var wish_total_needed = wish.wish_total_needed = ChargeInfo.totalNeeded(wish);
        wish.wish_progress = giffon.db.WishProgress.WishProgressTools.pledgeStateFromAmount(wish_pledged, wish_total_needed.amount);
        return wish;
    }

    @async static public function getRecentWishes(num:Int):Array<giffon.db.Wish> {
        var wish_results:QueryResults = (@await dbConnectionPool.query(
            '
                (
                    SELECT wish_id
                    FROM wish
                    WHERE wish_state = "succeed"
                    ORDER BY wish_time_publish DESC
                    LIMIT ?
                )
                UNION DISTINCT
                (
                    SELECT wish_id
                    FROM wish
                    WHERE wish_state != "cancelled" && wish_state != "created"
                    ORDER BY wish_time_publish DESC
                    LIMIT ?
                )
            ',
            [Math.ceil(num*0.5), num]
        ).toPromise()).results;

        var wishes = @await tink.core.Promise.inParallel([
            for (wish in wish_results.slice(0, num))
            getWish(wish.wish_id)
        ]);
        return wishes;
    }

    static public function userAvatarStyle(user:giffon.db.User) {
        if (user.user_avatar == null) {
            return {};
        }

        return {
            backgroundImage: 'url("${user.user_avatar}")',
        }
    }

    @async static public function getWishes(user_id:Int):Array<giffon.db.Wish> {
        var wish_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `wish_id`
                FROM wish
                WHERE `user_id` = ?
            ",
            [user_id]
        ).toPromise()).results;
        var wishes = @await tink.core.Promise.inParallel([
            for (wish in wish_results)
            getWish(wish.wish_id)
        ]);
        return wishes;
    }

    @async static public function getRoles(user_id:Int):Array<giffon.db.Role> {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT user_role
                FROM user_role
                INNER JOIN user ON user.user_id = user_role.user_id
                WHERE user.`user_id` = ?
            ",
            [user_id]
        ).toPromise()).results;
        return if (results == null) {
            [];
        } else {
            [for (row in results) row.user_role];
        }
    }

    @async static public function getSocialProfiles(user_id:Int):{
        facebook_profile:Null<js.npm.passport.Profile>,
        twitter_profile:Null<js.npm.passport.Profile>,
        google_profile:Null<js.npm.passport.Profile>,
        github_profile:Null<js.npm.passport.Profile>,
        gitlab_profile:Null<js.npm.passport.Profile>,
        youtube_profile:Null<js.npm.passport.Profile>,
        twitch_profile:Null<js.npm.passport.Profile>,
    } {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT  user_facebook.passport_profile AS facebook_profile,
                        user_twitter.passport_profile AS twitter_profile,
                        user_google.passport_profile AS google_profile,
                        user_github.passport_profile AS github_profile,
                        user_gitlab.passport_profile AS gitlab_profile,
                        user_youtube.passport_profile AS youtube_profile,
                        user_twitch.passport_profile AS twitch_profile
                FROM user
                LEFT OUTER JOIN user_facebook ON user.user_id = user_facebook.user_id
                LEFT OUTER JOIN user_twitter ON user.user_id = user_twitter.user_id
                LEFT OUTER JOIN user_google ON user.user_id = user_google.user_id
                LEFT OUTER JOIN user_github ON user.user_id = user_github.user_id
                LEFT OUTER JOIN user_gitlab ON user.user_id = user_gitlab.user_id
                LEFT OUTER JOIN user_youtube ON user.user_id = user_youtube.user_id
                LEFT OUTER JOIN user_twitch ON user.user_id = user_twitch.user_id
                WHERE user.user_id = ?
            ",
            [user_id]
        ).toPromise()).results;
        if (results == null || results.length < 1)
            throw "user not found";
        if (results.length > 1)
            throw 'There are ${results == null ? 0 : results.length} users with user_id = ${user_id}.';

        return results[0];
    }

    @async static public function getSocialIds(user_id:Int):{
        facebook_id:Null<String>,
        twitter_id:Null<String>,
        google_id:Null<String>,
        github_id:Null<String>,
        gitlab_id:Null<String>,
        youtube_id:Null<String>,
        twitch_id:Null<String>,
    } {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT facebook_id, twitter_id, google_id, github_id, gitlab_id, youtube_id, twitch_id
                FROM user
                LEFT OUTER JOIN user_facebook ON user.user_id = user_facebook.user_id
                LEFT OUTER JOIN user_twitter ON user.user_id = user_twitter.user_id
                LEFT OUTER JOIN user_google ON user.user_id = user_google.user_id
                LEFT OUTER JOIN user_github ON user.user_id = user_github.user_id
                LEFT OUTER JOIN user_gitlab ON user.user_id = user_gitlab.user_id
                LEFT OUTER JOIN user_youtube ON user.user_id = user_youtube.user_id
                LEFT OUTER JOIN user_twitch ON user.user_id = user_twitch.user_id
                WHERE user.user_id = ?
            ",
            [user_id]
        ).toPromise()).results;
        if (results == null || results.length < 1)
            throw "user not found";
        if (results.length > 1)
            throw 'There are ${results == null ? 0 : results.length} users with user_id = ${user_id}.';

        return results[0];
    }

    @async static public function getUser(user_id:Int):giffon.db.User {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT user.`user_id`, `user_hashid`, `user_primary_email`, `user_name`, `user_avatar`, `user_avatar_url`, `user_description`, `user_url`
                FROM user LEFT JOIN (SELECT * FROM user_url WHERE is_latest=1) AS user_url ON user.user_id = user_url.user_id
                WHERE user.`user_id` = ?
            ",
            [user_id]
        ).toPromise()).results;

        if (results == null || results.length < 1)
            return null;
        if (results.length > 1)
            throw 'There are ${results == null ? 0 : results.length} users with user_id = ${user_id}.';
        
        var user:{
            user_id:Int,
            user_hashid:String,
            user_primary_email:Null<String>,
            user_name:String,
            user_avatar:js.node.Buffer,
            user_avatar_url:Null<String>,
            user_description:Null<String>,
            user_url:Null<String>,
        } = results[0];
        return {
            user_id: user.user_id,
            user_hashid: user.user_hashid,
            user_primary_email: user.user_primary_email,
            user_name: user.user_name,
            user_avatar: switch [user.user_avatar, user.user_avatar_url] {
                case [_, url] if (url != null):
                    url;
                case [buf, _] if (buf != null):
                    ImageDataUri.encode(buf, "JPEG");
                case _:
                    null;
            },
            user_description: user.user_description,
            user_profile_url: switch (user.user_url) {
                case null:
                    'user?id=${user.user_hashid}';
                case url:
                    url;
            },
        };
    }

    @async static public function getCouponUsedByUser(user_id:Int):Array<giffon.db.Coupon> {
        var results:QueryResults = (@await dbConnectionPool.query(
            '
                SELECT coupon_id
                FROM wish
                INNER JOIN pledge ON wish.wish_id = pledge.wish_id
                INNER JOIN pledge_coupon ON pledge.pledge_id = pledge_coupon.pledge_id
                WHERE wish.user_id = ? AND wish.wish_state != "cancelled"
            ',
            [user_id]
        ).toPromise()).results;

        if (results == null || results.length < 1)
            return [];

        var p = @await Promise.inParallel([for (r in results) getCoupon(r.coupon_id)]);
        return p.filter(function(c) return c != null);
    }

    @async static public function getCouponNumUsed(coupon_id:Int):Int {
        var results:QueryResults = (@await dbConnectionPool.query(
            '
                SELECT COUNT(coupon_id) AS num_used
                FROM wish
                INNER JOIN pledge ON wish.wish_id = pledge.wish_id
                INNER JOIN pledge_coupon ON pledge.pledge_id = pledge_coupon.pledge_id
                WHERE pledge_coupon.coupon_id = ? AND wish.wish_state != "cancelled"
            ',
            [coupon_id]
        ).toPromise()).results;

        if (results == null || results.length < 1)
            return 0;
        
        return results[0].num_used;
    }

    @async static public function getCouponsAppliedToWish(wish_id:Int):Array<giffon.db.Coupon> {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT coupon_id
                FROM wish
                INNER JOIN pledge ON wish.wish_id = pledge.wish_id
                INNER JOIN pledge_coupon ON pledge.pledge_id = pledge_coupon.pledge_id
                WHERE wish.wish_id = ?
            ",
            [wish_id]
        ).toPromise()).results;

        if (results == null || results.length < 1)
            return [];

        var p = @await Promise.inParallel([for (r in results) getCoupon(r.coupon_id)]);
        return p.filter(function(c) return c != null);
    }

    @async static public function getCouponFromCode(coupon_code:Null<String>):Null<giffon.db.Coupon> {
        if (coupon_code == null) return null;

        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT coupon_id
                FROM coupon
                WHERE coupon_code = ?
            ",
            [coupon_code]
        ).toPromise()).results;
        if (results == null || results.length < 1)
            return null;
        if (results.length > 1)
            throw 'There are ${results == null ? 0 : results.length} coupons with coupon_code = ${coupon_code}.';

        var r:{
            coupon_id:Int,
        } = results[0];
        return @await getCoupon(r.coupon_id);
    }

    @async static public function uploadUserImage(img:js.node.Buffer):String {
        var fileBytes = haxe.io.Bytes.ofData(img.buffer);
        var hash = haxe.crypto.Md5.make(fileBytes).toHex();
        var fileExt = js.npm.image_type.ImageType.imageType(img).ext;
        var fileName = hash + "." + fileExt;
        @await (new js.npm.aws_sdk.S3().upload({
            Bucket: "giffon-user",
            Key: fileName,
            Body: img,
        }).promise().toPromise());
        return "https://d1ksq9ahsv51u8.cloudfront.net/" + fileName;
    }

    @async static public function getCoupon(coupon_id:Int):Null<giffon.db.Coupon> {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT coupon_id, coupon_creator_id, coupon_code, coupon_value_HKD, coupon_value_USD, coupon_quota, coupon_deadline, coupon_social
                FROM coupon
                WHERE coupon_id = ?
            ",
            [coupon_id]
        ).toPromise()).results;
        if (results == null || results.length < 1)
            return null;
        if (results.length > 1)
            throw 'There are ${results == null ? 0 : results.length} coupons with coupon_id = ${coupon_id}.';
        
        var r:{
            coupon_id:Int,
            coupon_creator_id:Null<Int>,
            coupon_code:Null<String>,
            coupon_value_HKD:Null<String>,
            coupon_value_USD:Null<String>,
            coupon_quota:Null<Int>,
            coupon_deadline:Null<Date>,
            coupon_social:Null<Array<String>>,
        } = results[0];
        return {
            coupon_id: r.coupon_id,
            coupon_creator_id: r.coupon_creator_id,
            coupon_code: r.coupon_code,
            coupon_value_HKD: Decimal.fromString(r.coupon_value_HKD),
            coupon_value_USD: Decimal.fromString(r.coupon_value_USD),
            coupon_quota: r.coupon_quota,
            coupon_deadline: r.coupon_deadline,
            coupon_social: r.coupon_social,
        }
    }

    static function __init__():Void {
        js.Node.require("dotenv").config({
            path: Path.join([Sys.getCwd(), "private", ".env"])
        });

        var sms:Dynamic = require("source-map-support");
        sms.install();
        haxe.CallStack.wrapCallSite = sms.wrapCallSite;
    }

    @await static function passportHandler(req:Request, accessToken, refreshToken, profile:js.npm.passport.Profile, done:Function) {
        // trace(haxe.Json.stringify(profile, null, "  "));
        var signedInUser:Null<giffon.db.User> = req.user;

        var email = if (profile.emails == null || profile.emails.length <= 0) {
            null;
        } else {
            profile.emails[0].value;
        }
        var avatarUrl = profile.photos == null || profile.photos.length < 1 ? null : profile.photos[0].value;

        // somehow gitlab uses "avatarUrl" instead of "photos"
        switch [avatarUrl, untyped profile.avatarUrl] {
            case [null, url] if (url != null):
                avatarUrl = url;
            case _: //pass
        }

        // get user_id
        var user_id:Null<Int> = null;

        if (signedInUser != null) {
            //connect
            user_id = signedInUser.user_id;

            var socialIds:DynamicAccess<String> = @await getSocialIds(user_id);
            var p = switch (profile.provider) {
                case "twitch.js": "twitch";
                case p: p;
            }

            if (socialIds[p + "_id"] == null)
                try {
                    @await savePassportProfile(user_id, profile);
                } catch(err:Dynamic) {
                    done(err);
                    return;
                }
        }

        if (user_id == null)
            user_id = @await getUserIdFromPassportProfile(profile);

        if (user_id == null) {
            user_id = @await getUserIdFromEmail(email);
            if (user_id != null) {
                try {
                    @await savePassportProfile(user_id, profile);
                } catch (err:Dynamic) {
                    done(err);
                    return;
                }
            }
        }

        if (user_id != null) {
            var user = @await getUser(user_id);

            // update passport_profile
            try {
                @await updatePassportProfile(user_id, profile);
            } catch (err:Dynamic) {
                done(err);
                return;
            }

            // update avatar if it's not set yet
            if (user.user_avatar == null && avatarUrl != null) {
                var avatar = {
                    var res = @await js.npm.fetch.Fetch.fetch(avatarUrl).toPromise();
                    @await res.buffer().toPromise();
                };
                var url = @await uploadUserImage(avatar);
                @await dbConnectionPool.query("UPDATE user SET ? WHERE user_id = ?", [{
                    user_avatar_url: url,
                }, user_id]).toPromise();
                user = @await getUser(user_id);
            }

            done(null, user);
            return;
        }

        // insert user

        var avatar:Null<js.node.Buffer> = avatarUrl == null ? null : {
            var res = @await js.npm.fetch.Fetch.fetch(avatarUrl).toPromise();
            @await res.buffer().toPromise();
        };
        var avatar_url = @await uploadUserImage(avatar);

        var results:QueryResults = (@await dbConnectionPool.query("INSERT INTO user SET ?", {
            user_primary_email: email,
            user_name: profile.displayName,
            user_avatar_url: avatar_url,
        }).handleError(done).toPromise()).results;
        user_id = results.insertId;
        var user_hashid = new Hashids("user" + DBInfo.salt, 4).encode(user_id);
        @await dbConnectionPool.query(
            "UPDATE user SET `user_hashid` = ? WHERE `user_id` = ?",
            ([user_hashid, user_id]:Array<Dynamic>)
        ).handleError(done).toPromise();

        try{
            @await savePassportProfile(user_id, profile);
        } catch (err:Dynamic) {
            done(err);
        }

        var user = @await getUser(user_id);
        done(null, user);
    }

    @async static function savePassportProfile(user_id:Int, profile:js.npm.passport.Profile) {
        var p = switch(profile.provider) {
            case "twitch.js": "twitch";
            case p = "facebook" | "github" | "twitter" | "gitlab" | "google" | "youtube":
                p;
            case p:
                trace("unknown provider: " + p);
                return null;
        }
        return @await dbConnectionPool.query(
            'INSERT INTO user_${p} SET user_id=?, ${p}_id=?, passport_profile=?',
            ([user_id, profile.id, Json.stringify(profile)]:Array<Dynamic>)
        ).toPromise();
    }

    @async static function updatePassportProfile(user_id:Int, profile:js.npm.passport.Profile) {
        var p = switch(profile.provider) {
            case "twitch.js": "twitch";
            case p = "facebook" | "github" | "twitter" | "gitlab" | "google" | "youtube":
                p;
            case p:
                trace("unknown provider: " + p);
                return null;
        }
        return @await dbConnectionPool.query(
            'UPDATE user_${p} SET passport_profile=? WHERE user_id=? && ${p}_id=?',
            ([Json.stringify(profile), user_id, profile.id]:Array<Dynamic>)
        ).toPromise();
    }

    @await static function main():Void {
        haxe.Log.trace = haxe.Log.trace;
        var isMain = (untyped __js__("require")).main == module;

        var dbConfig:Mysql.ConnectionOptions = {
            host: DBInfo.host,
            user: DBInfo.user,
            password: DBInfo.password,
            database: DBInfo.database,
            charset: DBInfo.charset,
            connectTimeout: 10.0 * 1000.0, //10 seconds
        };

        stripe = new Stripe(StripeInfo.apiSecKey);
        stripe.setTimeout(10 * 1000); //10 seconds

        var poolConfig:Mysql.PoolOptions = cast Reflect.copy(dbConfig);
        poolConfig.multipleStatements = true;
        poolConfig.connectionLimit = 3;
        //poolConfig.debug = true;
        dbConnectionPool = Mysql.createPool(poolConfig);

        var app = new Application();
        app.locals.canonicalBase = canonicalBase;
        app.locals.title = "Giffon";

        if (!isMain) {
            var awsServerlessExpressMiddleware = require('aws-serverless-express/middleware');
            app.use(awsServerlessExpressMiddleware.eventContext());
        }

        app.use(require("morgan")("tiny"));

        app.use(require("cookie-parser")());
        app.use(require("body-parser").urlencoded({
            extended: false
        }));
        app.use(require("body-parser").json({
            limit: '16mb',
        }));
        app.use(require("body-parser").text());

        app.use(function(req:Request, res:Response, next){
            var lang:Language = switch (req.path.split("/")[1]) {
                case "en":
                    English;
                case "zh-HK":
                    Cantonese;
                case null, "", _:
                    giffon.lang.LanguageTools.langFromCode(req.acceptsLanguages('en', 'zh'));
            }
            res.locals.language = lang;
            res.setHeader("Content-Language", giffon.lang.LanguageTools.code(lang));
            next();
        });

        app.use(Express.Static("www", {
            dotfiles: "ignore",
            redirect: true
        }));

        var session = require("express-session");
        var MySQLStore = require('express-mysql-session')(session);
        var sessionPoolConfig:Mysql.PoolOptions = cast Reflect.copy(poolConfig);
        sessionPoolConfig.connectionLimit = 1;
        sessionPoolConfig.acquireTimeout = 10.0 * 1000.0; //10 seconds
        var sessionStore = untyped __js__("new {0}({1})", MySQLStore, sessionPoolConfig);
        var cookieSetting:Dynamic = {
            secure: switch (Stage.stage) {
                case Production: true;
                case _: false;
            },
        };
        if (base != null) {
            cookieSetting.domain = base.substr(base.indexOf("//")+2);
        }
        var sess = {
            secret: Utils.env("SESSION_SECRET", "secret"),
            store: sessionStore,
            cookie: cookieSetting,
            resave: false,
            saveUninitialized: true
        };
        app.use(session(sess));

        //https://stackoverflow.com/questions/20739744/passportjs-callback-switch-between-http-and-https
        app.enable("trust proxy");

        app.use(function(req, res:ExpressResponse, next){
            res.setHeader("Access-Control-Allow-Origin", "*");
            res.setHeader("Access-Control-Allow-Credentials", "true");
            next();
        });

        var fbStrategy = new FacebookStrategy({
            clientID: FacebookInfo.FACEBOOK_CLIENT_ID,
            clientSecret: FacebookInfo.FACEBOOK_APP_SECRET,
            callbackURL: absPath("/callback/facebook"),
            profileFields: ['id', 'displayName', 'email', 'picture.type(large)'],
            passReqToCallback: true,
        }, passportHandler);

        var ghStrategy = new GitHubStrategy({
            clientID: GitHubInfo.GITHUB_CLIENT_ID,
            clientSecret: GitHubInfo.GITHUB_CLIENT_SECRET,
            callbackURL: absPath("/callback/github"),
            passReqToCallback: true,
        }, passportHandler);

        var twStrategy = new TwitterStrategy({
            consumerKey: TwitterInfo.TWITTER_CONSUMER_KEY,
            consumerSecret: TwitterInfo.TWITTER_CONSUMER_SECRET,
            callbackURL: absPath("/callback/twitter"),
            includeEmail: true,
            passReqToCallback: true,
        }, passportHandler);

        var glStrategy = new GitLabStrategy({
            clientID: GitLabInfo.GITLAB_APP_ID,
            clientSecret: GitLabInfo.GITLAB_APP_SECRET,
            callbackURL: absPath("/callback/gitlab"),
            passReqToCallback: true,
        }, passportHandler);

        var ggStrategy = new GoogleStrategy({
            clientID: GoogleInfo.GOOGLE_CLIENT_ID,
            clientSecret: GoogleInfo.GOOGLE_CLIENT_SECRET,
            callbackURL: absPath("/callback/google"),
            passReqToCallback: true,
        }, passportHandler);

        var ytStrategy = new YoutubeV3Strategy({
            clientID: GoogleInfo.GOOGLE_CLIENT_ID,
            clientSecret: GoogleInfo.GOOGLE_CLIENT_SECRET,
            callbackURL: absPath("/callback/youtube"),
            scope: ['https://www.googleapis.com/auth/youtube.readonly'],
            passReqToCallback: true,
        }, passportHandler);

        var twitchStrategy = new TwitchStrategy({
            clientID: TwitchInfo.TWITCH_CLIENT_ID,
            clientSecret: TwitchInfo.TWITCH_CLIENT_SECRET,
            callbackURL: absPath("/callback/twitch"),
            scope: ["user_read"],
            passReqToCallback: true,
        }, passportHandler);

        Passport.serializeUser(function (user:giffon.db.User, done) {
            done(null, user.user_id);
        });
        Passport.deserializeUser(@await function (user_id:Int, done) {
            done(null, @await getUser(user_id));
        });
        Passport.use(fbStrategy);
        Passport.use(ghStrategy);
        Passport.use(twStrategy);
        Passport.use(glStrategy);
        Passport.use(ggStrategy);
        Passport.use(ytStrategy);
        Passport.use(twitchStrategy);
        app.use(Passport.initialize());
        app.use(Passport.session());

        // put user in res
        app.use(function(req:Request, res:Response, next) {
            if (req.user != null) {
                res.setUser(req.user);
            }
            next();
        });

        app.get("/callback/:auth_method", function(req:Request, res:Response, next) {
            var auth_method = req.params.auth_method;
            if (!Type.allEnums(giffon.db.AuthMethod).exists(function(a) return a.getName().toLowerCase() == auth_method)) {
                res.sendPlainError("unknown auth method", NotFound);
                return;
            }
            var pName = switch(auth_method) {
                case "twitch": "twitch.js";
                case _: auth_method;
            }
            Passport.authenticate(pName, function (err, user:giffon.db.User, info) {
                if (err != null) {
                    return res.sendPlainError(err);
                }
                if (user == null) {
                    return res.sendPlainError("unable to login");
                }
                req.login(user, function (err) {
                    if (err != null) {
                        return res.sendPlainError(err);
                    }
                    res.setUser(user);
                    var base = switch (req.baseUrl) {
                        case null, "": "/";
                        case _: req.baseUrl;
                    }
                    var redirectTo = switch (req.getRedirectTo()) {
                        case null:
                            base;
                        case r: r;
                    }
                    res.redirect(redirectTo);
                });
            })(req, res, next);
        });

        var pageRouter = PageRouter.createRouter();

        app.use(["/en", "/zh-HK", "/"], pageRouter);

        app.use(function(err, req, res:Response, next) {
            res.sendPlainError(err, 500);
            return;
        });

        module.exports.app = app;

        if (isMain) {
            var port = 3000;
            js.Node.require("httpolyglot").createServer({
                key: js.node.Fs.readFileSync("dev/ssl/key.pem"),
                cert: js.node.Fs.readFileSync("dev/ssl/cert.pem"),
            }, app)
                .listen(port, function(){
                    trace('http://localhost:$port');
                    trace('https://localhost:$port');
                });
        }
    }
}