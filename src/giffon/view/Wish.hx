package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import thx.Decimal;
import js.moment.Moment;
import giffon.server.ServerMain.*;
import giffon.R.*;
import giffon.Utils.*;
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
        if (userIsWishOwner()) {
            cls.push("user-is-wish-owner");
        }
        return cls;
    }

    override function bodyAttributes() {
        var attrs = super.bodyAttributes();
        attrs["data-wish-hashid"] = wish.wish_hashid;
        attrs["data-wish-currency"] = wish.wish_currency.getName();
        attrs["data-wish-total-needed"] = wish.wish_total_needed.amount.toString();
        attrs["data-user-support"] = haxe.Serializer.run(user_support);
        return attrs;
    }

    var wish(get, never):giffon.db.Wish;
    function get_wish():giffon.db.Wish return props.wish;

    var user_support(get, never):giffon.db.Wish.WishSupport;
    function get_user_support() return props.user_support;

    function numSupporters() {
        return jsx('
            <div className="wish-num-supporters col px-1">
                <div className="font_xs_l font_md_xl">${wish.supporters.length}</div>
                ${wish.supporters.length == 1 ? "supporter" : "supporters"}
            </div>
        ');
    }

    function progress() {
        var percentText = ((wish.wish_pledged / wish.wish_total_needed.amount) * 100).floor().toString() + "%";
        return jsx('
            <div className="wish-num-supporters col px-1">
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
                <div className="wish-target-date col px-1" data-toggle="tooltip" title=${"target: " + wish.wish_target_date.format("%Y-%m-%d")}>
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
                <a href=${itm.item_url} target="_blank" rel="noopener">${itm.item_name}</a> (${itm.item_currency.getName()} ${itm.item_price.toString()}) × ${itm.item_quantity}
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
            case Published:
                //pass
            case _:
                return null;
        }

        return jsx('
            <div className="bg6 p-3 px-md-5 pb-md-5 mb-md-5">
                <div className="text-center pb-3">
                    <img className="width_xs_15 mb-2" src=${R("/images/motivation.svg")}/>
                    <div className="font_xs_l font_md_xl">Support the Wish</div>
                </div>
                <div id="pledge-form-root" className="p-3 bg_white font_xs_xs font_md_m"></div>
            </div>
        ');
    }

    function editWishControl() {
        switch (wish.wish_state) {
            case Cancelled | Succeed:
                return null;
            case _:
                //pass
        }

        trace(path());

        return jsx('
            <div className="mb-3 p-3 bg_white shaded-shadow font_xs_xs font_md_s">
                <h4  className="font_xs_l font_md_xxl">Edit Wish</h4>
                <p>You may edit the wish info, but not the items.</p>
                <a className="edit-wish-btn btn btn-primary" href=${Path.join(["/", path(), "edit"])}>Edit Wish</a>
            </div>
        ');
    }

    function cancelWishControl() {
        switch (wish.wish_state) {
            case Cancelled | Succeed:
                return null;
            case _:
                //pass
        }

        return jsx('
            <div className="py-3 px-2 p-md-3 mb-3 mb-md-0 bg_white col ml-sm-3">
                <h4 className="font_xs_m font_md_l">Cancel the Wish ;(</h4>
                <p className="font_xs_xs font_md_s">Once cancelled, all existing pledges will be refunded to the supporters. The action cannot be undone.</p>
                <button className="cancel-wish-btn btn btn-danger rounded-0 w-100">Cancel Wish</button>
            </div>
        ');
    }

    function couponControl() {
        switch (wish.wish_state) {
            case Cancelled | Succeed:
                return null;
            case _:
                //pass
        }

        if (wish.appliedCoupons.length <= 0) {
            return jsx('
                <div className="py-3 px-2 p-md-3 mb-3 mb-md-0 bg_white col">
                    <h4 className="font_xs_m font_md_l">Use a Coupon?</h4>
                    <p className="font_xs_xs font_md_s">Try any coupon codes you can imagine.</p>
                    <form className="input-group font_xs_s font_md_m apply-coupon-form">
                        <input type="text" className="col text-uppercase" name="coupon_code" placeholder="COUPON_CODE" />
                        <button type="submit" className="input-group-append apply-coupon-btn btn btn-primary rounded-0">Apply</button>
                    </form>
                </div>
            ');
        } else {
            var couponList = [
                for (c in wish.appliedCoupons)
                jsx('
                    <span className="badge badge-success coupon_code" key=${c.coupon_id}>${c.coupon_code}</span>
                ')
            ];
            return jsx('
                <div className="py-3 px-2 p-md-3 mb-3 mb-md-0 bg_white col">
                    <h4 className="font_xs_m font_md_l">Applied Coupon</h4>
                    <div className="row mx-0">
                        ${couponList}
                    </div>
                </div>
            ');
        }
    }

    function howToHelpSection() {
        switch (wish.wish_state) {
            case Published:
                //pass
            case _:
                return null;
        }

        if(user!=null) 
            return null;

        return jsx('<div id="how-to-help-root" />');
    }

    function wishSettings() {
        if (user == null || user.user_id != wish.wish_owner.user_id) {
            return null;
        }
        switch (wish.wish_state) {
            case Succeed | Cancelled:
                return jsx('
                    <div className="p-3 px-md-0 pb-md-5 mb-md-5">
                        <h3 className="text-center pb-3 font_xs_l font_md_xxl">Settings</h3>
                        <p>Wish ${wish.wish_state}. No operation is allowed.</p>
                    </div>
                ');
            case _:
                //pass
        }
        
        return jsx('
            <div className=" p-3 px-md-0 pb-md-5 mb-md-5">
                <h3 className="text-center pb-3 font_xs_l font_md_xxl">Settings</h3>
                <div className="d-sm-flex">
                    ${couponControl()}
                    ${editWishControl()}
                    ${cancelWishControl()}
                </div>
            </div>
        ');
    }
    function userIsWishOwner() return user != null && user.user_id == wish.wish_owner.user_id;
    function supportAmountIsVisible(supporter:{
        user:User,
        pledge_date: Date,
        pledge_amount: Decimal,
        pledge_visibility: giffon.db.PledgeVisibility,
    }) {
        return switch (supporter.pledge_visibility) {
            case HiddenFromAll: false;
            case VisibleToAll: true;
            case VisibleToWishOwner: userIsWishOwner();
        }
    }

    function supporterListSection(amountVisible:Bool) {
        var info = if (amountVisible) {
            "Supporters with visible support amounts.";
        } else {
            "
            Supporters with hidden support amounts. 
            Sorted by support amount in descending order.
            ";
        }
        var list = supporterList(amountVisible);
        return list.length <= 0 ? null : jsx('
            <div>
                <p className="text-muted font_xs_xs font_md_s text-center mb-1">
                    ${info}
                </p>
                <div className="bg_white row mx-0 justify-content-center p-3 font_xs_s font_md_m">
                    ${list}
                </div>
            </div>
        ');
    }

    function supporterList(amountVisible:Bool) {
        return [
            for (supporter in wish.supporters)
            if (supportAmountIsVisible(supporter) == amountVisible)
            jsx('
                <div className="col-6 col-md-4 text-center" key=${supporter.user.user_id}>
                    <a href=${supporter.user.user_profile_url} className="py-3">
                        <div className="supporter-avatar rounded-circle shadow mx-auto mb-2" style=${userAvatarStyle(supporter.user)} />
                        <div className="">${supporter.user.user_name}${supportAmount(supporter)}</div>
                    </a>
                </div>
            ')
        ];
    }

    function supportAmount(supporter:giffon.db.Wish.WishSupport) {
        var userIsSupporter = user != null && user.user_id == supporter.user.user_id;
        if (!supportAmountIsVisible(supporter) && !userIsSupporter)
            return null;

        return jsx('<span className="badge badge-pill badge-info font-weight-light ml-2">${"$"}${supporter.pledge_amount.toString()}</span>');
    }

    function wishState() {
        switch (wish.wish_state) {
            case Created | Published:
                var dollar = "$";
                var overPledgeMsg = if (wish.wish_pledged >= wish.wish_total_needed.amount) {
                    jsx('
                        <div className="bg_white p-3 pt-md-4 px-md-5 font_xs_s font_md_m text-justify">
                            <div className="alert alert-info" role="alert">
                                <small>
                                    <p>
                                        The wish still accepts additional pledges until Giffon processed the order, which is usually done a few days after 100% is reached.
                                    </p>
                                    <p className="mb-0">
                                        Over-pledged amount will be refunded to the supporters in proportion to their pledge amounts. 
                                        e.g. If a wish needs ${dollar}120, Luke pledges ${dollar}100 and Leia pledges ${dollar}25, Luke will be refunded ${dollar}4 and Leia will be refunded ${dollar}1.
                                    </p>
                                </small>
                            </div>
                        </div>
                    ');
                } else {
                    null;
                }
                return jsx('
                    <Fragment>
                        <div className="ribbon-wrapper">
                            <div className="ribbon-front">
                                <div className="p-3 px-md-5 d-flex font_xs_xs font_md_s color_white text-center">
                                    ${numSupporters()}
                                    ${progress()}
                                    ${daysToGo()}
                                </div>
                            </div>
                            <div className="ribbon-edge-topleft"></div>
                            <div className="ribbon-edge-bottomright"></div>
                        </div>
                        ${overPledgeMsg}
                    </Fragment>
                ');
            case Succeed:
                return jsx('
                    <Fragment>
                        <div className="ribbon-wrapper">
                            <div className="ribbon-front">
                                <div className="p-3 px-md-5 d-flex font_xs_xs font_md_s color_white text-center">
                                    ${numSupporters()}
                                    ${progress()}
                                </div>
                            </div>
                            <div className="ribbon-edge-topleft"></div>
                            <div className="ribbon-edge-bottomright"></div>
                        </div>
                    </Fragment>
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

    function wishSupporterList() {
        switch (wish.wish_state) {
            case Succeed:
                return jsx('
                    <Fragment>
                        <div className="bg6 p-3 px-md-5 pb-md-5 mb-md-5">
                            <div className="text-center pb-3">
                                 <img className="width_xs_15 mb-2" src=${R("/images/celebration.svg")}/>
                                <h3 className="font_xs_l font_md_xl">Bibbidi Bobbidi Boom!<br/>Wish fulfilled! Great thanks for the following friends!</h3>
                            </div>
                            ${supporterListSection(true)}
                            ${supporterListSection(false)}
                        </div>
                    </Fragment>
                ');    
            case _:
                return null;        
        }
    }

    static public function wishBadge(wish:giffon.db.Wish) {
        switch (wish.wish_state) {
            case Succeed:
                return jsx('<span className="badge badge-success ml-2">succeeded</span>');
            case Created:
                return jsx('<span className="badge badge-secondary ml-2">unpublished</span>');
            case _:
                return null;
        }
    }

    function currencyFlag(currency:giffon.db.Currency) {
        var cls = 'currency-flag currency-flag-${currency.getName().toLowerCase()} align-middle';
        return jsx('<div className=${cls}></div>');
    }

    function bannerStyle() {
        var bannerUrl = if (wish.wish_banner_url != null) {
            wish.wish_banner_url;
        } else {
            //R("/images/bg1.jpg");
            ("https://media.giphy.com/media/RKMWXB2EUqeFB4CpKm/giphy.gif");
        }

        return {
            backgroundImage: 'url("${bannerUrl}")',
        };
    }

    function wishTotalBg() {
        if ((user != null)&&(user.user_id == wish.wish_owner.user_id)) {
            return {
                background: 'none'
            };
        }
        else {
            return {
                background: '#fff700'
            }
        }
    }

    override function bodyContent() return jsx('
        <Fragment>
            <div></div>
            <div className="detail_banner position-relative" style=${bannerStyle()}>
                <div className="wish-owner-avatar position-absolute rounded-circle shadow" style=${userAvatarStyle(wish.wish_owner)} />
            </div>

            <div className="pt-5 pb-3 pb-md-5 text-center">
                <a className="font_xs_l font_md_xl" href=${wish.wish_owner.user_profile_url}>${wish.wish_owner.user_name}</a>
            </div>

            <div className="row justify-content-center">      
                <div className="col-12 col-md-9">
                
                    <div className="bg_white p-3 pt-md-5 px-md-5 pb-md-4 text-center">
                        <span className="font_xs_l font_md_xl">${wish.wish_title}</span>
                        ${wishBadge(wish)}
                        <br/><button className="btn btn-link"><i className="far fa-copy"></i> Share</button>
                    </div>

                    ${wishState()}
                    
                    <div className="bg_white p-3 pt-md-4 px-md-5 font_xs_s font_md_m text-center-justify">${wish.wish_description}</div>

                    <div className="d-flex">
                        <div className="custom-border col">&nbsp;</div>
                        <div className="bg_white px-3 font_xs_s font_md_m">Well, I want...</div>
                        <div className="custom-border col">&nbsp;</div>
                    </div>

                    <div className="bg_white p-3 px-md-5 font_xs_m font_md_l text-center">
                        <ul className="list-group list-group-flush">
                            ${wishItems()}
                        </ul>
                    </div>

                    <div className="pb-4" style=${wishTotalBg()}>
                        <div className="p-2 bg_white shadow text-center font_xs_m font_md_l">
                                Total: <span className="wish-total" data-toggle="tooltip" title=${wish.wish_total_needed.breakdown}>${currencyFlag(wish.wish_currency)} ${wish.wish_currency.getName()} ${wish.wish_total_needed.amount.toString()} <i className="fas fa-info-circle"></i></span>
                        </div>
                    </div>
                    
                    ${wishSupporterList()}
                    ${wishSettings()}
                    ${howToHelpSection()}
                    ${pledgeForm()}
                    

                    

                </div>
            </div>

            <div className="d-none container mb-xs-4 mb-md-5">
                <div className="row my-md-5">
                    <div className="col-12 col-md-6">
                        <div className="p-3 p-md-5 color_white detail_card_left">
                            <div className="d-flex align-items-center">
                                <span className="font_xs_xl">${wish.wish_title}</span>
                                
                            </div>
                            ${wishState()}
                        </div>
                    </div>
                    <div className="col-12 col-md-6">
                        <div id="banner" className="" style=${bannerStyle()}></div>
                    </div>
                </div>
                <div className="bg_white">
                    <div className="row mx-0 border_xs_b">
                        <div className="col-12 col-md-6">
                            <div className="p-3  p-md-5" style=${{display: 'flex', alignItems: 'center'}}>
                                <div className="wish-owner-avatar rounded-circle" style=${userAvatarStyle(wish.wish_owner)} />
                                <div className="pl-3 font_xs_xs font_md_s" style=${{flex: 1}}>
                                    Wish Owner
                                    <h3 className="font_xs_l font_md_xl"><a href=${wish.wish_owner.user_profile_url}>${wish.wish_owner.user_name}</a></h3>
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
                            Total: <span className="wish-total" data-toggle="tooltip" title=${wish.wish_total_needed.breakdown}>${currencyFlag(wish.wish_currency)} ${wish.wish_currency.getName()} ${wish.wish_total_needed.amount.toString()} <i className="fas fa-info-circle"></i></span>
                        </div>
                    </div>
                    ${howToHelpSection()}
                </div>
                ${wishSettings()}
                ${pledgeForm()}
            </div>
        </Fragment>
    ');
}