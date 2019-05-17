package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.server.ServerMain.*;

class Admin extends Page {
    override function title() return 'Admin - Giffon';
    override function path() return "admin";
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-admin"]);

    override function requiredSignin() return true;

    var completedWishes(get, never):Array<giffon.db.Wish>;
    function get_completedWishes() return props.completedWishes;

    function renderWish(wish:giffon.db.Wish) {
        return jsx('
            <div key=${wish.wish_id} className="col-12 col-md-4 mb-2">
                <div className="bg_white shadow p-3 font_xs_xs font_md_s">
                    <div className="">
                        <div className="font_xs_s font_md_m"><a href=${Path.join(["/wish", wish.wish_hashid])}>${wish.wish_title}</a></div>
                        <div className="font_xs_s font_md_m"><a href=${Path.join(["/user", wish.wish_owner.user_hashid])}>${wish.wish_owner.user_name}</a></div>
                        <div className="font_xs_s font_md_m">${wish.wish_currency.getName()} ${wish.wish_pledged.toString()} / ${wish.wish_total_needed.amount.toString()}</div>
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

    function isCompleted(wish:giffon.db.Wish):Bool {
        return switch (wish.wish_state) {
            case Succeed:
                true;
            case _:
                false;
        }
    }

    function sectionCompleted() {
        var list = switch (completedWishes) {
            case []:
                jsx('
                    <p className="font_xs_xs font_md_s">No completed wishes.</p>
                ');
            case wishes:
                wishesList(wishes);
        }

        return jsx('
            <Fragment>
                <h3 className="font_xs_l font_md_xxl">Completed Wishes</h3>
                ${list}
            </Fragment>
        ');
        return null;
    }

    override function bodyContent() return jsx('
        <div className="container">
            <div>
                <h1>Admin</h1>
            </div>
            ${sectionCompleted()}
        </div>
    ');
}