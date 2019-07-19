package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.server.ServerMain.*;
import giffon.db.AuthMethod;
import giffon.R.*;
using giffon.db.AuthMethod.AuthMethodTools;
using giffon.lang.SignIn;

class SignIn extends Page {
    override function title() return language.signInUp() + ' - Giffon';
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
                        <h2 className="card-title mb-4">${language.signInUp()}</h2>

                        <div>
                            <SignInButton
                                authMethod=${Facebook}
                                logo=${Facebook.logoImage()}
                                href="signin/facebook"
                                label=${language.signInWith(Facebook)}
                            />
                            <SignInButton
                                authMethod=${Twitter}
                                logo=${Twitter.logoImage()}
                                href="signin/twitter"
                                label=${language.signInWith(Twitter)}
                            />
                            <SignInButton
                                authMethod=${Google}
                                logo=${Google.logoImage()}
                                href="signin/google"
                                label=${language.signInWith(Google)}
                            />
                            <SignInButton
                                authMethod=${GitHub}
                                logo=${GitHub.logoImage()}
                                href="signin/github"
                                label=${language.signInWith(GitHub)}
                            />
                            <SignInButton
                                authMethod=${GitLab}
                                logo=${GitLab.logoImage()}
                                href="signin/gitlab"
                                label=${language.signInWith(GitLab)}
                            />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    ');
}