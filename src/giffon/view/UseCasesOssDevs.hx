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
        <div className="container">
            <h1>${language.titleHeader()}</h1>
            ${language.introText()}

            <h2>${language.wishIdeas()}</h2>
            <p>${language.wishIdeasIntro()}</p>

            <div className="row">
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/BHkzSycc5fZrG/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">${language.ideLicense()} <span className="ec ec-keyboard"></span></h5>
                            <p className="card-text">${language.ideLicenseDescription()}</p>
                        </div>
                    </div>
                </div>
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/d6WWh3Em7kWHu/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">${language.upgradeYourComputer()} <span className="ec ec-computer"></span></h5>
                            <p className="card-text">${language.upgradeYourComputerDescription()}</p>
                        </div>
                    </div>
                </div>
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/11DRQ1VQ5p5iPm/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">${language.devSwags()} <span className="ec ec-star2"></span></h5>
                            <p className="card-text">${language.devSwagsDescription()}</p>
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
                        <div className="card">
                            <div className="card-header text-center">
                                <img className="logo" src=${R("/images/opencollective.png")} alt="Open Collective logo" />
                                Open Collective
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
                        <div className="card">
                            <div className="card-header text-center">
                                <img className="logo" src=${R("/images/mona-heart-featured.png")} alt="GitHub Sponsors logo" />
                                GitHub Sponsors
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

            <div className="jumbotron" style=${bgStyle(R("/images/jefferson-santos-450403-unsplash-blur.jpg"))}>
                <p className="lead text-center">
                    <a className="btn btn-primary btn-lg mt-3 my-5" href="make-a-wish">
                        ${language.makeAWishNow()}
                    </a>
                </p>
            </div>
        </div>
    ');
}