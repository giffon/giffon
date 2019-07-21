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

    function bgStyle(bg:String) {
        return {
            backgroundImage: 'url("${bg}")',
        };
    }

    override function bodyContent() return jsx('
        <div className="container">
            <h1>${language.titleHeader()}</h1>
            ${language.introText()}

            <h2>${language.wishIdeas()}</h2>
            <p>${language.wishIdeasIntro()}</p>

            <div className="row">
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/L4gKRkblWlYoE/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">${language.studioMicrophone()} <span className="ec ec-microphone"></span></h5>
                            <p className="card-text">${language.studioMicrophoneDescription()}</p>
                        </div>
                    </div>
                </div>
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/6nZR9Hl2e716wWvwBb/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">${language.actionCamera()} <span className="ec ec-camera"></span></h5>
                            <p className="card-text">${language.actionCameraDescription()}</p>
                        </div>
                    </div>
                </div>
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/gK0Lv2068NnAD8zkDU/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">${language.multimediaSoftware()} <span className="ec ec-computer"></span></h5>
                            <p className="card-text">${language.multimediaSoftwareDescription()}</p>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <h2>${language.howDoesGiffonCompareToOtherServices()}</h2>

                <div className="row">
                    <div className="col-12 col-md-6 col-lg-4 mb-4">
                        <div className="card border-success">
                            <div className="card-header text-center">
                                <img className="logo" src=${R("/images/logo-bg.png")} alt="Giffon logo" />
                                Giffon
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
                        <div className="card">
                            <div className="card-header text-center">
                                <img className="logo" src=${R("/images/Patreon_Mark_Primary.png")} alt="Patreon logo" />
                                Patreon
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
                        <div className="card">
                            <div className="card-header text-center">
                                <img className="logo" src=${R("/images/kickstarter-logo-color.png")} alt="Kickstarter logo" />
                                Kickstarter
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

            <div className="jumbotron" style=${bgStyle(R("/images/max-nelson-1668370-unsplash-blur.jpg"))}>
                <p className="lead text-center">
                    <a className="btn btn-primary btn-lg mt-3 my-5" href="make-a-wish">
                        ${language.makeAWishNow()}
                    </a>
                </p>
            </div>
        </div>
    ');
}