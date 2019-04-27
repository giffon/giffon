package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.server.ServerMain.*;
import js.npm.gravatar.Gravatar;

class Index extends Page {
    override function title() return "Giffon: A crowd-gifting platform";
    override function description() return "A crowd-gifting platform where you can state what you want and let your friends collectively buy it as a gift for you.";
    override function path() return "";
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-index"]);

    function wishBox(wish:giffon.db.Wish) {
        return jsx('
            <div key=${wish.wish_id} className="col mx-0">
                <div className="wish border_xs">
                    <div className="image border_xs_b">
                        <div
                            className="wish-owner-avatar rounded-circle mx-auto d-block m-2"
                            style=${{backgroundImage: 'url("${Gravatar.url(wish.wish_owner.user_primary_email, {s: 200})}")'}}
                        />
                    </div>
                    <div className="border_xs_b text-truncate">
                        <i className="far fa-gem p-3 border_xs_r" />
                        <span className="px-3">${wish.wish_title}</span>
                    </div>
                    <div className="wish-description p-3 border_xs_b">${wish.wish_description}</div>
                    <a className="btn btn-success rounded-0 w-100" href=${"/wish/" + wish.wish_hashid}>
                        Support!
                    </a>
                </div>
            </div>
        ');
    }

    function recentWishes() {
        var recentWishes:Array<giffon.db.Wish> = props.recentWishes;
        return recentWishes.map(wishBox);
    }

    override function bodyContent() return jsx('
        <Fragment>
            <div id="banner" className="font_xs_s font_md_m">
                <div>
                    <div className="row mx-0 p-4 p-md-5">
                        <div className="col-10 col-md-6 mx-0 mx-md-auto py-3 my-3 py-md-5 my-md-5 color_white">
                            <div className="font_xs_xl font_md_xxl">Your Crowd-gifting Platform</div>
                            <div className="font_xs_s font_md_m">either for who...or yourself</div>
                        </div>
                        <div className="col-12 col-md-3  mx-0 mx-md-auto px-0 py-5">
                            <div className="p-3 p-md-5 bg_white">
                                Buying a gift for a new family / Thinking of a pricy festive retreat... 
                            </div>
                            <a
                                className="btn btn-success rounded-0 w-100"
                                href="/make-a-wish"
                            >
                                Create a campaign
                            </a>
                            <br /><br /><br />
                        </div>
                    </div>
                </div>
            </div>
            <div className="row mx-0">
                <div className="col-xs-12 col-sm-6 col-md-3">
                    <div className="p-5">
                        <p>How it Works</p>
                    </div>
                </div>
                <div className="col-xs-12 col-sm-6 col-md-3">
                    <div className="p-5">
                        <p>Step 1</p>
                        <p>Select items you need</p>
                    </div>
                </div>
                <div className="col-xs-12 col-sm-6 col-md-3">
                    <div className="p-5">
                        <p>Step 2</p>
                        <p>Select type of campaign to start</p>
                    </div>
                </div>
                <div className="col-xs-12 col-sm-6 col-md-3">
                    <div className="p-5">
                        <p>Step 3</p>
                        <p>Share link to your friends</p>
                    </div>
                </div>
            </div>
            <div className="text-center pb-5">
                <a className="btn btn-success" href="/make-a-wish">Start a Campaign</a>
            </div>
            <div className="pb-5">
                <h2 className="text-center pb-3">Recent wishes</h2>
                <div className="res-slick row mx-1 recent-wishes">
                    ${recentWishes()}
                </div>
            </div>
        </Fragment>
    ');
}