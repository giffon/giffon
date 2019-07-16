package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.R.*;

class UseCasesOssDevs extends Page {
    override function title() return 'For Open Source Software Developers - Giffon';
    override function path() return "use-cases/oss-developers";
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-use-cases", "page-use-cases-oss-developers"]);

    function bgStyle(bg:String) {
        return {
            backgroundImage: 'url("${bg}")',
        };
    }

    override function bodyContent() return jsx('
        <div className="container">
            <h1>Giffon for Open Source Software Developers</h1>
            <p>
                There are many devs work on open source projects in their spare time. 
                Those projects can be useful to a lot of people, yet it is still hard to make a living just by building open source works. 
                Eventually, people are tired and projects go unmaintained <span className="ec ec-weary"></span>.
            </p>
            <p>
                Giffon provides users an easy way to show their appreciation to the open source developers. 
                The open source community as a whole can keep the good vibes, avoid developer burnout, and build the next-big-thing together <span className="ec ec-dark-sunglasses"></span>.
            </p>
            <p><a href="/make-a-wish">Make a wish</a> in Giffon and let the community buy you a gift!</p>

            <div className="row justify-content-md-center">
                <div className="alert alert-info col-md-8" role="alert">
                    <h4 className="alert-heading"><i className="fas fa-ticket-alt"></i> Coupon</h4>
                    <p>Use the coupon code <span className="d-inline border bg-light p-1">OSS_ROCKS_JULY</span> on your wish to instantly get a 35 HKD or 5 USD pledge from Giffon.</p>
                    <p className="text-muted mb-0">Applicable only to users connected with a GitHub or GitLab account. Valid until 2019-07-31. Limited quota: 50 users only!</p>
                </div>
            </div>

            <h2>Wish ideas</h2>
            <p>Here are some goodies that can be useful to open source developers.</p>

            <div className="row">
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/BHkzSycc5fZrG/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">IDE License <span className="ec ec-keyboard"></span></h5>
                            <p className="card-text">Get a license to use the pro version of a good IDE to enhance development. JetBrains? Sublime? Visual Studio? Your choice.</p>
                        </div>
                    </div>
                </div>
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/d6WWh3Em7kWHu/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">Upgrade your computer <span className="ec ec-computer"></span></h5>
                            <p className="card-text">A faster computer means less waiting time during development. Stay in the zone.</p>
                        </div>
                    </div>
                </div>
                <div className="col-12 col-sm-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/11DRQ1VQ5p5iPm/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">Dev Swags <span className="ec ec-star2"></span></h5>
                            <p className="card-text">Show off the love of your favourite projects by putting their logo stickers on your laptop, wearing branded T-shirts, hugging mascot stuffed animals.</p>
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
                                    <li className="list-group-item">Good for individuals</li>
                                    <li className="list-group-item">
                                        <p>Developers receive gifts <i className="fas fa-check text-success"></i></p>
                                        <p className="text-muted mb-0">
                                            It is more likely for people to contribute if they know how their money will be spent.
                                        </p>
                                    </li>
                                    <li className="list-group-item">
                                        <p>${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% fee <i className="fas fa-check text-success"></i></p>
                                        <p className="text-muted mb-0">
                                            The service charge is ${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% of the wish value, paid by contributions. Giffon is 100% free for developers.
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
                                    <li className="list-group-item">Project/team-based</li>
                                    <li className="list-group-item">
                                        <p>Projects/teams receive money</p>
                                        <p className="text-muted mb-0">
                                            People state how the money is spent, but there is no enforcement or verification.
                                        </p>
                                    </li>
                                    <li className="list-group-item">
                                        <p>5 or 10% + payment processor fees + payout fees</p>
                                        <p className="text-muted mb-0">
                                            5 or 10% depended on handling method, plus roughly 3-5% payment processor fees, plus payout fees.
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
                                    <li className="list-group-item">Good for individuals</li>
                                    <li className="list-group-item">
                                        <p>Individuals receive money</p>
                                        <p className="text-muted mb-0">
                                            Contributors do not know how their money contribution is spent.
                                        </p>
                                    </li>
                                    <li className="list-group-item">
                                        <p>Unknown processing fees apply (in the future)</p>
                                        <p className="text-muted mb-0">
                                            GitHub Sponsors is free in its first year, but it <a href="https://help.github.com/en/articles/about-github-sponsors#about-the-github-sponsors-matching-fund" target="_blank" rel="noopener">stated</a> it may charge a nominal processing fee in the future.
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
                    <a className="btn btn-primary btn-lg mt-3 my-5" href="/make-a-wish">
                        Make a Wish Now
                    </a>
                </p>
            </div>
        </div>
    ');
}