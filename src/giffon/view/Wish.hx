package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import thx.Decimal;
import js.moment.Moment;
import js.npm.gravatar.Gravatar;
using DateTools;
using StringTools;
using giffon.db.WishProgress.WishProgressTools;

class Wish extends Page {
    override function title() return '${wish.wish_owner.user_name}\'s Wish${wish.wish_title == null? "" : " - " + wish.wish_title} - Giffon';
    override function path() return Path.join(["wish", wish.wish_hashid]);
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-wish"]);

    override function bodyAttributes() {
        var attrs = super.bodyAttributes();
        attrs["data-wish-hashid"] = wish.wish_hashid;
        attrs["data-wish-total-needed"] = wish.wish_total_needed.amount.toString();
        attrs["data-user-total-pledge"] = user_total_pledge.toString();
        return attrs;
    }

    var wish(get, never):giffon.db.Wish;
    function get_wish():giffon.db.Wish return props.wish;

    var user_total_pledge(get, never):Decimal;
    function get_user_total_pledge() return props.user_total_pledge;

    function numSupporters() {
        return jsx('
            <div className="wish-num-supporters col">
                <h4>${wish.supporters.length}</h4>
                supporters
            </div>
        ');
    }

    function progress() {
        var percentText = switch (wish.wish_progress) {
            case None: "0%";
            case progress: "> " + progress.lowerBound() + "%";
        }
        return jsx('
            <div className="wish-num-supporters col">
                <h4>${percentText}</h4>
                archived
            </div>
        ');
    }

    function daysToGo() {
        if (wish.wish_target_date == null) {
            return null;
        } else {
            var moment = Moment.moment({}).to(wish.wish_target_date, true);
            return jsx('
                <div className="wish-target-date col" data-toggle="tooltip" title=${"target: " + wish.wish_target_date.format("%Y-%m-%d")}>
                    <h4>${moment}</h4>
                    to go
                </div>
            ');
        }
    }

    function wishItems() return [
        for (itm in wish.items)
        jsx('
            <li key=${itm.item_id} className="list-group-item wish-item text-center">
                <a href=${itm.item_url} target="_blank">${itm.item_name}</a> (${itm.item_currency.getName()} ${itm.item_price.toString()}) × ${itm.item_quantity}
            </li>
        ')
    ];

    function pledgeForm() {
        if (user == null) {
            return jsx('
                <div className="py-3">
                    <a href=${"/signin?redirectTo=" + Path.join(["/", path() + "#pledge-form-root"]).urlEncode()}>Sign in</a> and then pledge your support!
                </div>
            ');
        }

        if (user.user_id == wish.wish_owner.user_id) {
            return null;
        }

        return jsx('
            <div id="pledge-form-root"></div>
        ');
    }

    function userAvatarStyle(user:giffon.db.User) {
        if (user.user_avatar == null) {
            return {};
        }

        return {
            backgroundImage: 'url("${user.user_avatar}")',
        }
    }

    override function bodyContent() return jsx('
        <Fragment>
            <div className="position-fixed floating-action-bar">
                <button className="btn btn-secondary btn-lg rounded-circle"><i className="fas fa-share-alt" /></button>
                <br /><br />
                <button className="btn btn-success btn-lg rounded-circle"><i className="fas fa-child" /></button>
            </div>
            <div className="container mb-5">
                <div className="row my-5">
                    <div className="col-12 col-lg-6 p-3 p-lg-5 color_white card_left" style=${{background: '#13547a'}}>
                        <h2>${wish.wish_title}</h2>
                        <div className="mt-3 row">
                            ${numSupporters()}
                            ${progress()}
                            ${daysToGo()}
                        </div>
                    </div>
                    <div id="banner" className="col-12 col-md-6 card_right">
                    </div>
                </div>
                <div className="bg_white">
                    <div className="row mx-0 border_xs_b">
                        <div className="col-12 col-md-6">
                            <div className="p-3  p-md-5" style=${{display: 'flex', alignItems: 'center'}}>
                                <div className="wish-owner-avatar rounded-circle" style=${userAvatarStyle(wish.wish_owner)} />
                                <div className="pl-3" style=${{flex: 1}}>
                                    Wish Owner
                                    <h3>${wish.wish_owner.user_name}</h3>
                                </div>
                            </div>
                        </div>
                        <div className="col-12 col-md-6">
                            <div className="wish-description p-3 p-md-5">
                                ${wish.wish_description}
                            </div>
                        </div>
                    </div>
                    <div className="row justify-content-center">
                        <div className="col-md-10 my-2">
                            <ul className="list-group list-group-flush">
                                ${wishItems()}
                            </ul>
                        </div>
                    </div>
                    <div className="row justify-content-md-center">
                        <div className="col text-center">
                            Total: <span className="wish-total" data-toggle="tooltip" title=${wish.wish_total_needed.breakdown}>${wish.items[0].item_currency.getName()} ${wish.wish_total_needed.amount.toString()} <i className="fas fa-info-circle"></i></span>
                        </div>
                    </div>
                    <div className="row mx-0 border_xs_b">
                        <div className="col-xs-12 col-sm-12 col-md-4">
                            <div className="p-5">
                                <h3>How you can support?</h3>
                            </div>
                        </div>
                        <div className="col-xs-12 col-sm-6 col-md-4">
                            <div className="p-5">
                                <p>Step 1</p>
                                <p>Pledge</p>
                            </div>
                        </div>
                        <div className="col-xs-12 col-sm-6 col-md-4">
                            <div className="p-5">
                                <p>Step 2</p>
                                <p>Share the campaign with your friends</p>
                            </div>
                        </div>
                    </div>
                </div>
                ${pledgeForm()}
            </div>
        </Fragment>
    ');
}