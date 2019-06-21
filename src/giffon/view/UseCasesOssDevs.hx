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

            <h2>Wish ideas</h2>

            <div className="row">
                <div className="col-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/BHkzSycc5fZrG/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">IDE License <span className="ec ec-keyboard"></span></h5>
                            <p className="card-text">Buy a license to use the pro version of a good IDE to enhance development. JetBrains? Sublime? Visual Studio? Your choice.</p>
                        </div>
                    </div>
                </div>
                <div className="col-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/d6WWh3Em7kWHu/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">Upgrade your computer <span className="ec ec-computer"></span></h5>
                            <p className="card-text">A faster computer means less waiting time during development. Stay in the zone.</p>
                        </div>
                    </div>
                </div>
                <div className="col-6 col-md mb-4">
                    <div className="card">
                        <div className="card-img-top" style=${bgStyle("https://media.giphy.com/media/11DRQ1VQ5p5iPm/giphy.gif")} />
                        <div className="card-body">
                            <h5 className="card-title">Dev Swags <span className="ec ec-star2"></span></h5>
                            <p className="card-text">Show off the love of your favourite projects by putting their logo stickers on your laptop, wearing branded T-shirts, hugging mascot stuffed animals.</p>
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