package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import thx.Decimal;
import js.moment.Moment;
import js.npm.gravatar.Gravatar;
using giffon.ResponseTools;

class Wish extends Page {
    override function title() return '${wish.wish_owner.user_name}\'s Wish${wish.wish_title == null? "" : " - " + wish.wish_title} - Giffon';
    override function path() return Path.join(["wish", wish.wish_hashid]);
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-wish"]);

    var wish(get, never):giffon.db.Wish;
    function get_wish():giffon.db.Wish return props.wish;

    var user_total_pledge(get, never):Decimal;
    function get_user_total_pledge() return props.user_total_pledge;

    function daysToGo() {
        if (wish.wish_target_date == null) {
            return null;
        } else {
            var moment = Moment.moment({}).to(wish.wish_target_date, true);
            return jsx('
                <div style=${{flex: 1}}>
                    ${moment}
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
                        <div className="mt-3 d-flex">
                            <div style=${{flex: 1}}>
                                <h4>20</h4>
                                supporters
                            </div>
                            <div style=${{flex: 1}}>
                                <h4>80%</h4>
                                archived
                            </div>
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
                                <div className="wish-owner-avatar rounded-circle" style=${{backgroundImage: 'url("${Gravatar.url(wish.wish_owner.user_primary_email, {s: 200})}")'}} />
                                <div className="pl-3" style=${{flex: 1}}>
                                    Wish Owner
                                    <h3><a href=${"/user/" + wish.wish_owner.user_hashid}>${wish.wish_owner.user_name}</a></h3>
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
                            Total: <span className="wish-total" data-toggle="tooltip" title=${wish.wish_total_needed.breakdown}>${wish.wish_total_needed.amount.toString()} <i className="fas fa-info-circle"></i></span>
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
            </div>
        </Fragment>
    ');
}