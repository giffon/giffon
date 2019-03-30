package giffon.browser;

import js.Browser.*;
import js.jquery.JQuery;
import js.stripe.Stripe;
import giffon.config.*;

class PageCards {
    static function stripeTokenHandler(token) {
        var form:js.html.FormElement = cast document.getElementById('payment-form');
        var hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', 'stripeToken');
        hiddenInput.setAttribute('value', token.id);
        form.appendChild(hiddenInput);
        form.submit();
    }

    static public function onReady():Void {
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

