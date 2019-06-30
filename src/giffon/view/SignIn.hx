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
                            <SignInButton
                                networkName="Facebook"
                                logo=${R("/images/Facebook logo 2019.svg")}
                                href="/signin/facebook"
                                label="Sign in with Facebook"
                            />
                            <SignInButton
                                networkName="Twitter"
                                logo=${R("/images/Twitter_Logo_WhiteOnBlue.svg")}
                                href="/signin/twitter"
                                label="Sign in with Twitter"
                            />
                            <SignInButton
                                networkName="Google"
                                logo=${R("/images/Google__G__Logo.svg")}
                                href="/signin/google"
                                label="Sign in with Google"
                            />
                            <SignInButton
                                networkName="GitHub"
                                logo=${R("/images/github-seeklogo.com.svg")}
                                href="/signin/github"
                                label="Sign in with Github"
                            />
                            <SignInButton
                                networkName="GitLab"
                                logo=${R("/images/gitlab-icon-rgb.svg")}
                                href="/signin/gitlab"
                                label="Sign in with GitLab"
                            />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    ');
}