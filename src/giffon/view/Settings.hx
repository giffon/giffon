package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
using StringTools;

class Settings extends Page {
    override function title() return "Settings - Giffon";
    override function path() return "settings";
    override function render() return super.render();

    override function requiredSignin() return true;

    override function bodyClasses() return super.bodyClasses().concat(["page-settings"]);

    override function bodyAttributes() {
        var attrs = super.bodyAttributes();
        attrs["data-current-settings"] = haxe.Json.stringify(({
            user_name: user.user_name,
            user_primary_email: user.user_primary_email == null ? "" : user.user_primary_email,
            user_description: user.user_description == null ? "" : user.user_description,
        }:giffon.db.SettingsFormData.SettingsFormValues));
        return attrs;
    }

    var socialConnections(get, never):{
        facebook_id:Null<String>,
        twitter_id:Null<String>,
        google_id:Null<String>,
        github_id:Null<String>,
        gitlab_id:Null<String>,
    };
    function get_socialConnections() return props.socialConnections;

    function socialButton(name:String) {
        var isConnected = switch (name) {
            case "facebook":
                socialConnections.facebook_id != null;
            case "twitter":
                socialConnections.twitter_id != null;
            case "google":
                socialConnections.google_id != null;
            case "github":
                socialConnections.github_id != null;
            case "gitlab":
                socialConnections.gitlab_id != null;
            case _:
                throw "unknow social network name: " + name;
        }

        var href = '/signin/${name}?redirectTo=${"/settings".urlEncode()}';

        return jsx('
            <a className="d-inline-block py-1" href=${href}>${isConnected ? "Disconnect": "Connect"}</a>
        ');
    }

    override function bodyContent() return jsx('
        <div className="container">
            <h1>Settings</h1>
            <div id="settings-root" className="mb-5"></div>
            
            <div className="row mb-5">
                <div className="col">
                    <h2 className="">Social Accounts</h2>

                    <div className="form-group row">
                        <label className="col-4 col-lg-2 col-form-label"><i className="fab fa-facebook"></i> Facebook</label>
                        <div className="col">
                            ${socialButton("facebook")}
                        </div>
                    </div>
                    <div className="form-group row">
                        <label className="col-4 col-lg-2 col-form-label"><i className="fab fa-twitter"></i> Twitter</label>
                        <div className="col">
                            ${socialButton("twitter")}
                        </div>
                    </div>
                    <div className="form-group row">
                        <label className="col-4 col-lg-2 col-form-label"><i className="fab fa-google"></i> Google</label>
                        <div className="col">
                            ${socialButton("google")}
                        </div>
                    </div>
                    <div className="form-group row">
                        <label className="col-4 col-lg-2 col-form-label"><i className="fab fa-github"></i> GitHub</label>
                        <div className="col">
                            ${socialButton("github")}
                        </div>
                    </div>
                    <div className="form-group row">
                        <label className="col-4 col-lg-2 col-form-label"><i className="fab fa-gitlab"></i> GitLab</label>
                        <div className="col">
                            ${socialButton("gitlab")}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    ');
}