package giffon.browser;

import js.Browser.*;
import js.jquery.JQuery;
import thx.Decimal;
import react.*;
import haxe.io.*;

class PageWish {
    static public function onReady():Void {
        var wish_hashid = document.body.getAttribute("data-wish-hashid");
        switch (document.getElementById("pledge-form-root")) {
            case null: //pass
            case root:
                ReactDOM.render(React.createElement(PledgeForm, {
                    wish_hashid: wish_hashid,
                    wish_total_needed: Decimal.fromString(document.body.getAttribute("data-wish-total-needed")),
                    user_total_pledge: Decimal.fromString(document.body.getAttribute("data-user-total-pledge")),
                }), root);
        }

        switch (document.getElementById("how-to-help-root")) {
            case null: //pass
            case root:
                ReactDOM.render(React.createElement(WishHowToHelpSection), root);
        }

        var cancelWishBtn = new JQuery(".cancel-wish-btn");
        cancelWishBtn.click(function(evt){
            evt.preventDefault();
            JQuery.ajax({
                type: "DELETE",
                contentType: "application/json; charset=utf-8",
                url: Path.join(["/wish", wish_hashid]),
            })
                .done(function(data:String){
                    document.location.reload(true);
                })
                .fail(function(err){
                    alert(err);
                });
        });
    }
}

