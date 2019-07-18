package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.R.*;

class UseCasesVideoCreators extends Page {
    override function title() return 'For Video Creators - Giffon';
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
            <h1>Giffon for Video Creators</h1>
            <p>
                Producing videos may cost a lot <span className="ec ec-money-with-wings"></span>. You need recording equipments, post-production software, props etc.
            </p>
            <p>
                Let your fans help you to cut your cost, and to produce better videos <span className="ec ec-video-camera"></span>.
            </p>
            <p><a href="make-a-wish">Make a wish</a> in Giffon and let the community buy you a gift!</p>

            <h2>Wish ideas</h2>
            <p>Here are some goodies that can be useful to video creators.</p>

            <div className="row">
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/L4gKRkblWlYoE/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">Studio Microphone <span className="ec ec-microphone"></span></h5>
                            <p className="card-text">Your fans deserve hearing you in good quality.</p>
                        </div>
                    </div>
                </div>
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/6nZR9Hl2e716wWvwBb/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">Action Camera <span className="ec ec-camera"></span></h5>
                            <p className="card-text">Your outdoor action looks different with a professional action camera.</p>
                        </div>
                    </div>
                </div>
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/gK0Lv2068NnAD8zkDU/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">Multimedia Software <span className="ec ec-computer"></span></h5>
                            <p className="card-text">Get professional graphic/video editing software to produce better works.</p>
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <h2>How does Giffon compare to other services?</h2>

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
                                        <p>Creators receive gifts <i className="fas fa-check text-success"></i></p>
                                        <p className="text-muted mb-0">
                                            It is more likely for people to contribute if they know how their money will be spent.
                                        </p>
                                    </li>
                                    <li className="list-group-item">
                                        <p>${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% fee <i className="fas fa-check text-success"></i></p>
                                        <p className="text-muted mb-0">
                                            The service charge is ${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% of the wish value, paid by contributions. Giffon is 100% free for creators.
                                        </p>
                                    </li>
                                    <li className="list-group-item">
                                        <p>No rewards required <i className="fas fa-check text-success"></i></p>
                                        <p className="text-muted mb-0">
                                            Your work is your contributors\' best reward. Do not get sidetracked for preparing ad hoc swags.
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
                                        <p>Creators receive money</p>
                                        <p className="text-muted mb-0">
                                            Contributors do not know how their money contribution is spent.
                                        </p>
                                    </li>
                                    <li className="list-group-item">
                                        <p>5 to 12% + payment processor fees + payout fees</p>
                                        <p className="text-muted mb-0">
                                            5 to 12% depended on the plan in use, plus payment processor fees ranged from 2.9-6% + 10-30cents, plus payout fees.
                                        </p>
                                    </li>
                                    <li className="list-group-item">
                                        <p>Patron rewards recommended</p>
                                        <p className="text-muted mb-0">
                                            It is common for creators to prepare many patron-only rewards, which distract creators from their creative work.
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
                                        <p>Creators receive money</p>
                                        <p className="text-muted mb-0">
                                            Contributors do not know how their money contribution is spent.
                                        </p>
                                    </li>
                                    <li className="list-group-item">
                                        <p>5% + payment processor fees</p>
                                        <p className="text-muted mb-0">
                                            5% fee to the funds collected for creators, plus payment processing fees (roughly 3-5%).
                                        </p>
                                    </li>
                                    <li className="list-group-item">
                                        <p>Backer rewards recommended</p>
                                        <p className="text-muted mb-0">
                                            It is common for creators to prepare many backer rewards, which distract creators from their creative work.
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
                        Make a Wish Now
                    </a>
                </p>
            </div>
        </div>
    ');
}