package giffon.browser;

import react.*;
import react.ReactMacro.jsx;
import js.npm.formik.*;
import js.npm.react_datepicker.*;
import js.npm.react_giphy_component.*;
import thx.Decimal;
import js.jquery.*;
import js.Browser.*;
import giffon.R.*;
import giffon.db.WishFormData;
import giffon.db.WishFormData.*;
using Lambda;
using giffon.lang.MakeAWish;

class WishForm extends ReactComponent {
    var wish(get, never):Null<giffon.db.Wish>;
    function get_wish():giffon.db.Wish return props.wish;

    var submissionUrl(get, never):String;
    function get_submissionUrl() return props.submissionUrl;

    var language(get, never):giffon.lang.Language;
    function get_language() return BrowserMain.instance.language;

    function new():Void {
        super(props);
        state = {
            submissionError: null,
        };
    }

    function onSubmit(values:WishFormValues, props:{
        setSubmitting:Bool->Void,
    }) {
        JQuery.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: submissionUrl,
            data: haxe.Json.stringify(values),
        })
            .done(function(data:String, textStatus:String, jqXHR){
                setState({
                    submissionError: null,
                });
                document.location.href = data;
            })
            .fail(function(err){
                trace(err);
                setState({
                    submissionError: jsx('
                        <Fragment>
                            ${err.statusText} (${err.status})
                            <br/>
                            <pre>
                            ${err.responseText}
                            </pre>
                        </Fragment>
                    ')
                });
                props.setSubmitting(false);
            });
    }

    function renderErrorMessage(msg:String) {
        return jsx('
            <div className="text-danger">${msg}</div>
        ');
    }

    function getInitialValue():WishFormValues {
        if (wish == null) {
            return {
                acceptTerms: false,
                items: [{
                    item_id: -1,
                    item_url: "",
                    item_name: "",
                    item_price: 0,
                    item_quantity: 1,
                    item_icon_url: "",
                    item_icon_label: "",
                }],
                wish_additional_cost_description: "",
                wish_additional_cost_amount: 0,
                wish_currency: "",
                wish_title: language.myWish(),
                wish_description: "",
                wish_target_date: null,
                wish_banner_url: null,
            };
        }

        return {
            acceptTerms: true,
            items: [for (item in wish.items) {
                item_id: item.item_id,
                item_url: item.item_url,
                item_name: item.item_name,
                item_price: item.item_price.toFloat(),
                item_quantity: item.item_quantity,
                item_icon_url: "",
                item_icon_label: "",
            }],
            wish_additional_cost_description: switch(wish.wish_additional_cost_description) {
                case null: "";
                case v: v;
            },
            wish_additional_cost_amount: wish.wish_additional_cost_amount.toFloat(),
            wish_currency: wish.wish_currency.getName(),
            wish_title: wish.wish_title,
            wish_description: wish.wish_description,
            wish_target_date: wish.wish_target_date,
            wish_banner_url: wish.wish_banner_url,
        };
    }

    override function render() {
        var initialValues:WishFormValues = getInitialValue();
        function formikRender(props:{
            isSubmitting:Bool,
            values:WishFormValues,
            errors:Dynamic,
            touched:Dynamic,
            handleBlur:Dynamic,
            handleChange:Dynamic,
            handleSubmit:Dynamic,
        }) {
            function fieldArrayRender(arrayHelpers:{
                push:haxe.Constraints.Function,
                remove:haxe.Constraints.Function,
            }) {
                var rows = [
                    for (idx in 0...props.values.items.length){
                        jsx('
                            <div key=${idx} className="wish-item p-3 bg_white d-flex flex-column-reverse flex-md-row">
                                <div className="col p-0">
                                    <Field
                                        name=${'items[$idx].item_id'}
                                        id=${'items[$idx].item_id'}
                                        type="hidden"
                                    />
                                    <div className="form-group">
                                        <label
                                            htmlFor=${'items[$idx].item_name'}
                                        >
                                            ${language.itemName()}
                                        </label>
                                        <div>
                                            <Field
                                                className="form-control"
                                                name=${'items[$idx].item_name'}
                                                id=${'items[$idx].item_name'}
                                                required=${true}
                                                disabled=${wish != null}
                                            />
                                        </div>
                                    </div>
                                    <div className="d-md-flex">
                                        <div className="form-group col-md-6 p-0">
                                            <label
                                                htmlFor=${'items[$idx].item_url'}
                                            >
                                                ${language.itemURL()}
                                            </label>
                                            <div>
                                                <Field
                                                    className="form-control"
                                                    name=${'items[$idx].item_url'}
                                                    id=${'items[$idx].item_url'}
                                                    type="url"
                                                    placeholder="https://..."
                                                    required=${true}
                                                    disabled=${wish != null}
                                                />
                                            </div>
                                        </div>
                                        <div className="form-group col-md-4 p-0">
                                            <label
                                                htmlFor=${'items[$idx].item_price'}
                                            >
                                                ${language.unitPrice()}${props.values.wish_currency == "" ? null : " (" + props.values.wish_currency + ")"}
                                            </label>
                                            <div>
                                                <Field
                                                    className="form-control"
                                                    name=${'items[$idx].item_price'}
                                                    id=${'items[$idx].item_price'}
                                                    type="number"
                                                    min="0.01" max=${WishItemData.item_price_max} step="0.01"
                                                    required=${true}
                                                    disabled=${wish != null}
                                                />
                                            </div>
                                        </div>
                                        <div className="form-group col-md-2 p-0">
                                            <label
                                                htmlFor=${'items[$idx].item_quantity'}
                                            >
                                                ${language.quantity()}
                                            </label>
                                            <div>
                                                <Field
                                                    className="form-control"
                                                    name=${'items[$idx].item_quantity'}
                                                    id=${'items[$idx].item_quantity'}
                                                    type="number"
                                                    min="1" max=${wish == null ? WishItemData.item_quantity_max : wish.items[idx].item_quantity} step="1"
                                                    required=${true}
                                                    disabled=${wish != null}
                                                />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div className="text-right">
                                    <button
                                        type="button"
                                        className="btn btn-sm btn-outline-danger"
                                        title="remove item"
                                        onClick=${function(){ arrayHelpers.remove(idx); }}
                                        disabled=${wish != null || props.values.items.length <= 1}
                                    >
                                    <i className="fas fa-times align-middle"></i>
                                    </button>
                                </div>
                            </div>
                        ');
                    }
                ];
                function sum(nums:Array<Decimal>) {
                    return Lambda.fold(nums, function(a,b) return a+b, Decimal.zero);
                }
                var totalPrice = (sum(props.values.items.map(function(itm) {
                    return Decimal.fromString(Std.string(itm.item_price)) * Decimal.fromString(Std.string(itm.item_quantity));
                })) + Decimal.fromString(Std.string(props.values.wish_additional_cost_amount))).toString();

                var itemsErrorMessage = if (props.errors.items != null && Std.is(props.errors.items, String)) {
                    jsx('<ErrorMessage name="items" render=${renderErrorMessage} />');
                } else {
                    null;
                }

                var totalPriceElement = if (props.values.wish_currency == "")
                    jsx('<p className="my-2">${language.totalPrice()}: ${totalPrice}</p>');
                else
                    jsx('<p className="my-2">${language.totalPrice()} (${props.values.wish_currency}): ${totalPrice}</p>');

                var onlineShops = switch (language) {
                    case English:
                        [
                            { href: "https://www.amazon.com/", name: "Amazon"},
                            { href: "https://www.bestbuy.com/", name: "Best Buy"},
                            { href: "https://store.steampowered.com/", name: "Steam"},
                        ];
                    case Cantonese:
                        [
                            { href: "https://www.amazon.com/", name: "Amazon"},
                            { href: "https://store.steampowered.com/", name: "Steam"},
                            { href: "https://www.hktvmall.com/", name: "HKTVmall"},
                            { href: "https://hk.iherb.com/", name: "iHerb"},
                            { href: "https://hk.pinkoi.com/", name: "Pinkoi"},
                        ];
                    case Chinese:
                        [
                            { href: "https://www.amazon.com/", name: "Amazon"},
                            { href: "https://store.steampowered.com/", name: "Steam"},
                        ];
                };

                var onlineShopTags = onlineShops.map(function(s) return jsx('<Fragment key=${s.href}><a href=${s.href} target="_blank" rel="noopener">${s.name}</a>, </Fragment>'));

                return jsx('
                    <Fragment>
                        <p><small className="form-text text-muted">
                            ${language.itemHelp(onlineShopTags)}
                        </small></p>
                        <div>
                            ${rows}
                        </div>
                        ${itemsErrorMessage}
                        <button
                            type="button"
                            className="btn btn-link"
                            onClick=${function(){ arrayHelpers.push(initialValues.items[0]); }}
                            disabled=${wish != null || props.values.items.length >= WishFormData.items_max}
                        >
                            ${language.addItem()}
                        </button>

                        <div className="form-row align-items-end mt-3">
                            <div className="form-group col-md-8">
                                <label
                                    htmlFor="wish_additional_cost_description"
                                >
                                    ${language.additionalCost()}
                                </label>
                                <div>
                                    <Field
                                        className="form-control"
                                        name="wish_additional_cost_description"
                                        id="wish_additional_cost_description"
                                        placeholder=${language.additionalCostPlaceHolder()}
                                    />
                                </div>
                            </div>
                            <div className="form-group col-md-4">
                                <label
                                    htmlFor="wish_additional_cost_amount"
                                >
                                    ${language.additionalCostAmount()}${props.values.wish_currency == "" ? null : " (" + props.values.wish_currency + ")"}
                                </label>
                                <div>
                                    <Field
                                        className="form-control"
                                        name="wish_additional_cost_amount"
                                        id="wish_additional_cost_amount"
                                        type="number"
                                        min="0.00" max=${WishItemData.item_price_max} step="0.01"
                                        required=${true}
                                    />
                                </div>
                            </div>
                        </div>
                        ${totalPriceElement}
                    </Fragment>
                ');
            }
            var submissionError =
                if (state.submissionError != null) {
                    jsx('
                        <div className="alert alert-danger" role="alert">
                            ${state.submissionError}
                        </div>
                    ');
                } else {
                    null;
                }

            var currencyOptions = [
                for (c in Type.allEnums(giffon.db.Currency))
                jsx('<option key=${c.getName()} value=${c.getName()}>${c.getName()}</option>')
            ];

            function DatePickerField(props:Dynamic) {
                return jsx('
                    <DatePicker
                        className="form-control"
                        selected=${props.form.values[props.field.name]}
                        onChange=${function(v) { props.form.setFieldValue(props.field.name, v); }}
                        dateFormat="yyyy-MM-dd"
                        minDate=${Date.now()}
                        isClearable=${true}
                    />
                ');
            }

            function BannerField(props:Dynamic) {
                function onSelectGif(o:Dynamic) {
                    (untyped new JQuery("#giphyModal").modal)("hide");
                    props.form.setFieldValue(props.field.name, o.original.url);
                }
                var url = Reflect.field(props.form.values, props.field.name);
                // var banner = if (url == null) {
                //     null;
                // } else {
                //     var bannerStyle = {
                //         backgroundImage: 'url("${url}")',
                //     };
                //     jsx('<div className="wish-banner" style=${bannerStyle} />');
                // }
                var bannerStyle;
                if (url == null) {
                    bannerStyle = {
                        backgroundImage: 'url("https://media.giphy.com/media/RKMWXB2EUqeFB4CpKm/giphy.gif")',
                    };
                } else {
                    bannerStyle = {
                        backgroundImage: 'url("${url}")',
                    };
                }
                var removeBtn = if (url == null) {
                    null;
                } else {
                    function removeBanner(){
                        props.form.setFieldValue(props.field.name, null);
                    }
                    jsx('<button type="button" className="btn btn-light ml-2"  onClick=${removeBanner}>${language.removeBanner()}</button>');
                }
                return jsx('
                    <Fragment>
                        <div className="form-demo-banner d-flex align-items-center justify-content-center" style=${bannerStyle}>
                            <button type="button" className="btn btn-light" data-toggle="modal" data-target="#giphyModal">${url == null ? language.selectBanner() : language.replaceBanner()}</button>
                            ${removeBtn}
                        </div>
                        

                        <div className="modal fade" id="giphyModal" tabIndex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                            <div className="modal-dialog modal-dialog-centered" role="document">
                                <div className="modal-content">
                                    <Picker
                                        apiKey="sObo4cqyRkWphOday8LUD8zL3YT1o724"
                                        inputClassName="form-control"
                                        onSelected=${onSelectGif} />
                                    <img className="giphy-attribution" alt="Powered By GIPHY" src=${R("/images/Poweredby_640px-Black_HorizText.png")} />
                                </div>
                            </div>
                        </div>
                    </Fragment>
                ');
            }

            var termsLink = jsx('<a href="terms" target="_blank">${language.termsAndConditions()}</a>');

            return jsx('
                <Form className="wish-form">
                    ${submissionError}
                    <div className="row mb-3">
                        <div className="col-12 col-md-3 form-section-1">
                            <div className="sticky-top">
                                <h1 className="font_xs_m font_md_xxl fontw-700 py-3 py-lg-5 m-0">${language.section1()}</h1>
                            </div>
                        </div>
                        <div className="col-12 col-md-9">
                            <div className="p-sm-3 p-lg-5 border-bottom">
                                <div className="pb-3">
                                    <label>${language.banner()}</label>
                                    <Field
                                        id="wish_banner_url"
                                        name="wish_banner_url"
                                        component=${BannerField}
                                    />
                                </div>    
                                <div className="form-group">
                                    <label htmlFor="wish_title">
                                        ${language.title()}
                                    </label>
                                    <Field
                                        className="form-control" id="wish_title"
                                        name="wish_title"
                                        required=${true}
                                    />
                                    <ErrorMessage name="wish_title" render=${renderErrorMessage} />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="row mb-3">
                        <div className="col-12 col-md-3 form-section-2">
                            <div className="sticky-top">
                                <h1 className="font_xs_m font_md_xxl fontw-700 py-3 py-lg-5 m-0">${language.section2()}</h1>
                            </div>
                        </div>
                        <div className="col-12 col-md-9">
                            <div className="p-sm-3 p-lg-5 border-bottom">
                                <div className="form-group">
                                    <label htmlFor="wish_currency">
                                        ${language.currency()}
                                    </label>
                                    <Field
                                        className="form-control"
                                        component="select"
                                        name="wish_currency"
                                        required=${true}
                                        disabled=${wish != null}
                                    >
                                        <option></option>
                                        ${currencyOptions}
                                    </Field>
                                </div>
                                <div className="form-group">
                                    <FieldArray
                                        name="items"
                                        render=${fieldArrayRender}
                                    />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="row mb-3">
                        <div className="col-12 col-md-3  form-section-3">
                            <div className="sticky-top">
                                <h1 className="font_xs_m font_md_xxl fontw-700 py-3 py-lg-5 m-0">${language.section3()}</h1>
                            </div>
                        </div>
                        <div className="col-12 col-md-9">
                            <div className="p-sm-3 p-lg-5 border-bottom">
                                <div className="form-group">
                                    <label htmlFor="wish_description">
                                        ${language.whyDoYouWantTheAbove()}
                                    </label>
                                    <p><small className="form-text text-muted">
                                        ${language.tellUsStory()}
                                    </small></p>
                                    <Field
                                        component="textarea"
                                        className="form-control" id="wish_description"
                                        name="wish_description"
                                        rows="3"
                                        placeholder=${language.because()}
                                        required=${true}
                                    />
                                </div>
                                <div className="form-group">
                                    <label htmlFor="wish_target_date" className="d-block">
                                        ${language.targetDate()} (${language.optional()})
                                    </label>
                                    <p className="small">
                                        ${language.targetDateNote()}
                                    </p>
                                    <Field
                                        id="wish_target_date"
                                        name="wish_target_date"
                                        component=${DatePickerField}
                                    />
                                    
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="row">
                        <div className="col-12 col-md-3 form-section-4">
                            <div className="sticky-top">
                                <h1 className="font_xs_m font_md_xxl fontw-700 py-3 py-lg-5 m-0">${language.section4()}</h1>
                            </div>
                        </div>
                        <div className="col-12 col-md-9">
                            <div className="p-sm-3 p-lg-5">
                                <div className="">
                                    <p>${language.addressNote()}</p>
                                    <p>${language.couponNote()}</p>
                                </div>
                                <div className="form-group">
                                    <div className="form-check">
                                        <Field
                                            id="acceptTerms"
                                            name="acceptTerms"
                                            className="form-check-input" type="checkbox"
                                            required=${true}
                                            checked=${props.values.acceptTerms}
                                        />
                                        <label className="form-check-label" htmlFor="acceptTerms">
                                            ${language.agreeTo(termsLink)}
                                        </label>
                                        <ErrorMessage name="acceptTerms" render=${renderErrorMessage} />
                                    </div>
                                </div>
                                <button type="submit" className="btn btn-primary col col-md-6" disabled={props.isSubmitting}>
                                    ${language.submit()}
                                </button>
                            </div>
                        </div>
                    </div>
                    
                </Form>
            ');
        }
        return jsx('
            <Formik
                initialValues=${initialValues}
                onSubmit=${onSubmit}
                render=${formikRender}
            />
        ');
    }
}