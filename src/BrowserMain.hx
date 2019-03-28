import js.Browser.*;
import js.jquery.JQuery;
import js.stripe.Stripe;

typedef Session = {
    var access_token:String;
    var id_token:String;
    var expires_at:Float;
}

extern class Cookies {
    static public function set(name:String, value:String, ?options:Dynamic):Void;

    @:overload(function():Dynamic<String>{})
    static public function get(name:String):Null<String>;

    static public function getJSON(?name:String):Null<Dynamic>;

    static public function remove(name:String, ?options:Dynamic):Void;
}

class BrowserMain {
    static function main():Void {
        new BrowserMain();
    }

    var session(get, null):Null<Session>;

    public function new():Void {
        new JQuery(onReady);
    }

    function get_session():Null<Session> {
        if (session != null) {
            return session;
        }

        var cookie = Cookies.get();
        if (cookie.id_token != null && cookie.expires_at != null && cookie.access_token != null) {
            var expires_at = Std.parseFloat(cookie.expires_at);
            if (expires_at < Date.now().getTime()) {
                return null;
            }
            return this.session = {
                id_token: cookie.id_token,
                expires_at: expires_at,
                access_token: cookie.access_token
            };
        }
        return null;
    }

    function onReady():Void {
        if (document.body.classList.contains("page-cards")) {
            cards();
        }

        if (document.body.classList.contains("page-wish")) {
            wish();
        }
    }

    static function removeHash():Void { 
        var scrollV, scrollH, loc = window.location;
        if (window.history.pushState != null) {
            window.history.pushState("", document.title, loc.pathname + loc.search);
        } else {
            // Prevent scrolling by storing the page's current scroll offset
            scrollV = document.body.scrollTop;
            scrollH = document.body.scrollLeft;

            loc.hash = "";

            // Restore the scroll offset, should be flicker free
            document.body.scrollTop = scrollV;
            document.body.scrollLeft = scrollH;
        }
    }

    static function stripeTokenHandler(token) {
        var form:js.html.FormElement = cast document.getElementById('payment-form');
        var hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', 'stripeToken');
        hiddenInput.setAttribute('value', token.id);
        form.appendChild(hiddenInput);
        form.submit();
    }

    static function wish():Void {
        var addPledgeBtn = new JQuery("button.add-pledge");
        addPledgeBtn.click(function(evt){
            evt.preventDefault();
            new JQuery("form.add-pledge").show();
            addPledgeBtn.hide();
        });

        (untyped new JQuery(".wish-total")).tooltip();
    }

    static function cards():Void {
        var stripe = new Stripe(document.location.hostname.indexOf("giffon.io") < 0 ? StripeInfo.apiTestPubKey : StripeInfo.apiPubKey);
        var elements = stripe.elements({
            locale: document.documentElement.lang
        });

        var style = {
            base: {
                fontSize: '16px',
                color: "#32325d",
            }
        };
        var card = elements.create('card', {style: style});
        card.mount('#card-element');

        card.addEventListener('change', function(event) {
            var displayError = document.getElementById('card-errors');
            if (event.error != null) {
                displayError.textContent = event.error.message;
            } else {
                displayError.textContent = '';
            }
        });

        var form = document.getElementById('payment-form');
        form.addEventListener('submit', function(event) {
            event.preventDefault();

            stripe.createToken(card).then(function(result) {
                if (result.error != null) {
                    var errorElement = document.getElementById('card-errors');
                    errorElement.textContent = result.error.message;
                } else {
                    stripeTokenHandler(result.token);
                }
            });
        });

        var replaceCardLink = new JQuery("a#replace-card");
        replaceCardLink.click(function(evt){
            evt.preventDefault();

            new JQuery(form).show();

            replaceCardLink.hide();
        });
    }
}
