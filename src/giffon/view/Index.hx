package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.R.*;
import giffon.server.ServerMain.*;
import js.npm.gravatar.Gravatar;
using giffon.lang.Index;
using thx.Arrays;

class Index extends Page {
    override function title() return language.htmlTitle();
    override function description() return language.htmlDescription();
    override function path() return "";
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-index"]);

    function userAvatarStyle(user:giffon.db.User) {
        if (user.user_avatar == null) {
            return {};
        }

        return {
            backgroundImage: 'url("${user.user_avatar}")',
        }
    }

    public static function bgStyle(url:String) {
        if (url == null) {
            return {};
        }

        return {
            backgroundImage: 'url("${url}")',
        }
    }

    public static function wishBannerStyle(wish:giffon.db.Wish) {
        if (wish.wish_banner_url == null) {
            return {};
        }

        return {
            backgroundImage: 'url("${wish.wish_banner_url}")',
        }
    }

    function wishBox(wish:giffon.db.Wish) {
        return jsx('
            <div key=${wish.wish_id} className="col mx-0 pb-5">
                <div className="wish-box shadow">
                    <div className="wish-banner" style=${wishBannerStyle(wish)}></div>
                    <div className="position-relative">
                    <div className="image position-absolute wish-owner">
                        <div
                            className="wish-owner-avatar rounded-circle"
                            style=${userAvatarStyle(wish.wish_owner)}
                        ></div>
                    </div>
                    </div>
                    <div className="">
                        <div className="p-3 text-center">
                            <div className="pt-5 pb-2 wish-owner-name font_xs_m font_md_l"><a href=${wish.wish_owner.user_profile_url}>${wish.wish_owner.user_name}</a></div>
                            <div className="d-flex align-items-center text-left">
                                <span className="wish-title text-truncate font_xs_m font_md_l">${wish.wish_title}</span>
                                ${Wish.wishBadge(wish, language)}
                            </div>
                            <div className="wish-description text-left font_xs_s">${wish.wish_description}</div>
                        </div>
                        <a className="btn btn-success rounded-0 w-100" href=${"wish/" + wish.wish_hashid}>
                            ${language.support()}
                        </a>
                    </div>
                </div>
            </div>
        ');
    }

    function recentWishes() {
        var recentWishes:Array<giffon.db.Wish> = props.recentWishes;
        return recentWishes.shuffle().map(wishBox);
    }

    override function bodyContent() return jsx('
        <Fragment>
            <div className="bg-yellow-dot">
                <div id="banner" className="bg-index font_xs_xs font_md_m d-flex align-items-center justify-content-end" style=${bgStyle(R("/images/bg3.svg"))} >
                    <div className="col-12 col-md-6 px-0 py-5">
                        <div className="p-4 p-md-5 m-4 mr-md-0 my-md-5 bg_white text-center text-md-left">
                            <h1 className="font_xs_xl font_md_3xl fade-in fontw-700">${language.title()}</h1>

                            <p className="fade-in">${language.desp()}</p>
                        
                            <div className="d-flex my-3 fade-in two">
                                <div className="custom-border col"></div>
                                <div className="px-3 font_xs_l font_md_xl font_lg_xxl fontw-700 color_yellow">${language.howToStart()}</div>
                                <div className="custom-border col"></div>
                            </div>

                            <div className="d-md-flex align-items-center fade-in two">
                                <div className="col">
                                    <span className="font_xs_l font_md_xl font_lg_xxl fontw-700">${language.you()}</span> ${language.usageStep1()}
                                </div>
                                <div className="p-0 p-md-2 text-center font_xs_xl font_md_xxl fontw-700">+</div>
                                <div className="col">
                                    <span className="font_xs_l font_md_xl font_lg_xxl fontw-700">${language.giffon()}</span> ${language.usageStep2()}
                                </div>
                            </div>
                            <a className="btn btn-success rounded-0 w-100 shadow fade-in three mt-3 mt-md-5" href="make-a-wish">
                                ${language.makeAWishNow()}
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div className="pb-5">
                <div className="text-center pt-5 py-md-5 font_xs_l font_md_xl">${language.recentWishes()}</div>
                <div className="res-slick row mx-1 recent-wishes">
                    ${recentWishes()}
                </div>
            </div>
            
            <div className="container-fluid">
                <div className="text-center pt-5 font_xs_l font_md_xl">
                    ${language.whyWish()}
                </div>

                <div id="set2" className="row my-4 my-md-5 text-center from_right">
                    <div className="col-sm-12 col-md-2 ml-md-auto mr-md-3 bg-yellow-dot shaded-shadow p-3 flex_container_v_xs d-md-flex">
                    <div className="vbox">
                        <div className="font_xs_m font_md_l">${language.forWishMakers()}</div>
                    </div>
                    </div>
                
                    <div className="col-xs-auto col-sm-6 col-md-2 p-0 mr-3 mr-sm-auto mr-md-3 bg_white_o80 corner_s shaded-shadow">
                    <div className="px-3 pt-3 px-md-2 py-md-4 font_xs_xs font_md_s">
                        <img className="width_xs_30 width_md_60" src=${R("/images/smile.svg")} alt="smile" />
                        
                        <div className="py-3">
                        <span className="d-inline-block px-2 py-1 corner_xs bg6">#awesome</span>
                        </div>
                        <p>${language.getExactGift()}</p>
                        
                    </div>
                    </div>
                
                    <div className="col-xs-auto col-sm-6 col-md-2 p-0 mr-3 mr-sm-auto mr-md-3 bg_white_o80 corner_s shaded-shadow">
                    <div className="px-3 pt-3 px-md-2 py-md-4 font_xs_xs font_md_s">
                        <img className="width_xs_30 width_md_60" src=${R("/images/speaker.svg")} alt="speaker" />
                        <div className="py-3">
                        <span className="d-inline-block px-2 py-1 corner_xs bg6">#speakUp</span>
                        </div>
                        <p>${language.peopleWantToGift()}</p>
                        
                    </div>
                    </div>
                
                    <div className="col-xs-auto col-sm-6 col-md-2 p-0 mr-3 mr-sm-auto mr-md-3 bg_white_o80 corner_s shaded-shadow">
                    <div className="colr_black px-3 py-4 px-md-2 py-md-4  font_xs_xs font_md_s">
                        <img className="width_xs_30 width_md_60"  src=${R("/images/plant.svg")} alt="plant" />
                        <div className="py-3">
                        <span className="d-inline-block px-2 py-1 bg6 corner_xs">#ecoFriendly</span>
                        </div>
                        <p>${language.noUselessGift()}</p>
                        
                    </div>
                    </div>
                
                    <div className="col-xs-auto col-sm-6 col-md-2 p-0 mr-3 mr-sm-auto mr-md-3 bg_white_o80 corner_s shaded-shadow">
                    <div className=" px-3 py-4 px-md-2 py-md-4 font_xs_xs font_md_s">
                        <img className="width_xs_30 width_md_60" src=${R("/images/piggy.svg")} alt="piggy bank" />
                        <div className="py-3">
                        <span className="d-inline-block px-2 py-1 bg6 corner_xs">#saveMoney</span>
                        </div>
                        <p>${language.getWantYouWantForFree()}</p>
                        
                    </div>
                    </div>
                
                    
                </div>

                <div className="text-center pt-5 font_xs_l font_md_xl">
                    ${language.whySupportFriendsOnGiffon()}
                </div>

                <div id="support" className="row my-4 my-md-5 text-center from_left">

                    <div className="col-sm-12 col-md-2 mr-md-auto ml-3 ml-sm-0 ml-md-3 bg-yellow-dot shaded-shadow p-3 d-xs-flex d-md-none">
                        <div className="vbox">
                            <div className="font_xs_m font_md_l">${language.forSupporters()}</div>
                        </div>
                    </div>


                    <div className="col-xs-auto col-sm-6 col-md-2 p-0 ml-3 ml-sm-auto ml-md-3 bg_white corner_s shaded-shadow">
                    <div className=" px-3 py-4 px-md-2 py-md-4 font_xs_xs font_md_s">
                        <img className="width_xs_30 width_md_60" src=${R("/images/charity.svg")} alt="charity" />
                        <div className="py-3">
                        <span className="d-inline-block px-2 py-1 bg6 corner_xs">#sincerity</span>
                        </div>
                        <p>${language.showAppreciation()}</p>
                        
                    </div>
                    </div>
            
                    <div className="col-xs-auto col-sm-6 col-md-2 p-0 ml-3 ml-sm-auto ml-md-3 bg_white corner_s shaded-shadow">
                    <div className=" px-3 py-4 px-md-2 py-md-4 font_xs_xs font_md_s">
                        <img className="width_xs_30 width_md_60" src=${R("/images/motivation.svg")} alt="certain" />
                        <div className="py-3">
                        <span className="d-inline-block px-2 py-1 bg6 corner_xs" >#certain</span>
                        </div>
                        <p>${language.moneySpentForMakingReceiverHappy()}</p>
                        
                    </div>
                    </div>
            
                    <div className="col-xs-auto col-sm-6 col-md-2 p-0 ml-3 ml-sm-auto ml-md-3 bg_white corner_s shaded-shadow">
                    <div className=" px-3 py-4 px-md-2 py-md-4  font_xs_xs font_md_s">
                        <img className="width_xs_30 width_md_60" src=${R("/images/coins.svg")} alt="coins" />
                        <div className="py-3">
                        <span className="d-inline-block px-2 py-1 bg6 corner_xs">#affordable</span>
                        </div>
                        <p>${language.aGoodGiftIsNeverTooExpensive()}</p>
                        
                    </div>
                    </div>
            
                    <div className="col-xs-auto col-sm-6 col-md-2 p-0 ml-3 ml-sm-auto ml-md-3 bg_white corner_s shaded-shadow">
                    <div className=" px-3 py-4 px-md-2 py-md-4 font_xs_xs font_md_s">
                        <img className="width_xs_30 width_md_60" src=${R("/images/title.svg")} alt="trusty" />
                        <div className="py-3">
                        <span className="d-inline-block px-2 py-1 bg6 corner_xs">#trusty</span>
                        </div>
                        <p>${language.giftInsteadOfMoney()}</p>
                        
                    </div>  
                    </div>

                    <div className="col-sm-12 col-md-2 mr-md-auto ml-3 ml-sm-0 ml-md-3 bg-yellow-dot shaded-shadow p-3 d-none d-md-flex flex_container_v_xs">
                        <div className="vbox">
                            <div  className="font_xs_m font_md_l">${language.forSupporters()}</div>
                        </div>
                    </div>
                </div>
            </div>
        </Fragment>
    ');
}