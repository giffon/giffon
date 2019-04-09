package giffon.browser;

import react.*;
import react.ReactMacro.jsx;
import js.npm.formik.*;
import thx.Decimal;

typedef WishFormValues = {
    acceptTerms:Bool,
    items:Array<{
        item_url:String,
        item_name:String,
        item_price:String,
        item_quantity:Int,
    }>,
    wish_description:String,
}

class WishForm extends ReactComponent {
    override function render() {
        var initialValues:WishFormValues = {
            acceptTerms: false,
            items: [{
                item_url: "",
                item_name: "",
                item_price: "",
                item_quantity: 1,
            }],
            wish_description: ""
        };
        function formikRender(props:{
            isSubmitting:Bool,
            values:WishFormValues,
        }) {
            function fieldArrayRender(arrayHelpers:{
                push:haxe.Constraints.Function,
                remove:haxe.Constraints.Function,
            }) {
                var rows = [
                    for (idx in 0...props.values.items.length){
                        jsx('
                            <div>
                                <Field
                                    name=${'items[$idx].item_name'}
                                    placeholder="Item name"
                                    required=${true}
                                />
                                <Field
                                    name=${'items[$idx].item_url'}
                                    type="url"
                                    placeholder="https://..."
                                    required=${true}
                                />
                                <Field
                                    name=${'items[$idx].item_price'}
                                    type="number"
                                    title="unit price"
                                    min="0" max="10000" step="0.01"
                                    required=${true}
                                />
                                <Field
                                    name=${'items[$idx].item_quantity'}
                                    type="number"
                                    title="quantity"
                                    min="1" max="5" step="1"
                                    required=${true}
                                />
                                <button type="button" className="btn btn-link" title="remove item" onClick=${function(){ arrayHelpers.remove(idx); }}>
                                X
                                </button>
                            </div>
                        ');
                    }
                ];
                function sum(nums:Array<Decimal>) {
                    return Lambda.fold(nums, function(a,b) return a+b, Decimal.zero);
                }
                var totolPrice = sum(props.values.items.map(function(itm) {
                    return Decimal.fromString(Std.string(itm.item_price)) * Decimal.fromString(Std.string(itm.item_quantity));
                })).toString();

                return jsx('
                    <Fragment>
                        <p>What do you want?</p>
                        <p><small className="form-text text-muted">Paste the online shopping link of the item you wanna receive. Note that we currently only support the Amazon United States store. Support for other stores is in the plan.</small></p>
                        ${rows}
                        <button type="button" className="btn btn-link" onClick=${function(){ arrayHelpers.push(initialValues.items[0]); }}>
                            Add item
                        </button>
                        <p>Total price: ${totolPrice}</p>
                    </Fragment>
                ');
            }
            return jsx('
                <Form>
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
                    <div>
                        We will ask for your shipping address by email once there is enough pledges collected.
                    </div>
                    <div className="form-group">
                        <div className="form-check">
                            <Field
                                name="acceptTerms"
                                className="form-check-input" type="checkbox"
                                required=${true}
                            />
                            <label className="form-check-label" htmlFor="checkbox-terms">
                                Agree to <a href="/terms" target="_blank">terms and conditions</a>
                            </label>
                            <div className="invalid-feedback">
                                You must agree before submitting.
                            </div>
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
                render=${formikRender}
            />
        ');
    }
}