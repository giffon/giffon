package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.server.ServerMain.*;
import giffon.db.AuthMethod;
import giffon.R.*;
using giffon.db.AuthMethod.AuthMethodTools;

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

                        <div>
                            <SignInButton
                                authMethod=${Facebook}
                                logo=${Facebook.logoImage()}
                                href="/signin/facebook"
                                label="Sign in with Facebook"
                            />
                            <SignInButton
                                authMethod=${Twitter}
                                logo=${Twitter.logoImage()}
                                href="/signin/twitter"
                                label="Sign in with Twitter"
                            />
                            <SignInButton
                                authMethod=${Google}
                                logo=${Google.logoImage()}
                                href="/signin/google"
                                label="Sign in with Google"
                            />
                            <SignInButton
                                authMethod=${GitHub}
                                logo=${GitHub.logoImage()}
                                href="/signin/github"
                                label="Sign in with Github"
                            />
                            <SignInButton
                                authMethod=${GitLab}
                                logo=${GitLab.logoImage()}
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