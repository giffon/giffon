package giffon.browser;

import js.html.FormElement;
import haxe.Json;
import react.*;
import react.ReactMacro.jsx;
import js.npm.formik.*;
import js.npm.react_stripe_elements.*;
import js.npm.material_ui.MaterialUi;
import js.npm.formik_material_ui.FormikMaterialUi;
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
using giffon.lang.Wish;

@:jsRequire("react-paypal-button-v2", "PayPalButton")
extern class PayPalButton extends ReactComponent {}

@:jsRequire("react-block-ui")
extern class BlockUi extends ReactComponent {}

@await
class PledgeForm extends ReactComponent {
    var wish_hashid(get, never):String;
    function get_wish_hashid() return props.wish_hashid;

    var wish_currency(get, never):giffon.db.Currency;
    function get_wish_currency() return props.wish_currency;

    var wish_total_needed(get, never):Decimal;
    function get_wish_total_needed() return props.wish_total_needed;

    var user_support(get, never):Null<giffon.db.Wish.WishSupport>;
    function get_user_support() return props.user_support;

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

    var language(get, never):giffon.lang.Language;
    function get_language() return BrowserMain.instance.language;

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
            url: Path.join([BrowserMain.instance.base, "wish", wish_hashid, "pledge"]),
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
        var visibilityInfo = if (user_support == null) {
            null;
        } else switch (user_support.pledge_visibility) {
            case HiddenFromAll:
                language.pledgeAmountIsHidden();
            case VisibleToWishOwner:
                language.pledgeAmountVisibleToWishOwner();
            case VisibleToAll:
                language.pledgeAmountVisibleToAll();
        }
        if (user_support != null && user_support.pledge_amount > 0) {
            return jsx('
                <div>
                    ${language.youHavePledged()} ${wish_currency.getName()} ${user_support.pledge_amount.toString()}.
                    <button className="btn btn-link btn-cancel-pledge font_xs_s font_md_m" onClick=${cancelPledge} disabled=${isCancellingPledge}>${language.cancelPledge()}</button>
                    <br/>
                    ${visibilityInfo}
                </div>
            ');
        } else {
            return jsx('
                <div className="pb-3">${language.youHaventPledgedYourSupportYet()}</div>
            ');
        }
    }

    override function render() {
        var form = if (user_support != null && user_support.pledge_amount > 0) {
            null;
        } else {
            var injectedPledgeForm = React.createElement(ReactStripeElements.injectStripe(_PledgeForm), {
                wish_hashid: wish_hashid,
                wish_currency: wish_currency,
                wish_total_needed: wish_total_needed,
                user_support: user_support,
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
                <div className="text-center font_xs_s font_md_m">
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

    var user_support(get, never):Null<giffon.db.Wish.WishSupport>;
    function get_user_support() return props.user_support;

    var stripe(get, never):StripeInElements;
    function get_stripe() return props.stripe;

    var submissionError(get, set):react.ReactComponent.ReactElement;
    function get_submissionError() return state.submissionError;
    function set_submissionError(v) {
        setState({submissionError: v});
        return v;
    }

    var language(get, never):giffon.lang.Language;
    function get_language() return BrowserMain.instance.language;

    final formRef:ReactRef<FormElement> = React.createRef();

    function new():Void {
        super();
        state = {
            submissionError: null,
            pledgeMethod: StripeCard,
        };
    }

    @await function onSubmit(values:PledgeFormValues, props:{
        setSubmitting:Bool->Void,
    }) {
        switch (PledgeMethod.createByName(values.pledge_method)) {
            case StripeCard:
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
                    url: Path.join([BrowserMain.instance.base, "wish", wish_hashid, "pledge"]),
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
            case PayPal | Coupon:
                props.setSubmitting(false);
        }
    }

    function validateForm() {
        return formRef.current.checkValidity();
    }

    override function render() {
        var initialValues:PledgeFormValues = {
            acceptTerms: false,
            pledge_method: StripeCard.getName(),
            pledge_amount:
                if (user_support != null && user_support.pledge_amount > 0)
                    user_support.pledge_amount
                else
                    Math.min(Math.max(PledgeFormData.pledge_amount_min, Math.ceil(wish_total_needed * 0.1)), wish_total_needed.toFloat()),
            pledge_data: null,
            pledge_visibility: giffon.db.PledgeVisibility.HiddenFromAll.getName(),
            pledge_name_visibility: giffon.db.PledgeVisibility.VisibleToWishOwner.getName(),
        };

        return jsx('
            <Formik
                initialValues=${initialValues}
                validate=${validateForm}
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
        isValid:Bool,
        values:PledgeFormValues,
        errors:Dynamic,
        touched:Dynamic,
        handleBlur:Dynamic,
        handleChange:Dynamic,
        handleSubmit:Dynamic,
        handleReset:Dynamic,
        validateField:(field:String)->Void,
        validateForm:(?values:Dynamic)->js.lib.Promise<Dynamic>,
        setSubmitting:(isSubmitting:Bool)->Void,
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
        var termsLink = jsx('<a href="terms" target="_blank">${language.termsAndConditions()}</a>');

        var cardClasses = {
            base: "form-control stripe",
            // complete: "",
            // empty: "",
            focus: "form-control stripe--focus",
            // invalid: "",
            // webkitAutofill: "",
        };

        function radio() return jsx('
            <Radio />
        ');

        function stripeFields() return jsx('
            <Fragment>
                <div className="form-row">
                    <div className="form-group col-md-7">
                        <label htmlFor="card-number">
                            ${language.creditCard()}
                        </label>
                        <CardElement
                            className="form-control"
                            id="card-number"
                            classes=${cardClasses}
                        />
                    </div>
                </div>

                <button type="submit" className="btn btn-primary rounded-0" disabled={props.isSubmitting}>
                    ${language.submit()}
                </button>
            </Fragment>
        ');

        function payPalFields() {
            function createOrder(data, actions) {
                props.setSubmitting(true);
                return actions.order.create({
                    purchase_units: [{
                        amount: {
                            currency_code: wish_currency.getName(),
                            value: Std.string(props.values.pledge_amount),
                        },
                        description: 'Supporting wish.',
                    }],
                    application_context: {
                        shipping_preference: "NO_SHIPPING",
                    }
                });
            }
            function onSuccess(details:{
                create_time:String,
                update_time:String,
                id:String,
                intent:String,
                status:String,
                payer: {
                    email_address: String,
                    payer_id: String,
                    address: {
                        country_code:String
                    },
                    name: {
                        given_name: String,
                        surname: String
                    }
                },
                purchase_units: Array<{
                    reference_id:String,
                    amount: {
                        value:String,
                        currency_code:String
                    },
                    payee: {
                        email_address:String,
                        merchant_id:String
                    },
                    shipping:Dynamic,
                    payments: {
                        captures:Array<{
                            status:String,
                            id:String,
                            final_capture: Bool,
                            create_time:String,
                            update_time:String,
                            amount: {
                                value:String,
                                currency_code:String,
                            },
                            seller_protection: {
                                status:String,
                                dispute_categories:Array<String>,
                            },
                            links:Array<{
                                href:String,
                                rel:String,
                                method:String,
                                title:String
                            }>
                        }>,
                    }
                }>,
                links:Array<{
                    href:String,
                    rel:String,
                    method:String,
                    title:String
                }>,
            }, data) {
                trace(Json.stringify(details, null, "  "));

                var values = Reflect.copy(props.values);
                values.pledge_data = details.id;
                JQuery.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: Path.join([BrowserMain.instance.base, "wish", wish_hashid, "pledge"]),
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
                        // props.setSubmitting(false);
                    });
            }

            return jsx('
                <div className="form-row">
                    <div className="form-group col-md-7">
                        <label htmlFor="paypal-button-container">
                            ${language.payPal()}
                        </label>
                        <div onClick=${() -> formRef.current.reportValidity()}>
                            <BlockUi tag="div"
                                blocking=${props.isSubmitting || !formRef.current.checkValidity()}
                                loader="div"
                            >
                                <PayPalButton
                                    amount=${props.values.pledge_amount}
                                    currency=${wish_currency.getName()}
                                    createOrder=${createOrder}
                                    onSuccess=${onSuccess}
                                    onError=${() -> props.setSubmitting(false)}
                                    onCancel=${() -> props.setSubmitting(false)}
                                />
                            </BlockUi>
                        </div>
                    </div>
                </div>
            ');
        }

        return jsx('
            <form ref=${formRef} onSubmit=${props.handleSubmit} onReset=${props.handleReset}>
                ${submissionErrorElement}
                <div className="form-row">
                    <div className="form-group col-md-5">
                        <label htmlFor="pledge_amount">
                            ${language.supportAmount()} ( <div className=${currencyFlagClass}></div> ${wish_currency.getName()} )
                        </label>
                        <Field
                            className="form-control"
                            name="pledge_amount"
                            id="pledge_amount"
                            type="number"
                            min=${PledgeFormData.pledge_amount_min} max=${Math.min(PledgeFormData.pledge_amount_max, wish_total_needed.toFloat())} step="0.01"
                            required=${true}
                        />
                    </div>
                </div>

                <div className="form-group">
                    <div className="mb-1">
                        <p className="mb-0">${language.pledgeNameVisibility()}</p>
                        <small>
                            ${language.pledgeNameVisibilityNote()}
                        </small>
                    </div>
                    <Field
                        name="pledge_name_visibility"
                        component="div"
                    >
                        <div className="form-check">
                            <input
                                id="pledge_name_visibility_hiddenFromAll"
                                name="pledge_name_visibility"
                                className="form-check-input" type="radio" value=${giffon.db.PledgeVisibility.HiddenFromAll.getName()}
                                defaultChecked=${props.values.pledge_name_visibility == giffon.db.PledgeVisibility.HiddenFromAll.getName()}
                            />
                            <label className="form-check-label" htmlFor="pledge_name_visibility_hiddenFromAll">
                                ${language.pledgeNameBeHiddenFromAll()}
                            </label>
                        </div>
                        <div className="form-check">
                            <input
                                id="pledge_name_visibility_visibleToWishOwner"
                                name="pledge_name_visibility"
                                className="form-check-input" type="radio" value=${giffon.db.PledgeVisibility.VisibleToWishOwner.getName()}
                                defaultChecked=${props.values.pledge_name_visibility == giffon.db.PledgeVisibility.VisibleToWishOwner.getName()}
                            />
                            <label className="form-check-label" htmlFor="pledge_name_visibility_visibleToWishOwner">
                                ${language.pledgeNameBeVisibleToWishOwner()}
                            </label>
                        </div>
                        <div className="form-check">
                            <input
                                id="pledge_name_visibility_visibleToAll"
                                name="pledge_name_visibility"
                                className="form-check-input" type="radio" value=${giffon.db.PledgeVisibility.VisibleToAll.getName()}
                                defaultChecked=${props.values.pledge_name_visibility == giffon.db.PledgeVisibility.VisibleToAll.getName()}
                            />
                            <label className="form-check-label" htmlFor="pledge_name_visibility_visibleToAll">
                                ${language.pledgeNameBeVisibleToAll()}
                            </label>
                        </div>
                    </Field>
                </div>
                <div className="form-group">
                    <div className="mb-1">
                        <p className="mb-0">${language.pledgeAmountVisibility()}</p>
                        <small>
                            ${language.pledgeAmountVisibilityNote()}
                        </small>
                    </div>
                    <Field
                        name="pledge_visibility"
                        component="div"
                    >
                        <div className="form-check">
                            <input
                                id="pledge_visibility_hiddenFromAll"
                                name="pledge_visibility"
                                className="form-check-input" type="radio" value=${giffon.db.PledgeVisibility.HiddenFromAll.getName()}
                                defaultChecked=${props.values.pledge_visibility == giffon.db.PledgeVisibility.HiddenFromAll.getName()}
                            />
                            <label className="form-check-label" htmlFor="pledge_visibility_hiddenFromAll">
                                ${language.pledgeAmountBeHiddenFromAll()}
                            </label>
                        </div>
                        <div className="form-check">
                            <input
                                id="pledge_visibility_visibleToWishOwner"
                                name="pledge_visibility"
                                className="form-check-input" type="radio" value=${giffon.db.PledgeVisibility.VisibleToWishOwner.getName()}
                                defaultChecked=${props.values.pledge_visibility == giffon.db.PledgeVisibility.VisibleToWishOwner.getName()}
                            />
                            <label className="form-check-label" htmlFor="pledge_visibility_visibleToWishOwner">
                                ${language.pledgeAmountBeVisibleToWishOwner()}
                            </label>
                        </div>
                        <div className="form-check">
                            <input
                                id="pledge_visibility_visibleToAll"
                                name="pledge_visibility"
                                className="form-check-input" type="radio" value=${giffon.db.PledgeVisibility.VisibleToAll.getName()}
                                defaultChecked=${props.values.pledge_visibility == giffon.db.PledgeVisibility.VisibleToAll.getName()}
                            />
                            <label className="form-check-label" htmlFor="pledge_visibility_visibleToAll">
                                ${language.pledgeAmountBeVisibleToAll()}
                            </label>
                        </div>
                    </Field>
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
                            ${language.agreeTo(termsLink)}
                        </label>
                        <ErrorMessage name="acceptTerms" render=${renderErrorMessage} />
                    </div>
                </div>

                <div className="form-group">
                    <p className="mb-0">${language.pledgeMethod()}</p>

                    <Field name="pledge_method" component=${RadioGroup}>
                        <FormControlLabel
                            label=${language.creditCard()}
                            labelPlacement="end"
                            value=${StripeCard.getName()}
                            control=${radio()}
                        />
                        <FormControlLabel
                            label=${language.payPal()}
                            labelPlacement="end"
                            value=${PayPal.getName()}
                            control=${radio()}
                        />
                    </Field>
                </div>

                ${if (props.values.pledge_method == StripeCard.getName()) stripeFields() else null}
                ${if (props.values.pledge_method == PayPal.getName()) payPalFields() else null}
            </form>
        ');
    }
}