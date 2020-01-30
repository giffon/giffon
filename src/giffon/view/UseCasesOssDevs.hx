package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.R.*;
using giffon.lang.UseCasesOssDevs;

class UseCasesOssDevs extends Page {
    override function title() return language.titleTag() + ' - Giffon';
    override function path() return "use-cases/oss-developers";
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-use-cases", "page-use-cases-oss-developers"]);

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
                    <div className="bbanner rounded-10" data-section="developer">
                        <div className="container p-0 d-md-flex">
                            <div className="intro-title p-4 p-lg-5 mb-md-5 bg-dotted-pattern color_white rounded-md-0 rounded-10">
                                <h1 className="intro-title-text font_xs_xl font_md_3xl fontw-700 mb-5 color_white white-space-prewrap">${language.titleHeader()}</h1>
                                <p>${language.introText()}</p>
                                <a className="btn btn-primary col col-md-auto" href="make-a-wish">${language.makeAWishNow()}</a>
                            </div>
                        </div>
                    </div>
                    <div className="bg-curve-2 rounded-10 mt-3 pt-3 pt-md-5">
                        <div className="container">
                            <h1 className="py-5 font_xs_xl font_md_3xl fontw-700">${language.howDoesGiffonCompareToOtherServices()}</h1>
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
                                                    ${language.goodForIndividuals()}
                                                </li>
                                                <li className="list-group-item">
                                                    <p>${language.developersReceiveGifts()} <i className="fas fa-check text-success"></i></p>
                                                    <p className="text-muted mb-0">
                                                        ${language.developersReceiveGiftsDescription()}
                                                    </p>
                                                </li>
                                                <li className="list-group-item">
                                                    <p>${language.serviceFeeAmount()} <i className="fas fa-check text-success"></i></p>
                                                    <p className="text-muted mb-0">
                                                        ${language.serviceFeeAmountDescription()}
                                                    </p>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                <div className="col-12 col-md-6 col-lg-4 mb-4">
                                    <div className="bg_white rounded-10">
                                        <div className="pt-3 px-3 text-center">
                                            <img className="logo" src=${R("/images/opencollective.png")} alt="Open Collective logo" />
                                            <p className="py-2 font_xs_m font_md_xl fontw-700">Open Collective</p>
                                        </div>
                                        <div className="card-body">
                                            <ul className="list-group">
                                                <li className="list-group-item">
                                                    ${language.projectTeamBased()}
                                                </li>
                                                <li className="list-group-item">
                                                    <p>${language.projectsTeamsReceiveMoney()}</p>
                                                    <p className="text-muted mb-0">
                                                        ${language.projectsTeamsReceiveMoneyDescription()}
                                                    </p>
                                                </li>
                                                <li className="list-group-item">
                                                    <p>${language.openCollectiveFees()}</p>
                                                    <p className="text-muted mb-0">
                                                        ${language.openCollectiveFeesDescription()}
                                                    </p>
                                                </li>
                                            </ul>
                                            </div>
                                    </div>
                                </div>
                                <div className="col-12 col-md-6 col-lg-4 mb-4">
                                    <div className="bg_white rounded-10">
                                        <div className="pt-3 px-3 text-center">
                                            <img className="logo" src=${R("/images/mona-heart-featured.png")} alt="GitHub Sponsors logo" />
                                            <p className="py-2 font_xs_m font_md_xl fontw-700">GitHub Sponsors</p>
                                        </div>
                                        <div className="card-body">
                                            <ul className="list-group">
                                                <li className="list-group-item">
                                                    ${language.goodForIndividuals()}
                                                </li>
                                                <li className="list-group-item">
                                                    <p>${language.individualsReceiveMoney()}</p>
                                                    <p className="text-muted mb-0">
                                                        ${language.individualsReceiveMoneyDescription()}
                                                    </p>
                                                </li>
                                                <li className="list-group-item">
                                                    <p>${language.gitHubSponsorsFees()}</p>
                                                    <p className="text-muted mb-0">
                                                        ${language.gitHubSponsorsFeesDescription()}
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
                                    <div className="card-img-top rounded-10-t" style=${bgStyle("https://media.giphy.com/media/BHkzSycc5fZrG/giphy.gif")} />
                                    <div className="card-body bg-dotted-pattern-grey">
                                        <h5 className="card-title">${language.ideLicense()} <span className="ec ec-keyboard"></span></h5>
                                        <p className="card-text">${language.ideLicenseDescription()}</p>
                                        <a className="btn btn-primary col col-md-auto" href="make-a-wish">${language.makeAWishNow()}</a>
                                    </div>
                                </div>
                            </div>
                            <div className="col-12 col-sm-6 col-md mb-4">
                                <div className="">
                                    <div className="card-img-top rounded-10-t" style=${bgStyle("https://media.giphy.com/media/d6WWh3Em7kWHu/giphy.gif")} />
                                    <div className="card-body bg-dotted-pattern-grey">
                                        <h5 className="card-title">${language.upgradeYourComputer()} <span className="ec ec-computer"></span></h5>
                                        <p className="card-text">${language.upgradeYourComputerDescription()}</p>
                                        <a className="btn btn-primary col col-md-auto" href="make-a-wish">${language.makeAWishNow()}</a>
                                    </div>
                                </div>
                            </div>
                            <div className="col-12 col-sm-6 col-md mb-4">
                                <div className="">
                                    <div className="card-img-top rounded-10-t" style=${bgStyle("https://media.giphy.com/media/11DRQ1VQ5p5iPm/giphy.gif")} />
                                    <div className="card-body bg-dotted-pattern-grey">
                                        <h5 className="card-title">${language.devSwags()} <span className="ec ec-star2"></span></h5>
                                        <p className="card-text">${language.devSwagsDescription()}</p>
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