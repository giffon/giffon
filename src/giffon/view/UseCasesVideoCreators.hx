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

            <h2>Wish ideas</h2>

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

            <div className="jumbotron" style=${bgStyle(R("/images/max-nelson-1668370-unsplash-blur.jpg"))}>
                <p className="lead text-center">
                    <a className="btn btn-primary btn-lg mt-3 my-5" href="/make-a-wish">
                        Make a Wish Now
                    </a>
                </p>
            </div>
        </div>
    ');
}