package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.R.*;
import giffon.server.ServerMain.*;
import giffon.db.WishProgress;
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
                <a className="unstyled" href=${"wish/" + wish.wish_hashid}>
                <div className="wish-box bg-dotted-pattern-grey">
                    <div className="wish-banner rounded-10-t" style=${wishBannerStyle(wish)}></div>
                    <div className="position-relative">
                    <div className="image position-absolute wish-owner">
                        <div
                            className="wish-owner-avatar rounded-circle"
                            style=${userAvatarStyle(wish.wish_owner)}
                        ></div>
                    </div>
                    </div>
                    <div>
                        <div className="p-3 text-center">
                            <div className="pt-5 pb-2 wish-owner-name font_xs_m font_md_l">${wish.wish_owner.user_name}</div>
                            <div className="d-flex align-items-center text-left">
                                <h3 className="wish-title text-truncate m-0 font_xs_m font_md_l">${wish.wish_title}</h3>
                                ${Wish.wishBadge(wish, language)}
                            </div>
                            <div className="wish-description text-left font_xs_s">${wish.wish_description}</div>
                        </div>
                    </div>
                    <div className="progress">
                        <div className="progress-bar bg-warning" role="progressbar" aria-valuemin="0" aria-valuemax="100" style=${progressBarStyle(wish.wish_progress)} ></div>
                    </div>
                </div>
                </a>
            </div>
        ');
    }

    function recentWishes() {
        var recentWishes:Array<giffon.db.Wish> = props.recentWishes;
        return recentWishes.shuffle().map(wishBox);
    }

    override function bodyContent() return jsx('
        <Fragment>
            <div className="d-none d-md-block slogan left rl">${language.slogan()}</div>
            <div className="d-none d-md-block slogan right rl">${language.slogan()}</div>

            <div className="d-flex justify-content-between">
                <div className="d-none d-md-block slogan-space">&nbsp;</div>
                <div className="main flex_1 p-3 p-md-0 font_xs_xs font_md_m">
                    <div className="bbanner rounded-10" data-section="intro">
                        <div className="container p-0 d-md-flex">
                        <div className="intro-title p-4 p-lg-5 mb-md-5 bg-dotted-pattern rounded-md-0 rounded-10">
                            <h1 className="intro-title-text font_xs_xl font_md_3xl fontw-700 mb-5 color_white white-space-prewrap">${language.title()}</h1>
                            <a className="btn btn-primary col col-md-auto" href="make-a-wish">${language.makeAWishNow()}</a>
                        </div>
                        </div>
                    </div>

                    <div className="bg_grey_200 rounded-10 text-justify text-md-left mt-3">
                        <div className="bg-letters">
                            <div className="container py-3 py-md-5 d-md-flex">
                                <div className="px-3 pt-4 py-lg-5 col">
                                    <h1 className="font_xs_xl font_md_3xl fontw-700 white-space-prewrap">${language.honestyLyrics()}</h1>
                                </div>
                                <div className="p-3 p-lg-5 col white-space-prewrap"><p>${language.desp()}<b>${language.despBold()}</b></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="bg6 rounded-10 text-justify text-md-left mt-3">
                        <div className="bg-letters-2">
                            <div className="container py-md-5 d-md-flex">
                                <div className="flex_1 p-3">
                                    <h1 className="font_xs_xl font_md_3xl fontw-700 pt-3 pt-md-0">${language.howToStart()}</h1>
                                    <p>${language.howToDesp()}</p>
                                    <a className="d-none d-md-inline btn btn-primary" href="make-a-wish">${language.makeAWishNow()}</a>
                                </div>

                                <div className="flex_1">
                                    <div className="d-flex d-md-block text-md-center mb-3 mb-md-0">
                                        <div className="how-to-icon mx-md-auto">
                                            <img className="w-75" src=${R("/images/draw.svg")} alt="draw"/>
                                        </div>
                                        <div className="col pl-2 m-0">
                                            <h3 className="font_xs_m font_md_xl fontw-700 pt-2">${language.howToStep1Title()}</h3>
                                            <p className="p-md-3">${language.howToStep1()}</p>
                                        </div>
                                    </div>
                                </div>

                                <div className="flex_1">
                                    <div className="d-flex d-md-block text-md-center mb-3 mb-md-0" >
                                        <div className="how-to-icon mx-md-auto">
                                            <img className="w-75" src=${R("/images/a.svg")} alt="advertising"/>
                                        </div>
                                        <div className="col pl-2 m-0">
                                            <h3 className="font_xs_m font_md_xl fontw-700 pt-2">${language.howToStep2Title()}</h3>
                                            <p className="p-md-3">${language.howToStep2()}</p>
                                        </div>
                                    </div>
                                </div>

                                <div className="flex_1">
                                    <div className="d-flex d-md-block text-md-center mb-3 mb-md-0">
                                        <div className="how-to-icon mx-md-auto">
                                            <img className="w-75" src=${R("/images/happiness-black.svg")} alt="cheers"/>
                                        </div>
                                        <div className="col pl-2 m-0">
                                            <h3 className="font_xs_m font_md_xl fontw-700 pt-2">${language.howToStep3Title()}</h3>
                                            <p className="p-md-3">${language.howToStep3()}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div className="d-block d-md-none p-3"><a className="btn btn-primary w-100" href="make-a-wish">${language.makeAWishNow()}</a></div>
                        </div>
                    </div>

                    <div className="mt-3">
                        <div className="container py-md-5 d-md-flex">
                            <div className="flex_1">
                                <div className="p-3 pt-md-0 font_xs_xl font_md_3xl fontw-700">${language.whyGiffon()}</div>
                            </div>

                            <div className="flex_3 p-3">
                                <div className="row font_xs_xs font_md_m">
                                    <div className="col-12 col-sm-6">
                                        <div className="d-flex mb-3">
                                            <div className="notes-to-icon bg-organic-1 mx-md-auto">
                                                <img className="w-75" src=${R("/images/piggy.svg")} alt="piggy bank"/>
                                                </div>
                                                <div className="col pl-2 m-0">
                                                <h3 className="font_xs_m font_md_xl fontw-700 pt-2">${language.note1Title()}</h3>
                                                <p>${language.note1()}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="col-12 col-sm-6">
                                        <div className="d-flex mb-3 mt-sm-5">
                                            <div className="notes-to-icon bg-organic-2 mx-md-auto">
                                                <img className="w-75" src=${R("/images/title.svg")} alt="badge"/>
                                            </div>
                                            <div className="col pl-2 m-0">
                                                <h3 className="font_xs_m font_md_xl fontw-700 pt-2">${language.note2Title()}</h3>
                                                <p>${language.note2()}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="col-12 col-sm-6 ">
                                        <div className="d-flex mb-3 ">
                                            <div className="notes-to-icon bg-organic-1 mx-md-auto">
                                                <img className="w-75" src=${R("/images/smile.svg")} alt="smile"/>
                                            </div>
                                            <div className="col pl-2 m-0">
                                                <h3 className="font_xs_m font_md_xl fontw-700 pt-2">${language.note3Title()}</h3>
                                                <p>${language.note3()}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="col-12 col-sm-6">
                                        <div className="d-flex mb-3 mt-sm-5">
                                            <div className="notes-to-icon bg-organic-2 mx-md-auto">
                                                <img className="w-75" src=${R("/images/charity.svg")} alt="hands holding heart"/>
                                                </div>
                                                <div className="col pl-2 m-0">
                                                <h3 className="font_xs_m font_md_xl fontw-700 pt-2">${language.note4Title()}</h3>
                                                <p>${language.note4()}</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    
                </div>
                <div className="d-none d-md-block slogan-space">&nbsp;</div>
            </div>

            <div className="pb-5 px-3 px-md-5">
                <div className="bg-curve text-center py-5 font_xs_xl font_md_3xl fontw-700">${language.recentWishes()}</div>
                <div className="res-slick row mx-1 recent-wishes">
                    ${recentWishes()}
                </div>
            </div>
        </Fragment>
    ');
}