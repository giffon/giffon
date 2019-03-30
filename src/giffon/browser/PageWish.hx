package giffon.browser;

import js.Browser.*;
import js.jquery.JQuery;

class PageWish {
    static public function onReady():Void {
        var addPledgeBtn = new JQuery("button.add-pledge");
        addPledgeBtn.click(function(evt){
            evt.preventDefault();
            new JQuery("form.add-pledge").show();
            addPledgeBtn.hide();
        });

        (untyped new JQuery(".wish-total")).tooltip();
    }
}

