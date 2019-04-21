package giffon.view;

import react.*;
import react.ReactMacro.jsx;

class Index extends Page {
    override function path() return "";
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-index"]);

    override function bodyContent() return jsx('
        <Fragment>
            <nav className="navbar navbar-expand-md font_xs_s font_md_m">
                <a className="navbar-brand mr-5" href="#"><h3 className="pl-5" style=${{backgroundImage: 'url("images/logo-blue.svg")', width: '30px', height: '30px', backgroundSize: '30px', backgroundRepeat: 'no-repeat'}}>Giffon</h3></a>
                <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample04" aria-controls="navbarsExample04" aria-expanded="false" aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon" />
                </button>
                <div className="collapse navbar-collapse" id="navbarsExample04">
                    <ul className="navbar-nav ml-md-5 mr-auto">
                        <li className="nav-item active">
                            <a className="nav-link" href="#">Home <span className="sr-only">(current)</span></a>
                        </li>
                        <li className="nav-item">
                            <a className="nav-link" href="#">How it Works</a>
                        </li>
                        <li className="nav-item">
                            <a className="nav-link" href="#">Contact Us</a>
                        </li>
                    </ul>
                    <ul className="navbar-nav ml-auto">
                        <li className="nav-item">
                            <a className="nav-link" href="#">Harry Potter</a>
                        </li>
                        <li className="nav-item">
                            <a className="nav-link" href="#">Sign Out</a>
                        </li>
                    </ul>
                </div>
            </nav>
            <div id="banner" className="font_xs_s font_md_m">
                <div>
                    <div className="row mx-0 p-4 p-md-5">
                        <div className="col-10 col-md-6 mx-0 mx-md-auto py-3 my-3 py-md-5 my-md-5 color_white">
                            <div className="font_xs_xl font_md_xxl">Your Crowd-gifting Platform</div>
                            <div className="font_xs_s font_md_m">either for who...or yourself</div>
                        </div>
                        <div className="col-12 col-md-3  mx-0 mx-md-auto px-0 py-5">
                            <div className="p-3 p-md-5 bg_white">
                                Buying a gift for a new family / Thinking of a pricy festive retreat... 
                            </div>
                            <button className="btn btn-success rounded-0 w-100">
                                Create a campaign
                            </button>
                            <br /><br /><br />
                        </div>
                    </div>
                </div>
            </div>
            <div className="row mx-0">
                <div className="col-xs-12 col-sm-6 col-md-3">
                    <div className="p-5">
                        <p>How it Works</p>
                    </div>
                </div>
                <div className="col-xs-12 col-sm-6 col-md-3">
                    <div className="p-5">
                        <p>Step 1</p>
                        <p>Select items you need</p>
                    </div>
                </div>
                <div className="col-xs-12 col-sm-6 col-md-3">
                    <div className="p-5">
                        <p>Step 2</p>
                        <p>Select type of campaign to start</p>
                    </div>
                </div>
                <div className="col-xs-12 col-sm-6 col-md-3">
                    <div className="p-5">
                        <p>Step 3</p>
                        <p>Share link to your friends</p>
                    </div>
                </div>
            </div>
            <div className="text-center pb-5">
                <button className="btn btn-success">Start a Campaign</button>
            </div>
            <div className="text-center pb-3">
                <h2>Recent campaigns</h2>
            </div>
            <div className="res-slick mb-5">
                <div className="col-xs-12 col-md-6 col-lg-4 mx-0">
                    <div>
                        <div className="campaign border_xs">
                            <div className="image border_xs_b">
                            </div>
                            <div className="row m-0 border_xs_b">
                                <div className="col-xs-3 border_xs_r">
                                    <div className="p-3"><i className="far fa-gem" /></div>
                                </div>
                                <div className="col-xs-9">
                                    <div className="p-3">title</div>
                                </div>
                            </div>
                            <div className="p-3 border_xs_b">stories</div>
                            <button className="btn btn-success rounded-0 w-100">
                                Support!
                            </button>
                        </div>
                    </div>
                </div>
                <div className="col-xs-12 col-md-6 col-lg-4 mx-0">
                    <div>
                        <div className="campaign border_xs">
                            <div className="image border_xs_b">
                            </div>
                            <div className="row m-0 border_xs_b">
                                <div className="col-xs-3 border_xs_r">
                                    <div className="p-3"><i className="far fa-gem" /></div>
                                </div>
                                <div className="col-xs-9">
                                    <div className="p-3">title</div>
                                </div>
                            </div>
                            <div className="p-3 border_xs_b">stories</div>
                            <button className="btn btn-success rounded-0 w-100">
                                Support!
                            </button>
                        </div>
                    </div>
                </div>
                <div className="col-xs-12 col-md-6 col-lg-4 mx-0">
                    <div>
                        <div className="campaign border_xs">
                            <div className="image border_xs_b">
                            </div>
                            <div className="row m-0 border_xs_b">
                                <div className="col-xs-3 border_xs_r">
                                    <div className="p-3"><i className="far fa-gem" /></div>
                                </div>
                                <div className="col-xs-9">
                                    <div className="p-3">title</div>
                                </div>
                            </div>
                            <div className="p-3 border_xs_b">stories</div>
                            <button className="btn btn-success rounded-0 w-100">
                                Support!
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <footer className="p-5 color_white text-center" style=${{background: '#13547a'}}>
                Copyright © Giffon. All Rights Reserved.
            </footer>
        </Fragment>
    ');
}