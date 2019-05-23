package giffon.browser;

import react.*;
import react.ReactMacro.jsx;
import js.npm.formik.*;
import js.npm.react_stripe_elements.*;
import thx.Decimal;
import js.jquery.*;
import js.Browser.*;
import giffon.config.*;
import giffon.db.PledgeMethod;
import giffon.db.PledgeFormData;
import giffon.db.PledgeFormData.*;
import haxe.io.*;
using Lambda;
using tink.core.Future.JsPromiseTools;

@await
class PledgeForm extends ReactComponent {
    var wish_hashid(get, never):String;
    function get_wish_hashid() return props.wish_hashid;

    var wish_currency(get, never):giffon.db.Currency;
    function get_wish_currency() return props.wish_currency;

    var wish_total_needed(get, never):Decimal;
    function get_wish_total_needed() return props.wish_total_needed;

    var user_total_pledge(get, never):Decimal;
    function get_user_total_pledge() return props.user_total_pledge;

    var isCancellingPledge(get, set):Bool;
    function get_isCancellingPledge() return state.isCancellingPledge;
    function set_isCancellingPledge(v) {
        setState({isCancellingPledge: v});
        return v;
    }

    var submissionError(get, set):Null<react.ReactComponent.ReactElement>;
    function get_submissionError() return state.submissionError;
    function set_submissionError(v) {
        setState({submissionError: v});
        return v;
    }

    function new(props):Void {
        super(props);
        state = {
            isCancellingPledge: false,
            submissionError: null,
        };
    }

    function cancelPledge(e:ReactEvent) {
        e.preventDefault();
        isCancellingPledge = true;
        JQuery.ajax({
            type: "DELETE",
            contentType: "application/json; charset=utf-8",
            url: Path.join(["/wish", wish_hashid, "pledge"]),
        })
            .done(function(data:String){
                submissionError = null;
                document.location.reload(true);
            })
            .fail(function(err){
                trace(err);
                submissionError = jsx('
                    <Fragment>
                        ${err.statusText} (${err.status})
                        <br/>
                        <pre>
                        ${err.responseText}
                        </pre>
                    </Fragment>
                ');
                isCancellingPledge = false;
            });
    }

    function pledgeInfo() {
        if (user_total_pledge > 0) {
            return jsx('
                <div>
                    You have currently pledged ${wish_currency.getName()} ${user_total_pledge.toString()}.
                    <button className="btn btn-link" onClick=${cancelPledge} disabled=${isCancellingPledge}>Cancel pledge</button>
                </div>
            ');
        } else {
            return jsx('
                <div>You haven\'t pledged your support yet.</div>
            ');
        }
    }

    override function render() {
        var form = if (user_total_pledge > 0) {
            null;
        } else {
            var injectedPledgeForm = React.createElement(ReactStripeElements.injectStripe(_PledgeForm), {
                wish_hashid: wish_hashid,
                wish_currency: wish_currency,
                wish_total_needed: wish_total_needed,
                user_total_pledge: user_total_pledge,
            });
            jsx('
                <StripeProvider apiKey=${StripeInfo.apiPubKey}>
                    <Elements>
                        ${injectedPledgeForm}
                    </Elements>
                </StripeProvider>
            ');
        }

        var submissionErrorElement =
            if (submissionError != null) {
                jsx('
                    <div className="alert alert-danger" role="alert">
                        ${submissionError}
                    </div>
                ');
            } else {
                null;
            }

        return jsx('
            <div>
                ${submissionErrorElement}
                <div className="py-3">
                    ${pledgeInfo()}
                </div>
                ${form}
            </div>
        ');
    }
}

@await
class _PledgeForm extends ReactComponent {
    var wish_hashid(get, never):String;
    function get_wish_hashid() return props.wish_hashid;

    var wish_currency(get, never):giffon.db.Currency;
    function get_wish_currency() return props.wish_currency;

    var wish_total_needed(get, never):Decimal;
    function get_wish_total_needed() return props.wish_total_needed;

    var user_total_pledge(get, never):Decimal;
    function get_user_total_pledge() return props.user_total_pledge;

    var stripe(get, never):StripeInElements;
    function get_stripe() return props.stripe;

    var submissionError(get, set):react.ReactComponent.ReactElement;
    function get_submissionError() return state.submissionError;
    function set_submissionError(v) {
        setState({submissionError: v});
        return v;
    }

    function new():Void {
        super();
        state = {
            submissionError: null,
        };
    }

    @await function onSubmit(values:PledgeFormValues, props:{
        setSubmitting:Bool->Void,
    }) {
        var values = Reflect.copy(values);
        values.pledge_data = switch (@await stripe.createToken().toPromise())
        {
            case { token: t } if (t != null):
                t;
            case err:
                submissionError = jsx('
                    <Fragment>
                        ${haxe.Json.stringify(err, null, "  ")}
                    </Fragment>
                ');
                props.setSubmitting(false);
                return;
        }

        JQuery.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: Path.join(["/wish", wish_hashid, "pledge"]),
            data: haxe.Json.stringify(values),
        })
            .done(function(data:String){
                submissionError = null;
                document.location.reload(true);
            })
            .fail(function(err){
                trace(err);
                submissionError = jsx('
                    <Fragment>
                        ${err.statusText} (${err.status})
                        <br/>
                        <pre>
                        ${err.responseText}
                        </pre>
                    </Fragment>
                ');
                props.setSubmitting(false);
            });
    }

    override function render() {
        var initialValues:PledgeFormValues = {
            acceptTerms: false,
            pledge_method: StripeCard.getName(),
            pledge_amount:
                if (user_total_pledge > 0)
                    user_total_pledge
                else
                    Math.min(PledgeFormData.pledge_amount_min*2, Std.parseFloat(wish_total_needed)),
            pledge_data: null,
        };

        return jsx('
            <Formik
                initialValues=${initialValues}
                onSubmit=${onSubmit}
                render=${formikRender}
            />
        ');
    }

    function renderErrorMessage(msg:String) {
        return jsx('
            <div className="text-danger">${msg}</div>
        ');
    }

    function formikRender(props:{
        isSubmitting:Bool,
        values:PledgeFormValues,
        errors:Dynamic,
        touched:Dynamic,
        handleBlur:Dynamic,
        handleChange:Dynamic,
        handleSubmit:Dynamic,
    }) {
        var submissionErrorElement =
            if (submissionError != null) {
                jsx('
                    <div className="alert alert-danger" role="alert">
                        ${submissionError}
                    </div>
                ');
            } else {
                null;
            }

        var currencyFlagClass = 'currency-flag currency-flag-${wish_currency.getName().toLowerCase()} align-middle';

        return jsx('
            <Form>
                ${submissionErrorElement}
                <div className="form-row">
                    <div className="form-group col-md-4">
                        <label htmlFor="pledge_amount">
                            Support amount ( <div className=${currencyFlagClass}></div> ${wish_currency.getName()} )
                        </label>
                        <Field
                            className="form-control"
                            name="pledge_amount"
                            id="pledge_amount"
                            type="number"
                            min=${PledgeFormData.pledge_amount_min} max=${Math.min(PledgeFormData.pledge_amount_max, Std.parseFloat(wish_total_needed))} step="0.01"
                            required=${true}
                        />
                    </div>
                    <div className="form-group col-md-8">
                        <label htmlFor="card-number">
                            Credit card
                        </label>
                        <CardElement
                            className="form-control"
                            id="card-number"
                        />
                    </div>
                </div>
                <div className="form-group">
                    <div className="form-check">
                        <Field
                            id="acceptTerms"
                            name="acceptTerms"
                            className="form-check-input" type="checkbox"
                            required=${true}
                        />
                        <label className="form-check-label" htmlFor="acceptTerms">
                            Agree to <a href="/terms" target="_blank">terms and conditions</a>
                        </label>
                        <ErrorMessage name="acceptTerms" render=${renderErrorMessage} />
                    </div>
                </div>
                <button type="submit" className="btn btn-primary" disabled={props.isSubmitting}>
                    Submit
                </button>
            </Form>
        ');
    }
}