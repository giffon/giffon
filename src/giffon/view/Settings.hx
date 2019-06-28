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
            user_url: {
                var rx = ~/\/user\/(.+)/;
                if (rx.match(user.user_profile_url)) {
                    rx.matched(1);
                } else {
                    "";
                }
            },
        }:giffon.db.SettingsFormData.SettingsFormValues));
        return attrs;
    }

    var socialProfiles(get, never):{
        facebook_profile:Null<js.npm.passport.Profile>,
        twitter_profile:Null<js.npm.passport.Profile>,
        google_profile:Null<js.npm.passport.Profile>,
        github_profile:Null<js.npm.passport.Profile>,
        gitlab_profile:Null<js.npm.passport.Profile>,
        youtube_profile:Null<js.npm.passport.Profile>,
    };
    function get_socialProfiles() return props.socialProfiles;

    function numSocialConnections() return [for (k in Reflect.fields(socialProfiles)) if (Reflect.field(socialProfiles, k) != null) 1].length;

    function socialButton(name:String) {
        var isConnected = switch (name) {
            case "facebook":
                socialProfiles.facebook_profile != null;
            case "twitter":
                socialProfiles.twitter_profile != null;
            case "google":
                socialProfiles.google_profile != null;
            case "github":
                socialProfiles.github_profile != null;
            case "gitlab":
                socialProfiles.gitlab_profile != null;
            case "youtube":
                socialProfiles.youtube_profile != null;
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
                    'Disconnect (${socialProfiles.facebook_profile.displayName})';
                case "twitter":
                    'Disconnect (${socialProfiles.twitter_profile.username})';
                case "google":
                    'Disconnect (${socialProfiles.google_profile.displayName})';
                case "github":
                    'Disconnect (${socialProfiles.github_profile.username})';
                case "gitlab":
                    'Disconnect (${socialProfiles.gitlab_profile.username})';
                case "youtube":
                    'Disconnect (${socialProfiles.youtube_profile.displayName})';
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
                    <div className="form-group row my-0">
                        <label className="col-4 col-lg-2 col-form-label"><i className="fab fa-youtube"></i> YouTube</label>
                        <div className="col">
                            ${socialButton("youtube")}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    ');
}