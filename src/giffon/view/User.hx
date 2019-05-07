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

    override function title() return '${pageUser.user_name} - Giffon';
    override function path() return Path.join(["user", pageUser.user_hashid]);
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-user"]);

    function renderWish(wish:giffon.db.Wish) {
        return jsx('
            <div key=${wish.wish_id} className="col-4 mb-2">
                <div className="card">
                    <div className="card-body">
                        <div className="card-title"><a href=${Path.join(["/wish", wish.wish_hashid])}>${wish.wish_title}</a></div>
                        <div className="card-text wish-description">${wish.wish_description}</div>
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
            case Ended | Succeed | Shipped:
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
                            <a href="/make-a-wish">Make one now</a>.
                        </Fragment>
                    ');
                } else {
                    null;
                };
                jsx('
                    <p>No wishes in progress. ${makeWishHint}</p>
                ');
            case wishes:
                wishesList(wishes);
        }

        return jsx('
            <Fragment>
                <h3>Wishes in Progress</h3>
                ${list}
            </Fragment>
        ');
    }

    function sectionCompleted() {
        var list = switch (wishes.filter(isCompleted)) {
            case []:
                jsx('
                    <p>No completed wishes.</p>
                ');
            case wishes:
                wishesList(wishes);
        }

        return jsx('
            <Fragment>
                <h3>Completed Wishes</h3>
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
                    <p>No cancelled wishes.</p>
                ');
            case wishes:
                wishesList(wishes);
        }

        return jsx('
            <Fragment>
                <h3>Cancelled Wishes</h3>
                <p>Only wish owners can see their list of cancelled wishes.</p>
                ${list}
            </Fragment>
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
            ${sectionInProgress()}
            ${sectionCompleted()}
            ${sectionCancelled()}
        </div>
    ');
}