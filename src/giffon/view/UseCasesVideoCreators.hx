package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.R.*;
using giffon.lang.UseCasesVideoCreators;

class UseCasesVideoCreators extends Page {
    override function title() return language.titleTag() + ' - Giffon';
    override function path() return "use-cases/video-creators";
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-use-cases", "page-use-cases-video-creators"]);

    override function useEmoji() return true;

    function bgStyle(bg:String) {
        return {
            backgroundImage: 'url("${bg}")',
        };
    }

    override function bodyContent() return jsx('
        <Fragment>
            <div className="d-flex justify-content-between">
                <div className="d-none d-md-block slogan-space">&nbsp;</div>
                <div className="main flex_1 p-3 p-md-0 font_xs_xs font_md_m">
                    <div className="bbanner rounded-10" data-section="video">
                        <div className="container p-0 d-md-flex">
                            <div className="intro-title p-4 p-lg-5 mb-md-5 bg-dotted-pattern color_white rounded-md-0 rounded-10">
                                <h1 className="intro-title-text font_xs_xl font_md_3xl fontw-700 mb-5 color_white white-space-prewrap">${language.titleHeader()}</h1>
                                <p>${language.introText()}</p>
                                <a className="btn btn-primary col col-md-auto" href="make-a-wish">${language.makeAWishNow()}</a>
                            </div>
                        </div>
                    </div>
                    <div className="bg-curve-2 rounded-10 mt-3 py-3 py-md-5">
                    <div className="container">
                        <h1 className="py-3 py-md-5 font_xs_xl font_md_3xl fontw-700">${language.howDoesGiffonCompareToOtherServices()}</h1>

                        <div className="row">
                            <div className="col-12 col-md-6 col-lg-4 mb-4">
                                <div className="bg_green_600 rounded-10">
                                    <div className="pt-3 px-3 text-center">
                                        <img className="logo" src=${R("/images/logo.svg")} alt="Giffon logo" />
                                        <p className="py-2 color_white font_xs_m font_md_xl fontw-700">Giffon</p>
                                    </div>
                                    <div className="card-body">
                                        <ul className="list-group">
                                            <li className="list-group-item">
                                                <p>${language.creatorsReceiveGifts()} <i className="fas fa-check text-success"></i></p>
                                                <p className="text-muted mb-0">
                                                    ${language.creatorsReceiveGiftsDescription()}
                                                </p>
                                            </li>
                                            <li className="list-group-item">
                                                <p>${language.serviceFeeAmount()} <i className="fas fa-check text-success"></i></p>
                                                <p className="text-muted mb-0">
                                                    ${language.serviceFeeAmountDescription()}
                                                </p>
                                            </li>
                                            <li className="list-group-item">
                                                <p>${language.noRewardsRequired()} <i className="fas fa-check text-success"></i></p>
                                                <p className="text-muted mb-0">
                                                    ${language.noRewardsRequiredDescription()}
                                                </p>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div className="col-12 col-md-6 col-lg-4 mb-4">
                                <div className="bg_white rounded-10">
                                    <div className="pt-3 px-3 text-center">
                                        <img className="logo" src=${R("/images/Patreon_Mark_Primary.png")} alt="Patreon logo" />
                                        <p className="py-2 font_xs_m font_md_xl fontw-700">Patreon</p>
                                    </div>
                                    <div className="card-body">
                                        <ul className="list-group">
                                            <li className="list-group-item">
                                                <p>${language.creatorsReceiveMoney()}</p>
                                                <p className="text-muted mb-0">
                                                    ${language.creatorsReceiveMoneyDescription()}
                                                </p>
                                            </li>
                                            <li className="list-group-item">
                                                <p>${language.patreonFees()}</p>
                                                <p className="text-muted mb-0">
                                                    ${language.patreonFeesDescription()}
                                                </p>
                                            </li>
                                            <li className="list-group-item">
                                                <p>${language.patronRewardsRecommended()}</p>
                                                <p className="text-muted mb-0">
                                                    ${language.patronRewardsRecommendedDescription()}
                                                </p>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div className="col-12 col-md-6 col-lg-4 mb-4">
                                <div className="bg_white rounded-10">
                                    <div className="pt-3 px-3 text-center">
                                        <img className="logo" src=${R("/images/kickstarter-logo-color.png")} alt="Kickstarter logo" />
                                        <p className="py-2 font_xs_m font_md_xl fontw-700">Kickstarter</p>
                                    </div>
                                    <div className="card-body">
                                        <ul className="list-group">
                                            <li className="list-group-item">
                                                <p>${language.creatorsReceiveMoney()}</p>
                                                <p className="text-muted mb-0">
                                                    ${language.creatorsReceiveMoneyDescription()}
                                                </p>
                                            </li>
                                            <li className="list-group-item">
                                                <p>${language.kickstarterFees()}</p>
                                                <p className="text-muted mb-0">
                                                    ${language.kickstarterFeesDescription()}
                                                </p>
                                            </li>
                                            <li className="list-group-item">
                                                <p>${language.backerRewardsRecommended()}</p>
                                                <p className="text-muted mb-0">
                                                    ${language.backerRewardsRecommendedDescription()}
                                                </p>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                    <div className="container mt-3 py-3 py-md-5">
                        <h1 className="font_xs_xl font_md_3xl fontw-700">${language.wishIdeas()}</h1>
                        <p>${language.wishIdeasIntro()}</p>
            
                        <div className="row">
                            <div className="col-12 col-sm-6 col-md mb-4">
                                <div className="">
                                    <div className="card-img-top rounded-10-t" style=${bgStyle("https://media.giphy.com/media/L4gKRkblWlYoE/giphy.gif")} />
                                    <div className="card-body bg-dotted-pattern-grey">
                                        <h5 className="card-title font_xs_m font_md_xl fontw-700">${language.studioMicrophone()} <span className="ec ec-microphone"></span></h5>
                                        <p className="card-text">${language.studioMicrophoneDescription()}</p>
                                        <a className="btn btn-primary col col-md-auto" href="make-a-wish">${language.makeAWishNow()}</a>
                                    </div>
                                </div>
                            </div>
                            <div className="col-12 col-sm-6 col-md mb-4">
                                <div className="">
                                    <div className="card-img-top rounded-10-t" style=${bgStyle("https://media.giphy.com/media/6nZR9Hl2e716wWvwBb/giphy.gif")} />
                                    <div className="card-body bg-dotted-pattern-grey">
                                        <h5 className="card-title font_xs_m font_md_xl fontw-700">${language.actionCamera()} <span className="ec ec-camera"></span></h5>
                                        <p className="card-text">${language.actionCameraDescription()}</p>
                                        <a className="btn btn-primary col col-md-auto" href="make-a-wish">${language.makeAWishNow()}</a>
                                    </div>
                                </div>
                            </div>
                            <div className="col-12 col-sm-6 col-md mb-4">
                                <div className="">
                                    <div className="card-img-top rounded-10-t" style=${bgStyle("https://media.giphy.com/media/gK0Lv2068NnAD8zkDU/giphy.gif")} />
                                    <div className="card-body bg-dotted-pattern-grey">
                                        <h5 className="card-title font_xs_m font_md_xl fontw-700">${language.multimediaSoftware()} <span className="ec ec-computer"></span></h5>
                                        <p className="card-text">${language.multimediaSoftwareDescription()}</p>
                                        <a className="btn btn-primary col col-md-auto" href="make-a-wish">${language.makeAWishNow()}</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    
                    
                </div>
                <div className="d-none d-md-block slogan-space">&nbsp;</div>
            </div>

            
        </Fragment>
    ');
}