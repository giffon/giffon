package giffon.view;

import js.npm.passport.Profile;
import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import haxe.*;
import giffon.R.*;
import giffon.db.AuthMethod;
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

    var socialProfiles(get, never):Map<giffon.db.AuthMethod, {
        visible:Bool,
        profile:Profile,
    }>;
    function get_socialProfiles() return props.socialProfiles;

    function numSocialConnections() return [for (k => v in socialProfiles) if (v.profile != null) 1].length;

    function socialButton(authMethod:giffon.db.AuthMethod) {
        var name = authMethod.getName().toLowerCase();
        var isConnected = socialProfiles[authMethod].profile != null;

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
                    '${language.disconnectFrom(authMethod)} (${socialProfiles[Facebook].profile.displayName})';
                case Twitter:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles[Twitter].profile.username})';
                case Google:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles[Google].profile.displayName})';
                case GitHub:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles[GitHub].profile.username})';
                case GitLab:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles[GitLab].profile.username})';
                case YouTube:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles[YouTube].profile.displayName})';
                case Twitch:
                    '${language.disconnectFrom(authMethod)} (${socialProfiles[Twitch].profile.login})';
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
                    <div className="socialToggleVisible"
                        data-authmethod=${authMethod.getName()}
                        data-checked=${Std.string(socialProfiles[authMethod].visible)}
                        data-disabled=${Std.string(!isConnected)}
                    />
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