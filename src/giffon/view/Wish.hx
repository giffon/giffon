package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import thx.Decimal;
import js.moment.Moment;
import giffon.server.ServerMain.*;
using DateTools;
using StringTools;
using giffon.db.WishProgress.WishProgressTools;

class Wish extends Page {
    override function title() return '${wish.wish_owner.user_name}\'s Wish${wish.wish_title == null? "" : " - " + wish.wish_title} - Giffon';
    override function path() return Path.join(["wish", wish.wish_hashid]);
    override function render() return super.render();

    override function bodyClasses() {
        var cls = super.bodyClasses();
        cls.push("page-wish");
        if (user != null && user.user_id == wish.wish_owner.user_id) {
            cls.push("user-is-wish-owner");
        }
        return cls;
    }

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
                <div className="font_xs_l font_md_xl">${wish.supporters.length}</div>
                supporters
            </div>
        ');
    }

    function progress() {
        var percentText = ((wish.wish_pledged / wish.wish_total_needed.amount) * 100).floor().toString() + "%";
        return jsx('
            <div className="wish-num-supporters col">
                <div className="font_xs_l font_md_xl">${percentText}</div>
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
                    <div className="font_xs_l font_md_xl">${moment}</div>
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
            return null;
        }

        if (user.user_id == wish.wish_owner.user_id) {
            return null;
        }

        switch (wish.wish_state) {
            case Created | Published:
                //pass
            case _:
                return null;
        }

        return jsx('
            <div id="pledge-form-root" className="my-5 p-3 bg_white shaded-shadow font_xs_xs font_md_m"></div>
        ');
    }

    function cancelWishControl() {
        if (wish.wish_state == Cancelled) {
            return null;
        }

        return jsx('
            <div className="mb-5 p-3 bg_white shaded-shadow font_xs_xs font_md_s">
                <h4  className="font_xs_l font_md_xxl">Cancel Wish</h4>
                <p>Once cancelled, all existing pledges will be refunded to the supporters. The action cannot be undone.</p>
                <button className="cancel-wish-btn btn btn-danger">Cancel Wish</button>
            </div>
        ');
    }

    function wishSettings() {
        if (user == null || user.user_id != wish.wish_owner.user_id) {
            return null;
        }
        switch (wish.wish_state) {
            case Cancelled:
                return jsx('
                    <div className="p-3 bg_white shaded-shadow font_xs_xs font_md_s">
                        <h3 className="font_xs_l font_md_xxl">Settings</h3>
                        <p>Wish cancelled. No operation is allowed.</p>
                    </div>
                ');
            case _:
                //pass
        }
        
        return jsx('
            <div className="my-3">
                <h3 className="font_xs_l font_md_xxl">Settings</h3>
                ${cancelWishControl()}
            </div>
        ');
    }

    function wishState() {
        switch (wish.wish_state) {
            case Created | Published | Ended | Succeed | Shipped:
                return jsx('
                    <div className="mt-3 d-flex font_xs_xs font_md_s row">
                        ${numSupporters()}
                        ${progress()}
                        ${daysToGo()}
                    </div>
                ');
            case Cancelled:
                return jsx('
                    <div className="mt-3 d-flex font_xs_xs font_md_s">
                        <div className="alert alert-secondary">
                            Cancelled, all pledges were refunded to the supporters.
                        </div>
                    </div>
                ');
        }
    }

    override function bodyContent() return jsx('
        <Fragment>
            <div className="container mb-xs-4 mb-md-5">
                <div className="row my-md-5">
                    <div className="col-12 col-md-6">
                        <div className="p-3 p-md-5 color_white detail_card_left">
                            <div className="font_xs_xl">${wish.wish_title}</div>
                            ${wishState()}
                        </div>
                    </div>
                    <div className="col-12 col-md-6">
                        <div id="banner" className="detail_card_right"></div>
                    </div>
                </div>
                <div className="bg_white">
                    <div className="row mx-0 border_xs_b">
                        <div className="col-12 col-md-6">
                            <div className="p-3  p-md-5" style=${{display: 'flex', alignItems: 'center'}}>
                                <div className="wish-owner-avatar rounded-circle" style=${userAvatarStyle(wish.wish_owner)} />
                                <div className="pl-3 font_xs_xs font_md_s" style=${{flex: 1}}>
                                    Wish Owner
                                    <h3 className="font_xs_l font_md_xl"><a href=${Path.join(["/user", wish.wish_owner.user_hashid])}>${wish.wish_owner.user_name}</a></h3>
                                </div>
                            </div>
                        </div>
                        <div className="col-12 col-md-6">
                            <div className="wish-description p-3 p-md-5 font_xs_xs font_md_s">
                                ${wish.wish_description}
                            </div>
                        </div>
                    </div>
                    <div className="row justify-content-center font_xs_xs font_md_s">
                        <div className="col-md-10 my-2">
                            <ul className="list-group list-group-flush">
                                ${wishItems()}
                            </ul>
                        </div>
                    </div>
                    <div className="row justify-content-md-center pb-2">
                        <div className="col text-center">
                            Total: <span className="wish-total" data-toggle="tooltip" title=${wish.wish_total_needed.breakdown}>${wish.items[0].item_currency.getName()} ${wish.wish_total_needed.amount.toString()} <i className="fas fa-info-circle"></i></span>
                        </div>
                    </div>
                    <div id="how-to-help-root" />
                </div>
                ${wishSettings()}
                ${pledgeForm()}
            </div>
        </Fragment>
    ');
}