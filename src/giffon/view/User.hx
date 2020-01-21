package giffon.view;

import js.npm.passport.Profile;
import giffon.db.AuthMethod;
import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.server.ServerMain.*;
import giffon.db.WishProgress;
using giffon.lang.User;

class User extends Page {
    var pageUser(get, never):giffon.db.User;
    function get_pageUser() return props.pageUser;

    var wishes(get, never):Array<giffon.db.Wish>;
    function get_wishes() return props.wishes;

    var socialProfiles(get, never):Map<AuthMethod, {
        visible:Bool,
        profile:Profile,
    }>;
    function get_socialProfiles() return props.socialProfiles;

    override function title() return '${pageUser.user_name} - Giffon';
    override function path() return pageUser.user_profile_url;
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-user"]);

    function socialProfile(authMethod:giffon.db.AuthMethod) {
        if (!socialProfiles[authMethod].visible) {
            return null;
        }

        var name = authMethod.getName().toLowerCase();
        var profile = socialProfiles[authMethod].profile;
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

        var classes = ["btn", "btn-link" , "text-dark"];
        if (href == null)
            classes.push("disabled");
        
        var iconClasses = ["fab", 'fa-${name}', "text-body"];

        var text = switch (authMethod) {
            case Facebook:
                '${profile.displayName}';
            case Twitter:
                '@${profile.username}';
            case Google:
                '${profile.displayName}';
            case GitHub:
                '@${profile.username}';
            case GitLab:
                '@${profile.username}';
            case YouTube:
                '${profile.displayName}';
            case Twitch:
                '${profile.login}';
            case _:
                throw "unknow social network name: " + name;
        }

        return jsx('
            <a className=${classes.join(" ")} href=${href} target="_blank" rel="noopener"><i className=${iconClasses.join(" ")}></i> ${text}</a>
        ');
    }

    function progressBarStyle(status:WishProgress) {
        switch (status) {
            case None:
                return { width: '0' };
            case Started:
                return { width: '10%' };
            case Halfway:
                return { width: '50%' };
            case Almost:
                return { width: '80%' };
            case Done:
                return { width: '100%' };
        }
    }

    function renderWish(wish:giffon.db.Wish) {
        return jsx('
            <div key=${wish.wish_id} className="col-12 col-md-4 mb-3">
                <a className="text-dark" href=${Path.join(["wish", wish.wish_hashid])}>
                <div className="wish-box bg_grey_100">
                    <div className="wish-banner rounded-10-t" style=${Index.wishBannerStyle(wish)}></div>
                    <div className="bg-dotted-pattern-grey p-3">
                        <span className="wish-title text-truncate font_xs_m font_md_l">${wish.wish_title}</span> ${Wish.wishBadge(wish, language)}
                        <div className="font_xs_s wish-description">${wish.wish_description}</div>
                    </div>
                    <div className="progress">
                        <div className="progress-bar bg-warning" role="progressbar" aria-valuemin="0" aria-valuemax="100" style=${progressBarStyle(wish.wish_progress)} ></div>
                    </div>
                </div>
                </a>
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
                            <a href="make-a-wish">${language.makeOneNow()}</a>.
                        </Fragment>
                    ');
                } else {
                    null;
                };
                jsx('
                    <p>${language.noWishesInProgress()}. ${makeWishHint}</p>
                ');
            case wishes:
                wishesList(wishes);
        }

        return jsx('
            <Fragment>
                <h3 className="bg-curve text-center py-3 py-md-5 font_xs_xl font_md_xxl fontw-700">${language.wishesInProgress()}</h3>
                ${list}
            </Fragment>
        ');
    }

    function sectionCompleted() {
        var list = switch (wishes.filter(isCompleted)) {
            case []:
                jsx('
                    <p>${language.noCompletedWishes()}</p>
                ');
            case wishes:
                wishesList(wishes);
        }

        return jsx('
            <Fragment>
                <h3 className="bg-curve text-center py-3 py-md-5 font_xs_xl font_md_xxl fontw-700">${language.completedWishes()}</h3>
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
                    <p>${language.noCancelledWishes()}</p>
                ');
            case wishes:
                wishesList(wishes);
        }

        return jsx('
            <Fragment>
                <h3 className="bg-curve text-center py-3 py-md-5 font_xs_xl font_md_xxl fontw-700">${language.cancelledWishes()}</h3>
                <p>${language.cancelledWishesNote()}</p>
                ${list}
            </Fragment>
        ');
    }

    function sectionDescription() {
        if (pageUser.user_description == null)
            return null;

        return jsx('
            <div className="user-info row justify-content-center py-3">
                <div className="col col-md-6 user-description">
                    ${pageUser.user_description}
                </div>
            </div>
        ');
    }

    override function bodyContent() return jsx('
        <div className="bg-letters">
            <div className="container">
            
                <div className="user-info row justify-content-center">
                    <div className="col-md-4">
                        <div className="user-avatar rounded-circle mx-auto" style=${userAvatarStyle(pageUser)} />
                        <h1 className="user-name text-center font_xs_l font_md_xxl fontw-700">${pageUser.user_name}</h1>
                    </div>
                </div>
                <div className="row user-social-accounts justify-content-center">
                    <div className="col col-md-6 text-center">
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
        </div>
    ');
}