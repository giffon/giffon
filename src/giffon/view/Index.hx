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
                <div className="bg-index" style=${bgStyle(R("/images/bg3.svg"))}>
                    <div id="banner" className="font_xs_xs font_md_m d-flex align-items-center justify-content-end" >
                        <div className="col-12 col-md-6 px-0 py-5">
                            <div className="p-4 p-md-5 m-4 mr-md-0 my-md-5 bg_white text-center text-md-left fade-in">
                                <h1 className="font_xs_xl font_md_3xl fade-in two fontw-700">${language.title()}</h1>

                                <p className="fade-in two">${language.desp()}</p>
                            
                                <a className="btn btn-success rounded-0 w-100 shadow fade-in three mt-3 mt-md-5" href="make-a-wish">
                                    ${language.makeAWishNow()}
                                </a>
                            </div>
                        </div>
                    </div>

                    <div className="text-center py-3 py-md-5 font_xs_xs font_md_m how-it-works">
                        <div className="container">
                            <span className="bg6 d-inline-block mb-5 font_xs_xl font_md_3xl fontw-700">${language.howToStart()}</span>
                        
                            <div className="row">
                                <div className="col-12 col-md-4 rellax" data-rellax-speed="0">
                                    <div className="bg_white how-to">
                                        <div className="position-relative">
                                            <div className="how-to-step">1</div>
                                        </div>
                                        <div className="p-3 pt-5">
                                            <img className="w-25 d-block mx-auto" src=${R("/images/browsing.svg")} alt="browsing"/>
                                            <h3 className="pt-2 font_xs_m font_md_xl fontw-700">${language.howToStep1Title()}</h3>
                                            <p>${language.howToStep1()}</p>
                                        </div>
                                    </div>
                                </div>
                                <div className="col-12 col-md-4 rellax" data-rellax-speed="-0.5">
                                    <div className="bg_white how-to">
                                        <div className="position-relative">
                                            <div className="how-to-step">2</div>
                                        </div>
                                        <div className="p-3 pt-5">
                                            <img className="w-25 d-block mx-auto" src=${R("/images/draw.svg")} alt="draw"/>
                                            <h3 className="pt-2 font_xs_m font_md_xl fontw-700">${language.howToStep2Title()}</h3>
                                            <p>${language.howToStep2()}</p>
                                        </div>
                                    </div>
                                </div>
                                <div className="col-12 col-md-4 rellax" data-rellax-speed="-1">
                                    <div className="bg_white how-to">
                                        <div className="position-relative">
                                            <div className="how-to-step">3</div>
                                        </div>
                                        <div className="p-3 pt-5">
                                            <img className="w-25 d-block mx-auto"  src=${R("/images/speak.svg")} alt="speak" />
                                            <h3 className="pt-2 font_xs_m font_md_xl fontw-700">${language.howToStep3Title()}</h3>
                                            <p>${language.howToStep3()}</p>
                                        </div>
                                    </div>
                                </div>          
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <div className="text-center wish-succeeded halftone">
                <div className="text-center rellax" data-rellax-speed="0.5">
                    <img className="w-25" src=${R("/images/happiness.svg")} />
                </div>
                <p className="w-75 mx-auto font_xs_xl font_md_3xl fontw-700 rellax" data-rellax-speed="2">${language.wishSucceed()}</p>
                
            </div>

            <div className="container">
                <div className="text-center mb-5 font_xs_xl font_md_3xl fontw-700">${language.whyGiffon()}</div>
                <div className="row font_xs_xs font_md_m">
                    <div className="col-12 col-sm-6 col-md-3">
                    <div className="d-flex d-md-block text-md-center align-items-center mb-3">
                        <div className="notes-to-icon bg6 mx-md-auto">
                        <img className="w-75" src=${R("/images/piggy.svg")} alt="piggy bank"/>
                        </div>
                        <div className="col pl-2 m-0">
                        <h3 className="font_xs_m font_md_xl fontw-700 pt-2">${language.note1Title()}</h3>
                    
                        <p>${language.note1()}</p>
                        </div>
                    </div>
                    </div>
                    <div className="col-12 col-sm-6 col-md-3">
                    <div className="d-flex d-md-block text-md-center align-items-center mb-3 mt-sm-5">
                        <div className="notes-to-icon bg6 mx-md-auto">
                        <img className="w-75" src=${R("/images/title.svg")} alt="badge"/>
                        </div>
                        <div className="col pl-2 m-0">
                        <h3 className="font_xs_m font_md_xl fontw-700 pt-2">${language.note2Title()}</h3>
                        <p>${language.note2()}</p>
                        </div>
                    </div>
                    </div>
                    <div className="col-12 col-sm-6 col-md-3">
                    <div className="d-flex d-md-block text-md-center align-items-center mb-3 ">
                        <div className="notes-to-icon bg6 mx-md-auto">
                        <img className="w-75" src=${R("/images/smile.svg")} alt="smile"/>
                        </div>
                        <div className="col pl-2 m-0">
                        <h3 className="font_xs_m font_md_xl fontw-700 pt-2">${language.note3Title()}</h3>
                        <p>${language.note3()}</p>
                        </div>
                    </div>
                    </div>
                    <div className="col-12 col-sm-6 col-md-3">
                    <div className="d-flex d-md-block text-md-center align-items-center mb-3 mt-sm-5">
                        <div className="notes-to-icon bg6 mx-md-auto">
                        <img className="w-75" src=${R("/images/charity.svg")} alt="charity"/>
                        </div>
                        <div className="col pl-2 m-0">
                        <h3 className="font_xs_m font_md_xl fontw-700 pt-2">${language.note4Title()}</h3>
                        <p>${language.note4()}</p>
                        </div>
                    </div>
                    </div>
                </div>
                </div>

            <div className="pb-5">
                <div className="text-center py-5 font_xs_xl font_md_3xl fontw-700">${language.recentWishes()}</div>
                <div className="res-slick row mx-1 recent-wishes">
                    ${recentWishes()}
                </div>
            </div>
            
            
        </Fragment>
    ');
}