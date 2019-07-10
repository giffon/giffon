package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import haxe.*;
import giffon.R.*;
using StringTools;
using giffon.db.AuthMethod.AuthMethodTools;

class Settings extends Page {
    override function title() return "Settings - Giffon";
    override function path() return "settings";
    override function render() return super.render();

    override function requiredSignin() return true;

    override function depCss() {
        return jsx('
            <Fragment>
                ${super.depCss()}
                <link rel="stylesheet"
                    href="https://fonts.googleapis.com/css?family=Roboto:500"
                />
            </Fragment>
        ');
    }

    override function bodyClasses() return super.bodyClasses().concat(["page-settings"]);

    override function bodyAttributes() {
        var attrs = super.bodyAttributes();
        attrs["data-current-settings"] = haxe.Json.stringify(({
            user_name: user.user_name,
            user_primary_email: user.user_primary_email == null ? "" : user.user_primary_email,
            user_description: user.user_description == null ? "" : user.user_description,
            user_url: {
                var rx = ~/^\/(.+)$/;
                if (rx.match(user.user_profile_url)) {
                    rx.matched(1);
                } else {
                    "";
                }
            },
            user_avatar: null, //TODO
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
        twitch_profile:Null<js.npm.passport.Profile>,
    };
    function get_socialProfiles() return props.socialProfiles;

    function numSocialConnections() return [for (k in Reflect.fields(socialProfiles)) if (Reflect.field(socialProfiles, k) != null) 1].length;

    function socialButton(authMethod:giffon.db.AuthMethod) {
        var name = authMethod.getName().toLowerCase();
        var isConnected = switch (authMethod) {
            case Facebook:
                socialProfiles.facebook_profile != null;
            case Twitter:
                socialProfiles.twitter_profile != null;
            case Google:
                socialProfiles.google_profile != null;
            case GitHub:
                socialProfiles.github_profile != null;
            case GitLab:
                socialProfiles.gitlab_profile != null;
            case YouTube:
                socialProfiles.youtube_profile != null;
            case Twitch:
                socialProfiles.twitch_profile != null;
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
                'Disconnect from ${authMethod.getName()}';
        } else {
            'Connect to ${authMethod.getName()}';
        }

        var text = if (isConnected) {
            switch (authMethod) {
                case Facebook:
                    'Disconnect from ${authMethod.getName()} (${socialProfiles.facebook_profile.displayName})';
                case Twitter:
                    'Disconnect from ${authMethod.getName()} (${socialProfiles.twitter_profile.username})';
                case Google:
                    'Disconnect from ${authMethod.getName()} (${socialProfiles.google_profile.displayName})';
                case GitHub:
                    'Disconnect from ${authMethod.getName()} (${socialProfiles.github_profile.username})';
                case GitLab:
                    'Disconnect from ${authMethod.getName()} (${socialProfiles.gitlab_profile.username})';
                case YouTube:
                    'Disconnect from ${authMethod.getName()} (${socialProfiles.youtube_profile.displayName})';
                case Twitch:
                    'Disconnect from ${authMethod.getName()} (${socialProfiles.twitch_profile.login})';
            }
        } else {
            'Connect to ${authMethod.getName()}';
        }

        var btn = jsx('
            <SignInButton
                authMethod=${authMethod}
                logo=${authMethod.logoImage()}
                href=${href}
                label=${text}
                disabled=${isConnected && disallowDisconnect}
                title=${title}
            />
        ');

        return btn;
    }

    override function bodyContent() return jsx('
        <div className="container">
            <h1>Settings</h1>
            <div id="settings-root" className="mb-5"></div>
            
            <div className="row mb-5">
                <div className="col col-md-8 col-lg-6">
                    <h2>Social Accounts</h2>
                    ${socialButton(Facebook)}
                    ${socialButton(Twitter)}
                    ${socialButton(Google)}
                    ${socialButton(GitHub)}
                    ${socialButton(GitLab)}
                    ${socialButton(YouTube)}
                    ${socialButton(Twitch)}
                </div>
            </div>
        </div>
    ');
}