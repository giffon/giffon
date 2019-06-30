package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.server.ServerMain.*;

class User extends Page {
    var pageUser(get, never):giffon.db.User;
    function get_pageUser() return props.pageUser;

    var wishes(get, never):Array<giffon.db.Wish>;
    function get_wishes() return props.wishes;

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

    override function title() return '${pageUser.user_name} - Giffon';
    override function path() return pageUser.user_profile_url;
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-user"]);

    function socialProfile(authMethod:giffon.db.AuthMethod) {
        var name = authMethod.getName().toLowerCase();
        var profile = switch (authMethod) {
            case Facebook:
                socialProfiles.facebook_profile;
            case Twitter:
                socialProfiles.twitter_profile;
            case Google:
                socialProfiles.google_profile;
            case GitHub:
                socialProfiles.github_profile;
            case GitLab:
                socialProfiles.gitlab_profile;
            case YouTube:
                socialProfiles.youtube_profile;
            case Twitch:
                socialProfiles.twitch_profile;
        }
        var isConnected = profile != null;

        if (!isConnected)
            return null;

        var href = switch (authMethod) {
            case Facebook | Google: null;
            case Twitter: 'https://twitter.com/${profile.username}';
            case GitHub: 'https://github.com/${profile.username}';
            case GitLab: 'https://gitlab.com/${profile.username}';
            case YouTube: 'https://www.youtube.com/channel/${profile.id}';
            case Twitch: 'https://www.twitch.tv/${profile.login}';
        }

        var classes = ["btn", "btn-link"];
        if (href == null)
            classes.push("disabled");
        
        var iconClasses = ["fab", 'fa-${name}', "text-body"];

        var text = switch (authMethod) {
            case Facebook:
                '${socialProfiles.facebook_profile.displayName}';
            case Twitter:
                '@${socialProfiles.twitter_profile.username}';
            case Google:
                '${socialProfiles.google_profile.displayName}';
            case GitHub:
                '@${socialProfiles.github_profile.username}';
            case GitLab:
                '@${socialProfiles.gitlab_profile.username}';
            case YouTube:
                '${socialProfiles.youtube_profile.displayName}';
            case Twitch:
                '${socialProfiles.twitch_profile.login}';
            case _:
                throw "unknow social network name: " + name;
        }

        return jsx('
            <a className=${classes.join(" ")} href=${href} target="_blank" rel="noopener"><i className=${iconClasses.join(" ")}> ${text}</i></a>
        ');
    }

    function renderWish(wish:giffon.db.Wish) {
        return jsx('
            <div key=${wish.wish_id} className="col-12 col-md-4 mb-2">
                <div className="bg_white shadow p-3 font_xs_xs font_md_s">
                    <div className="">
                        <div className="font_xs_s font_md_m"><a href=${Path.join(["/wish", wish.wish_hashid])}>${wish.wish_title}</a></div>
                        <div className="font_xs_xs font_md_s wish-description">${wish.wish_description}</div>
                    </div>
                </div>
            </div>
        ');
    }

    function wishesList(wishes:Array<giffon.db.Wish>) {
        return jsx('
            <div className="row">
                ${wishes.map(renderWish)}
            </div>
        ');
    }

    function isInProgress(wish:giffon.db.Wish):Bool {
        return switch (wish.wish_state) {
            case Created | Published:
                true;
            case _:
                false;
        }
    }

    function isCompleted(wish:giffon.db.Wish):Bool {
        return switch (wish.wish_state) {
            case Succeed:
                true;
            case _:
                false;
        }
    }

    function isCancelled(wish:giffon.db.Wish):Bool {
        return switch (wish.wish_state) {
            case Cancelled:
                true;
            case _:
                false;
        }
    }

    function sectionInProgress() {
        var list = switch (wishes.filter(isInProgress)) {
            case []:
                var makeWishHint = if (user != null && user.user_id == pageUser.user_id) {
                    jsx('
                        <Fragment>
                            <a className="font_xs_xs font_md_s" href="/make-a-wish">Make one now</a>.
                        </Fragment>
                    ');
                } else {
                    null;
                };
                jsx('
                    <p className="font_xs_xs font_md_s">No wishes in progress. ${makeWishHint}</p>
                ');
            case wishes:
                wishesList(wishes);
        }

        return jsx('
            <Fragment>
                <h3 className="pt-5 font_xs_l font_md_xxl">Wishes in Progress</h3>
                ${list}
            </Fragment>
        ');
    }

    function sectionCompleted() {
        var list = switch (wishes.filter(isCompleted)) {
            case []:
                jsx('
                    <p className="font_xs_xs font_md_s">No completed wishes.</p>
                ');
            case wishes:
                wishesList(wishes);
        }

        return jsx('
            <Fragment>
                <h3 className="pt-5 font_xs_l font_md_xxl">Completed Wishes</h3>
                ${list}
            </Fragment>
        ');
    }

    function sectionCancelled() {
        if (user == null || user.user_id != pageUser.user_id) {
            return null;
        }

        var list = switch (wishes.filter(isCancelled)) {
            case []:
                jsx('
                    <p className="font_xs_xs font_md_s">No cancelled wishes.</p>
                ');
            case wishes:
                wishesList(wishes);
        }

        return jsx('
            <Fragment>
                <h3 className="pt-5 font_xs_l font_md_xxl">Cancelled Wishes</h3>
                <p className="font_xs_xs font_md_s">Only wish owners can see their list of cancelled wishes.</p>
                ${list}
            </Fragment>
        ');
    }

    function sectionDescription() {
        if (pageUser.user_description == null)
            return null;

        return jsx('
            <div className="user-info row justify-content-center">
                <div className="col user-description">
                    ${pageUser.user_description}
                </div>
            </div>
        ');
    }

    override function bodyContent() return jsx('
        <div className="container">
            <div className="user-info row justify-content-center">
                <div className="col-md-4">
                    <div className="user-avatar rounded-circle mx-auto" style=${userAvatarStyle(pageUser)} />
                    <h1 className="user-name text-center">${pageUser.user_name}</h1>
                </div>
            </div>
            <div className="row user-social-accounts">
                <div className="col text-center">
                    ${socialProfile(Facebook)}
                    ${socialProfile(Twitter)}
                    ${socialProfile(Google)}
                    ${socialProfile(GitHub)}
                    ${socialProfile(GitLab)}
                    ${socialProfile(YouTube)}
                    ${socialProfile(Twitch)}
                </div>
            </div>
            ${sectionDescription()}
            ${sectionInProgress()}
            ${sectionCompleted()}
            ${sectionCancelled()}
        </div>
    ');
}