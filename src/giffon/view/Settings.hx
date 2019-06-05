package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import haxe.*;
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
        facebook_profile:Null<js.npm.passport.Profile>,
        twitter_profile:Null<js.npm.passport.Profile>,
        google_profile:Null<js.npm.passport.Profile>,
        github_profile:Null<js.npm.passport.Profile>,
        gitlab_profile:Null<js.npm.passport.Profile>,
    };
    function get_socialConnections() return props.socialConnections;

    function numSocialConnections() return [for (k in Reflect.fields(socialConnections)) if (Reflect.field(socialConnections, k) != null) 1].length;

    function socialButton(name:String) {
        var isConnected = switch (name) {
            case "facebook":
                socialConnections.facebook_profile != null;
            case "twitter":
                socialConnections.twitter_profile != null;
            case "google":
                socialConnections.google_profile != null;
            case "github":
                socialConnections.github_profile != null;
            case "gitlab":
                socialConnections.gitlab_profile != null;
            case _:
                throw "unknow social network name: " + name;
        }

        var href = if (!isConnected)
            '/signin/${name}?redirectTo=${"/settings".urlEncode()}';
        else
            '/disconnect/${name}';

        var disallowDisconnect = numSocialConnections() <= 1;

        var classes = ["btn", "btn-link"];
        if (isConnected) {
            classes.push("text-muted");

            if (disallowDisconnect)
                classes.push("disabled");
        }

        var title = if (isConnected) {
            if (disallowDisconnect)
                "Cannot disconnect the only connected social account. Otherwise, there would be no way for you to sign in.";
            else
                'Disconnect from ${name}';
        } else {
            'Connect to ${name}';
        }

        var text = if (isConnected) {
            switch (name) {
                case "facebook":
                    'Disconnect (${socialConnections.facebook_profile.displayName})';
                case "twitter":
                    'Disconnect (${socialConnections.twitter_profile.username})';
                case "google":
                    'Disconnect (${socialConnections.google_profile.displayName})';
                case "github":
                    'Disconnect (${socialConnections.github_profile.username})';
                case "gitlab":
                    'Disconnect (${socialConnections.gitlab_profile.username})';
                case _:
                    throw "unknow social network name: " + name;
            }
        } else {
            'Connect';
        }

        return jsx('
            <a className=${classes.join(" ")} href=${href} title=${title}>${text}</a>
        ');
    }

    override function bodyContent() return jsx('
        <div className="container">
            <h1>Settings</h1>
            <div id="settings-root" className="mb-5"></div>
            
            <div className="row mb-5">
                <div className="col">
                    <h2 className="">Social Accounts</h2>

                    <div className="form-group row my-0">
                        <label className="col-4 col-lg-2 col-form-label"><i className="fab fa-facebook"></i> Facebook</label>
                        <div className="col">
                            ${socialButton("facebook")}
                        </div>
                    </div>
                    <div className="form-group row my-0">
                        <label className="col-4 col-lg-2 col-form-label"><i className="fab fa-twitter"></i> Twitter</label>
                        <div className="col">
                            ${socialButton("twitter")}
                        </div>
                    </div>
                    <div className="form-group row my-0">
                        <label className="col-4 col-lg-2 col-form-label"><i className="fab fa-google"></i> Google</label>
                        <div className="col">
                            ${socialButton("google")}
                        </div>
                    </div>
                    <div className="form-group row my-0">
                        <label className="col-4 col-lg-2 col-form-label"><i className="fab fa-github"></i> GitHub</label>
                        <div className="col">
                            ${socialButton("github")}
                        </div>
                    </div>
                    <div className="form-group row my-0">
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