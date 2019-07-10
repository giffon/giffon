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
using Lambda;

@await
class Wish {
    static public function createRouter():Router {
        var router = new Router();
        router.get("/wish/:wish_hashid", handleGet);
        router.delete("/wish/:wish_hashid", ensureLoggedIn, handleWishCancel);
        router.post("/wish/:wish_hashid/coupon", ensureLoggedIn, handleCoupon);
        router.post("/wish/:wish_hashid/pledge", ensureLoggedIn, handlePledge);
        router.delete("/wish/:wish_hashid/pledge", ensureLoggedIn, handlePledgeCancel);
        router.get("/wish/:wish_hashid/edit", ensureLoggedIn, handleEditGet);
        router.post("/wish/:wish_hashid/edit", ensureLoggedIn, handleEditPost);
        return router;
    }

    @await static function handleGet(req, res:Response, next):Void {
        var wish_hashid = req.params.wish_hashid;
        var wish_id = @await getWishIdFromHash(wish_hashid);
        if (wish_id == null) {
            res.sendPlainError("There is no such wish.", 404);
            return;
        }
        var wish = @await getWish(wish_id);
        if (wish == null) {
            res.sendPlainError("There is no such wish.", 404);
            return;
        }
        var user_total_pledge = Decimal.zero;
        var user = res.getUser();
        res.sendPage(giffon.view.Wish, {
            wish: wish,
            user_support: user == null ? null : wish.supporters.find(function(s) return s.user.user_id == user.user_id),
        });
    }

    @await static function handleWishCancel(req:Request, res:Response, next:Dynamic){
        var wish_hashid = req.params.wish_hashid;
        var wish_id = @await getWishIdFromHash(wish_hashid);
        if (wish_id == null) {
            res.sendPlainError("There is no such wish.", NotFound);
            return;
        }
        var wish = @await getWish(wish_id);
        if (wish == null) {
            res.sendPlainError("There is no such wish.", NotFound);
            return;
        }

        var user = res.getUser();
        if (user.user_id != wish.wish_owner.user_id) {
            res.sendPlainError("Only the wish owner can cancel the wish.", Forbidden);
            return;
        }

        switch (wish.wish_state) {
            case Succeed | Cancelled:
                res.sendPlainError('Cannot cancel a ${wish.wish_state} wish.', BadRequest);
                return;
            case _:
                //pass
        }

        //TODO: use transaction

        @await dbConnectionPool.query(
            "UPDATE wish SET `wish_state` = \"cancelled\" WHERE `wish_id` = ?",
            ([wish_id]:Array<Dynamic>)
        ).handleError(next).toPromise();

        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `stripe_charge_id`, `user_id`
                FROM `pledge_stripe`
                INNER JOIN `pledge` ON `pledge`.`pledge_id` = `pledge_stripe`.`pledge_id`
                WHERE `wish_id` = ?
            ",
            [wish.wish_id]
        ).handleError(next).toPromise()).results;

        for (result in results) {
            var chargeId = result.stripe_charge_id;
            var user_id = result.user_id;
            var charge = @await stripe.charges.retrieve(chargeId).handleError(next).toPromise();
            if (charge.amount_refunded != charge.amount) {
                @await stripe.charges.refund(chargeId).toPromise();
                @await dbConnectionPool.query(
                    "
                        INSERT INTO `pledge` SET ?;
                    ",{
                        user_id: user_id,
                        wish_id: wish_id,
                        pledge_amount: (Decimal.fromFloat(charge.amount_refunded - charge.amount) * 0.01).toFloat(), //cents -> dollars
                        pledge_currency: wish.wish_currency.getName(),
                        pledge_method: giffon.db.PledgeMethod.StripeCard.getName(),
                    }
                ).handleError(next).toPromise();
            }
        }
        res.sendPlainText("done");
    }

    @await static function handleCoupon(req:Request, res:Response, next:Dynamic){
        var wish_hashid = req.params.wish_hashid;
        var wish_id = @await getWishIdFromHash(wish_hashid);
        if (wish_id == null) {
            res.sendPlainError("There is no such wish.", NotFound);
            return;
        }
        var wish = @await getWish(wish_id);
        if (wish == null) {
            res.sendPlainError("There is no such wish.", NotFound);
            return;
        }

        switch (wish.wish_state) {
            case Succeed | Cancelled:
                res.sendPlainError('Cannot apply coupon to a ${wish.wish_state} wish.', BadRequest);
                return;
            case _:
                //pass
        }

        if (wish.appliedCoupons.length >= 1) {
            res.sendPlainError("There can be at most one coupon applied to a wish.", BadRequest);
            return;
        }

        var user = res.getUser();
        if (user.user_id != wish.wish_owner.user_id) {
            res.sendPlainError("Only the wish owner can apply coupon.", Forbidden);
            return;
        }

        var coupon_code:String = req.body;
        var coupon:Null<giffon.db.Coupon> = @await getCouponFromCode(coupon_code.toUpperCase());
        if (coupon == null) {
            res.sendPlainError("Invalid coupon code", BadRequest);
            return;
        }

        if (coupon.coupon_deadline != null && coupon.coupon_deadline.getTime() < Date.now().getTime()) {
            res.sendPlainError("Coupon expired", BadRequest);
            return;
        }

        switch (coupon.coupon_social) {
            case null: //pass
            case socials:
                var profiles = @await getSocialProfiles(user.user_id);
                if (!socials.exists(function(s) return Reflect.field(profiles, '${s}_profile') != null)) {
                    res.sendPlainError('Coupon is only applicable to accounts that are connected to ${socials.join(" or ")}.', BadRequest);
                    return;
                }
        }

        var usedCoupons = @await getCouponUsedByUser(user.user_id);
        if (usedCoupons.exists(function(c) return c.coupon_code == coupon.coupon_code)) {
            res.sendPlainError("Coupon has already been used by user.", Forbidden);
            return;
        }

        switch (coupon.coupon_quota) {
            case null: //pass
            case quota:
                var numUsed = @await getCouponNumUsed(coupon.coupon_id);
                if (numUsed >= quota) {
                    res.sendPlainError('Coupon quota is full (${quota}).', BadRequest);
                    return;
                }
        }

        var coupon_value:Decimal = Reflect.field(coupon, "coupon_value_" + wish.wish_currency.getName());

        @await dbConnectionPool.query(
            "
                START TRANSACTION;
                INSERT INTO `pledge` SET ?;
                SELECT @pledge_id := LAST_INSERT_ID() AS pledge_id;
                INSERT INTO `pledge_coupon` SET pledge_id = @pledge_id, ?;
                COMMIT;
            ",
            [{
                user_id: coupon.coupon_creator_id,
                wish_id: wish_id,
                pledge_amount: coupon_value,
                pledge_currency: wish.wish_currency.getName(),
                pledge_method: giffon.db.PledgeMethod.Coupon.getName(),
                pledge_visibility: giffon.db.PledgeVisibility.VisibleToAll.getName(),
            }, {
                coupon_id: coupon.coupon_id,
            }]
        ).handleError(next).toPromise();

        res.sendPlainText("done");
    }

    @await static function handlePledge(req:Request, res:Response, next:Dynamic){
        var pledgeFormData:giffon.db.PledgeFormData = try {
            dataclass.JsonConverter.fromJson(giffon.db.PledgeFormData, req.body);
        } catch (err:Dynamic) {
            trace(haxe.Json.stringify(err));
            res.sendPlainError(err, BadRequest);
            return;
        }

        var wish_hashid = req.params.wish_hashid;
        var wish_id = @await getWishIdFromHash(wish_hashid);
        if (wish_id == null) {
            res.sendPlainError("There is no such wish.", NotFound);
            return;
        }
        var wish = @await getWish(wish_id);
        if (wish == null) {
            res.sendPlainError("There is no such wish.", NotFound);
            return;
        }

        switch (wish.wish_state) {
            case Published:
                //pass
            case _:
                res.sendPlainError("Wish is not open for pledge.", BadRequest);
                return;
        }

        var user = res.getUser();
        var stripe_customer_id = @await getStripeCustomerIdFromUser(user);

        var charge = try {
            @await stripe.charges.create({
                amount: (Decimal.fromFloat(pledgeFormData.pledge_amount) * 100).toInt(), // unit is cents
                currency: wish.wish_currency.getName().toLowerCase(),
                // customer: stripe_customer_id,
                source: pledgeFormData.pledge_data.id,
                description: 'Supporting ${wish.wish_owner.user_name}\'s wish (${wish.wish_title}).',
            }).toPromise();
        } catch (err:Dynamic) {
            res.sendPlainError(err, InternalError);
            return;
        }

        @await dbConnectionPool.query(
            "
                START TRANSACTION;
                INSERT INTO `pledge` SET ?;
                SELECT @pledge_id := LAST_INSERT_ID() AS pledge_id;
                INSERT INTO `pledge_stripe` SET pledge_id = @pledge_id, ?;
                COMMIT;
            ",
            [{
                user_id: user.user_id,
                wish_id: wish_id,
                pledge_amount: pledgeFormData.pledge_amount,
                pledge_currency: wish.wish_currency.getName(),
                pledge_method: giffon.db.PledgeMethod.StripeCard.getName(),
                pledge_visibility: pledgeFormData.pledge_visibility,
            }, {
                stripe_charge_id: charge.id,
            }]
        ).handleError(next).toPromise();

        res.redirect(absPath('/wish/$wish_hashid'));
    };

    @await static function handlePledgeCancel(req:Request, res:Response, next:Dynamic){
        var wish_hashid = req.params.wish_hashid;
        var wish_id = @await getWishIdFromHash(wish_hashid);
        if (wish_id == null) {
            res.sendPlainError("There is no such wish.", NotFound);
            return;
        }
        var wish = @await getWish(wish_id);
        if (wish == null) {
            res.sendPlainError("There is no such wish.", NotFound);
            return;
        }

        switch (wish.wish_state) {
            case Succeed | Cancelled:
                res.sendPlainError('Cannot cancel pledge for a ${wish.wish_state} wish.', BadRequest);
                return;
            case _:
                //pass
        }

        var user = res.getUser();
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `stripe_charge_id`
                FROM `pledge_stripe`
                INNER JOIN `pledge` ON `pledge`.`pledge_id` = `pledge_stripe`.`pledge_id`
                WHERE `user_id` = ? AND `wish_id` = ?
            ",
            [user.user_id, wish.wish_id]
        ).handleError(next).toPromise()).results;

        var chargeIds:Array<String> = results.map(function(r) return r.stripe_charge_id);
        for (chargeId in chargeIds) {
            var charge = @await stripe.charges.retrieve(chargeId).handleError(next).toPromise();
            if (charge.amount_refunded != charge.amount) {
                @await stripe.charges.refund(chargeId).toPromise();
                @await dbConnectionPool.query(
                    "
                        INSERT INTO `pledge` SET ?;
                    ",{
                        user_id: user.user_id,
                        wish_id: wish_id,
                        pledge_amount: (Decimal.fromFloat(charge.amount_refunded - charge.amount) * 0.01).toFloat(), //cents -> dollars
                        pledge_currency: wish.wish_currency.getName(),
                        pledge_method: giffon.db.PledgeMethod.StripeCard.getName(),
                    }
                ).handleError(next).toPromise();
            }
        }
        res.sendPlainText("done");
    }

    @await static function handleEditGet(req, res:Response, next):Void {
        var wish_hashid = req.params.wish_hashid;
        var wish_id = @await getWishIdFromHash(wish_hashid);
        if (wish_id == null) {
            res.sendPlainError("There is no such wish.", 404);
            return;
        }
        var wish = @await getWish(wish_id);
        if (wish == null) {
            res.sendPlainError("There is no such wish.", 404);
            return;
        }

        switch (wish.wish_state) {
            case Succeed | Cancelled:
                res.sendPlainError('Cannot edit a ${wish.wish_state} wish.', BadRequest);
                return;
            case _:
                //pass
        }

        var user = res.getUser();
        if (user.user_id != wish.wish_owner.user_id) {
            res.sendPlainError("Only the wish owner can edit the wish.", Forbidden);
            return;
        }
        res.sendPage(giffon.view.EditWish, {
            wish: wish,
        });
    }

    @await static function handleEditPost(req:Request, res:Response, next:Dynamic){
        var wish_hashid = req.params.wish_hashid;
        var wish_id = @await getWishIdFromHash(wish_hashid);
        if (wish_id == null) {
            res.sendPlainError("There is no such wish.", 404);
            return;
        }
        var wish = @await getWish(wish_id);
        if (wish == null) {
            res.sendPlainError("There is no such wish.", 404);
            return;
        }

        // TODO add a WHERE cause in the SQL to check with_state
        switch (wish.wish_state) {
            case Succeed | Cancelled:
                res.sendPlainError('Cannot edit a ${wish.wish_state} wish.', BadRequest);
                return;
            case _:
                //pass
        }

        var user = res.getUser();
        if (user.user_id != wish.wish_owner.user_id) {
            res.sendPlainError("Only the wish owner can edit the wish.", Forbidden);
            return;
        }

        var wishData:giffon.db.WishFormData = try {
            dataclass.JsonConverter.fromJson(giffon.db.WishFormData, req.body);
        } catch (err:Dynamic) {
            trace(haxe.Json.stringify(err));
            res.sendPlainError(err, BadRequest);
            return;
        }

        // check the non-editable values are not edited

        if (wishData.items.length > wish.items.length) {
            res.sendPlainError("Cannot add new item to an existing wish.", BadRequest);
            return;
        }

        for (item in wishData.items) {
            var oldItem = wish.items.find(function(i) return i.item_id == item.item_id);
            if (oldItem == null) {
                res.sendPlainError('Item ${item.item_id} is not one of the wish items.', BadRequest);
                return;
            }
            if (wishData.items.exists(function(i) return i != item && i.item_id == item.item_id)) {
                res.sendPlainError('Duplicated item id ${item.item_id}.', BadRequest);
                return;
            }
            if (item.item_quantity > oldItem.item_quantity) {
                res.sendPlainError('Cannot increase item quantity.');
                return;
            }
        }

        var results:Array<QueryResults> = (@await dbConnectionPool.query("
            /*0*/   START TRANSACTION;

            /*1*/   UPDATE wish SET ?
                    WHERE wish_id = ?;

            /*2*/   COMMIT;
        ", [
            {
                wish_title: wishData.wish_title,
                wish_description: wishData.wish_description,
                wish_target_date: wishData.wish_target_date,
                wish_banner_url: wishData.wish_banner_url,
                wish_additional_cost_amount : wishData.wish_additional_cost_amount,
                wish_additional_cost_description : switch (wishData.wish_additional_cost_description) {
                    case "": null;
                    case v: v;
                },
            },
            wish.wish_id
        ]).handleError(next).toPromise()).results;

        res.sendPlainText("/wish/" + wish_hashid);
    };
}