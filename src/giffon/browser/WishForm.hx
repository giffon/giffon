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

class WishForm extends ReactComponent {
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
            url: "/make-a-wish",
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

    override function render() {
        var initialValues:WishFormValues = {
            acceptTerms: false,
            items: [{
                item_url: "",
                item_name: "",
                item_price: 0,
                item_quantity: 1,
                item_icon_url: "",
                item_icon_label: "",
            }],
            wish_currency: "",
            wish_title: "My wish",
            wish_description: "",
            wish_target_date: null,
            wish_banner_url: null,
        };
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
                            <div key=${idx} className="wish-item form-row align-items-end">
                                <div className="form-group col-md-3">
                                    <label
                                        htmlFor=${'items[$idx].item_name'}
                                    >
                                        Item name
                                    </label>
                                    <div>
                                        <Field
                                            className="form-control"
                                            name=${'items[$idx].item_name'}
                                            id=${'items[$idx].item_name'}
                                            required=${true}
                                        />
                                    </div>
                                </div>
                                <div className="form-group col">
                                    <label
                                        htmlFor=${'items[$idx].item_url'}
                                    >
                                        Item URL
                                    </label>
                                    <div>
                                        <Field
                                            className="form-control"
                                            name=${'items[$idx].item_url'}
                                            id=${'items[$idx].item_url'}
                                            type="url"
                                            placeholder="https://..."
                                            required=${true}
                                        />
                                    </div>
                                </div>
                                <div className="form-group col-md-2">
                                    <label
                                        htmlFor=${'items[$idx].item_price'}
                                    >
                                        Unit Price${props.values.wish_currency == "" ? null : " (" + props.values.wish_currency + ")"}
                                    </label>
                                    <div>
                                        <Field
                                            className="form-control"
                                            name=${'items[$idx].item_price'}
                                            id=${'items[$idx].item_price'}
                                            type="number"
                                            min="0.01" max=${WishItemData.item_price_max} step="0.01"
                                            required=${true}
                                        />
                                    </div>
                                </div>
                                <div className="form-group col col-md-1">
                                    <label
                                        htmlFor=${'items[$idx].item_price'}
                                    >
                                        Quantity
                                    </label>
                                    <div>
                                        <Field
                                            className="form-control"
                                            name=${'items[$idx].item_quantity'}
                                            id=${'items[$idx].item_quantity'}
                                            type="number"
                                            min="1" max=${WishItemData.item_quantity_max} step="1"
                                            required=${true}
                                        />
                                    </div>
                                </div>
                                <div className="form-group col-auto ml-auto">
                                    <button
                                        type="button"
                                        className="btn btn-outline-danger"
                                        title="remove item"
                                        onClick=${function(){ arrayHelpers.remove(idx); }}
                                        disabled=${props.values.items.length <= 1}
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
                var totalPrice = sum(props.values.items.map(function(itm) {
                    return Decimal.fromString(Std.string(itm.item_price)) * Decimal.fromString(Std.string(itm.item_quantity));
                })).toString();

                var itemsErrorMessage = if (props.errors.items != null && Std.is(props.errors.items, String)) {
                    jsx('<ErrorMessage name="items" render=${renderErrorMessage} />');
                } else {
                    null;
                }

                var totalPriceElement = if (props.values.wish_currency == "")
                    jsx('<p className="my-2">Total price: ${totalPrice}</p>');
                else
                    jsx('<p className="my-2">Total price (${props.values.wish_currency}): ${totalPrice}</p>');

                return jsx('
                    <Fragment>
                        <p>What do you want?</p>
                        <p><small className="form-text text-muted">
                            Paste the online shopping link of the item you wanna receive. 
                            For example, any items on <a href="https://www.amazon.com/" target="_blank" rel="noopener">Amazon</a>, <a href="https://www.bestbuy.com/" target="_blank" rel="noopener">Best Buy</a>, <a href="https://store.steampowered.com/" target="_blank" rel="noopener">Steam</a>, <a href="https://www.epicgames.com/store/en-US/" target="_blank" rel="noopener">Epic Games Store</a>, or any online stores.
                        </small></p>
                        ${rows}
                        ${itemsErrorMessage}
                        <button
                            type="button"
                            className="btn btn-link"
                            onClick=${function(){ arrayHelpers.push(initialValues.items[0]); }}
                            disabled=${props.values.items.length >= WishFormData.items_max}
                        >
                            Add item
                        </button>
                        <p><small className="form-text text-muted">
                            Remember to include shipping cost if applicable. 
                            If there is only one item unit in the wish, you may include shipping cost directly in the unit price. 
                            If there are more than one item units, add an additional "shipping" item with the online store homepage URL.
                        </small></p>
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
                var banner = if (url == null) {
                    null;
                } else {
                    var bannerStyle = {
                        backgroundImage: 'url("${url}")',
                    };
                    jsx('<div className="wish-banner" style=${bannerStyle} />');
                }
                var removeBtn = if (url == null) {
                    null;
                } else {
                    function removeBanner(){
                        props.form.setFieldValue(props.field.name, null);
                    }
                    jsx('<button type="button" className="btn btn-link text-secondary" onClick=${removeBanner}>remove</button>');
                }
                return jsx('
                    <Fragment>
                        ${banner}
                        <button type="button" className="btn btn-link" data-toggle="modal" data-target="#giphyModal">${url == null ? "select" : "replace"}</button>
                        ${removeBtn}

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

            return jsx('
                <Form>
                    ${submissionError}
                    <div className="form-group">
                        <label htmlFor="wish_title">
                            Title
                        </label>
                        <Field
                            className="form-control" id="wish_title"
                            name="wish_title"
                            required=${true}
                        />
                        <ErrorMessage name="wish_title" render=${renderErrorMessage} />
                    </div>
                    <div className="form-group">
                        <label htmlFor="wish_currency">
                            Currency
                        </label>
                        <Field
                            className="form-control"
                            component="select"
                            name="wish_currency"
                            required=${true}
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
                    <div className="form-group">
                        <label htmlFor="wish_description">
                            Why do you want the above?
                        </label>
                        <Field
                            component="textarea"
                            className="form-control" id="wish_description"
                            name="wish_description"
                            rows="3"
                            placeholder="Because..."
                            required=${true}
                        />
                    </div>
                    <div className="form-group">
                        <label htmlFor="wish_target_date" className="d-block">
                            Target date (optional)
                        </label>
                        <Field
                            id="wish_target_date"
                            name="wish_target_date"
                            component=${DatePickerField}
                        />
                        <p className="small">
                            This is just a hint for your friends to know. You can always complete the wish early/late.
                        </p>
                    </div>
                    <div className="form-group">
                        <label htmlFor="wish_banner_url" className="d-block">
                            Banner (optional)
                        </label>
                        <Field
                            id="wish_banner_url"
                            name="wish_banner_url"
                            component=${BannerField}
                        />
                    </div>
                    <div className="my-2">
                        <p>We will ask for your shipping address by email once there is enough pledges collected.</p>
                        <p>If you have a coupon, you can apply it after the wish is created.</p>
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
        return jsx('
            <Formik
                initialValues=${initialValues}
                onSubmit=${onSubmit}
                render=${formikRender}
            />
        ');
    }
}