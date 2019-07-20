package giffon.browser;

import js.Browser.*;
import js.jquery.JQuery;
import thx.Decimal;
import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
using StringTools;

class PageWish {
    static public function onReady():Void {
        var plainLinkEle:js.html.LinkElement = cast document.querySelector('link[hrefLang="x-default"]');
        var plainLink = plainLinkEle.href;
        var wish_hashid = document.body.getAttribute("data-wish-hashid");
        var wish_currency = document.body.getAttribute("data-wish-currency");
        switch (document.getElementById("pledge-form-root")) {
            case null: //pass
            case root:
                ReactDOM.render(React.createElement(PledgeForm, {
                    wish_hashid: wish_hashid,
                    wish_currency: giffon.db.Currency.createByName(wish_currency),
                    wish_total_needed: Decimal.fromString(document.body.getAttribute("data-wish-total-needed")),
                    user_support: haxe.Unserializer.run(document.body.getAttribute("data-user-support")),
                }), root);
        }

        switch (document.getElementById("how-to-help-root")) {
            case null: //pass
            case root:
                ReactDOM.render(React.createElement(WishHowToHelpSection), root);
        }

        for (root in document.getElementsByClassName("copy-link-button-root")) {
            ReactDOM.render(jsx('
                <CopyLinkButton clipboardText=${plainLink} />
            '), root);
        }

        var cancelWishBtn = new JQuery(".cancel-wish-btn");
        cancelWishBtn.click(function(evt){
            evt.preventDefault();
            JQuery.ajax({
                type: "DELETE",
                contentType: "application/json; charset=utf-8",
                url: Path.join([BrowserMain.instance.base, "wish", wish_hashid]),
            })
                .done(function(data:String){
                    document.location.reload(true);
                })
                .fail(function(err){
                    alert(err);
                });
        });

        var applyCouponForm = new JQuery(".apply-coupon-form");
        applyCouponForm.submit(function(evt){
            evt.preventDefault();
            var coupon_code:String = new JQuery("input[name='coupon_code']").val().trim();
            if (coupon_code == null || coupon_code == "") {
                return;
            }
            JQuery.ajax({
                type: "POST",
                contentType: "text/plain; charset=utf-8",
                url: Path.join([BrowserMain.instance.base, "wish", wish_hashid, "coupon"]),
                data: coupon_code,
            })
                .done(function(data:String){
                    document.location.reload(true);
                })
                .fail(function(err){
                    alert(err.responseText == null ? err.statusText : err.responseText);
                });
        });
    }
}

