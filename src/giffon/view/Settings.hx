package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import haxe.*;
import giffon.R.*;
using StringTools;
using giffon.db.AuthMethod.AuthMethodTools;
using giffon.lang.Settings;

class Settings extends Page {
    override function title() return language.settings() + " - Giffon";
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
                var rx = ~/^user\?id=.+$/; // match only non-custom urls
                if (rx.match(user.user_profile_url)) {
                    "";
                } else {
                    if (user.user_profile_url.startsWith("/")) {
                        user.user_profile_url.substr(1);
                    } else {
                        user.user_profile_url;
                    }
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
            'signin/${name}?redirectTo=${Path.join([base, "settings"]).urlEncode()}';
        else
            'disconnect/${name}';

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
                language.disconnectFrom(authMethod);
        } else {
            language.connectTo(authMethod);
        }

        var text = if (isConnected) {
            switch (authMethod) {
                case Facebook:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles.facebook_profile.displayName})';
                case Twitter:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles.twitter_profile.username})';
                case Google:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles.google_profile.displayName})';
                case GitHub:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles.github_profile.username})';
                case GitLab:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles.gitlab_profile.username})';
                case YouTube:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles.youtube_profile.displayName})';
                case Twitch:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles.twitch_profile.login})';
            }
        } else {
            language.connectTo(authMethod);
        }

        var btn = jsx('
            <div className="row align-items-center mb-2">
                <div className="col col-md-8 col-lg-6">
                    <SignInButton
                        authMethod=${authMethod}
                        logo=${authMethod.logoImage()}
                        href=${href}
                        label=${text}
                        disabled=${isConnected && disallowDisconnect}
                        title=${title}
                    />
                </div>
                <div className="col-auto">
                    <div className="socialToggleVisible" data-authmethod=${authMethod.getName()} data-checked=${Std.string(true)} data-disabled=${Std.string(!isConnected)} />
                </div>
            </div>
        ');

        return btn;
    }

    override function bodyContent() return jsx('
        <div className="container">
            <h1>${language.settings()}</h1>
            <div id="settings-root" className="mb-5"></div>
            
            <h2>${language.socialAccounts()}</h2>
            ${socialButton(Facebook)}
            ${socialButton(Twitter)}
            ${socialButton(Google)}
            ${socialButton(GitHub)}
            ${socialButton(GitLab)}
            ${socialButton(YouTube)}
            ${socialButton(Twitch)}
        </div>
    ');
}