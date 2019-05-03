package giffon.browser;

import react.*;
import react.ReactMacro.jsx;
import js.npm.formik.*;
import js.npm.react_datepicker.*;
import thx.Decimal;
import js.jquery.*;
import js.Browser.*;
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
            currency: "",
            wish_title: "My wish",
            wish_description: "",
            wish_target_date: null,
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
                                        Unit Price${props.values.currency == "" ? null : " (" + props.values.currency + ")"}
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

                var totalPriceElement = if (props.values.currency == "")
                    jsx('<p className="my-2">Total price: ${totalPrice}</p>');
                else
                    jsx('<p className="my-2">Total price (${props.values.currency}): ${totalPrice}</p>');

                return jsx('
                    <Fragment>
                        <p>What do you want?</p>
                        <p><small className="form-text text-muted">Paste the online shopping link of the item you wanna receive. Note that we currently only support the Amazon United States store. Support for other stores is in the plan.</small></p>
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
                        <label htmlFor="currency">
                            Currency
                        </label>
                        <Field
                            className="form-control"
                            component="select"
                            name="currency"
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
                    <div className="my-2">
                        We will ask for your shipping address by email once there is enough pledges collected.
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