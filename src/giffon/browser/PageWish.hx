package giffon.browser;

import js.Browser.*;
import js.jquery.JQuery;
import thx.Decimal;
import react.*;

class PageWish {
    static public function onReady():Void {
        var addPledgeBtn = new JQuery("button.add-pledge");
        addPledgeBtn.click(function(evt){
            evt.preventDefault();
            new JQuery("form.add-pledge").show();
            addPledgeBtn.hide();
        });

        switch (document.getElementById("pledge-form-root")) {
            case null: //pass
            case root:
                ReactDOM.render(React.createElement(PledgeForm, {
                    wish_hashid: document.body.getAttribute("data-wish-hashid"),
                    wish_total_needed: Decimal.fromString(document.body.getAttribute("data-wish-total-needed")),
                    user_total_pledge: Decimal.fromString(document.body.getAttribute("data-user-total-pledge")),
                }), root);
        }
    }
}

