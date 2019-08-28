package giffon.browser;

import haxe.io.*;
import react.*;
import react.ReactMacro.jsx;
import js.npm.formik.*;
import js.jquery.*;
import js.Browser.*;
import giffon.R.*;
import giffon.db.SettingsFormData;
import giffon.db.SettingsFormData.*;
using Lambda;
using giffon.lang.Settings;

class SettingsForm extends ReactComponent {
    var current_settings(get, never):SettingsFormValues;
    function get_current_settings() return props.current_settings;

    var language(get, never):giffon.lang.Language;
    function get_language() return BrowserMain.instance.language;

    function new():Void {
        super(props);
        state = {
            submissionError: null,
        };
    }

    function onSubmit(values:SettingsFormValues, props:{
        setSubmitting:Bool->Void,
    }) {
        JQuery.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: Path.join([BrowserMain.instance.base, "settings"]),
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

    function FileInputComponent(props:Dynamic) {
        function handleFileChange(event) {
            var file:js.html.File = event.currentTarget.files[0];

            var reader = new js.html.FileReader();
            reader.onload = function(e) {
                var dataUri:String = e.target.result;
                props.form.setFieldValue(props.field.name, dataUri);
            };
            reader.readAsDataURL(file);
        }
        return jsx('
            <input
                className="form-control"
                type="file"
                onChange=${handleFileChange}
            />
        ');
    }

    override function render() {
        var initialValues:SettingsFormValues = current_settings;
        function formikRender(props:{
            isSubmitting:Bool,
            values:SettingsFormValues,
            errors:Dynamic,
            touched:Dynamic,
            handleBlur:Dynamic,
            handleChange:Dynamic,
            handleSubmit:Dynamic,
        }) {
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

            return jsx('
                <Form>
                    ${submissionError}
                    <div className="form-group">
                        <label htmlFor="user_name">
                            ${language.labelName()}
                        </label>
                        <Field
                            className="form-control" id="user_name"
                            name="user_name"
                            maxLength=${SettingsFormData.user_name_max}
                            required=${true}
                        />
                    </div>
                    <div className="form-group">
                        <label htmlFor="user_url">
                            ${language.customProfileUrl()}
                        </label>
                        <div className="d-flex align-items-center">
                            <span className="pr-1">https://giffon.io/</span>
                            <Field
                                className="form-control" id="user_url"
                                name="user_url"
                                minLength=${SettingsFormData.user_url_min}
                                maxLength=${SettingsFormData.user_url_max}
                            />
                        </div>
                        <small className="text-muted">${language.customProfileUrlNote()} ${language.availableCharacters()}: <pre className="d-inline">A-Z a-z 0-9 _</pre></small>
                    </div>
                    <div className="form-group">
                        <label htmlFor="user_primary_email">
                            ${language.email()}
                        </label>
                        <Field
                            className="form-control" id="user_primary_email"
                            name="user_primary_email"
                            type="email"
                            maxLength=${SettingsFormData.user_primary_email_max}
                        />
                        <small className="text-muted">${language.emailNote()}</small>
                    </div>
                    <div className="form-group">
                        <label htmlFor="user_description">
                            ${language.bio()}
                        </label>
                        <Field
                            component="textarea"
                            className="form-control" id="user_description"
                            name="user_description"
                            maxLength=${SettingsFormData.user_description_max}
                            rows="3"
                            placeholder=${language.iAm()}
                        />
                        <small className="text-muted float-right">${props.values.user_description.length} / ${SettingsFormData.user_description_max}</small>
                    </div>
                    <div className="form-group">
                        <label htmlFor="user_avatar">
                            ${language.avatar()}
                        </label>
                        <Field
                            id="user_avatar"
                            name="user_avatar"
                            component=${FileInputComponent}
                        />
                    </div>
                    <button type="submit" className="btn btn-primary" disabled={props.isSubmitting}>
                        ${language.submit()}
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