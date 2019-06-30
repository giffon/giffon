package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.server.ServerMain.*;
import giffon.R.*;

class SignIn extends Page {
    override function title() return 'Sign in - Giffon';
    override function path() return "signin";
    override function render() return super.render();

    override function depCss() {
        return jsx('
            <Fragment>
                ${super.depCss()}
                <link rel="stylesheet"
                    href="https://fonts.googleapis.com/css?family=Roboto:500"
                />
            </Fragment>
        ');
    }

    override function bodyClasses() return super.bodyClasses().concat(["page-signin"]);

    override function bodyContent() return jsx('
        <div className="container h-75 p-5">
            <div className="h-100 row justify-content-center align-items-center">
                <div className="card col-auto">
                    <div className="card-body">
                        <h2 className="card-title mb-4">Sign in / Sign up</h2>

                        <div style=${{fontFamily: "Roboto"}}>
                            <div className="mb-2"><a className="signInBtn d-flex align-items-center border-bottom rounded-sm shadow-sm p-2" href="/signin/facebook"><img className="logo mx-1" src=${R('/images/Facebook logo 2019.svg')} alt="Facebook logo"/><span className="flex-grow-1 text-center">Sign in with Facebook</span></a></div>
                            <div className="mb-2"><a className="signInBtn d-flex align-items-center border-bottom rounded-sm shadow-sm p-2" href="/signin/twitter"><img className="logo mx-1" src=${R('/images/Twitter_Logo_WhiteOnBlue.svg')} alt="Twitter logo"/><span className="flex-grow-1 text-center">Sign in with Twitter</span></a></div>
                            <div className="mb-2"><a className="signInBtn d-flex align-items-center border-bottom rounded-sm shadow-sm p-2" href="/signin/google"><img className="logo mx-1" src=${R('/images/Google__G__Logo.svg')} alt="Google logo"/><span className="flex-grow-1 text-center">Sign in with Google</span></a></div>
                            <div className="mb-2"><a className="signInBtn d-flex align-items-center border-bottom rounded-sm shadow-sm p-2" href="/signin/github"><img className="logo mx-1" src=${R('/images/github-seeklogo.com.svg')} alt="GitHub logo"/><span className="flex-grow-1 text-center">Sign in with GitHub</span></a></div>
                            <div className="mb-2"><a className="signInBtn d-flex align-items-center border-bottom rounded-sm shadow-sm p-2" href="/signin/github"><img className="logo mx-1" src=${R('/images/gitlab-icon-rgb.svg')} alt="GitLab logo"/><span className="flex-grow-1 text-center">Sign in with GitLab</span></a></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    ');
}