package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
import giffon.server.ServerMain.*;

class SignIn extends Page {
    override function title() return 'Sign in - Giffon';
    override function path() return "signin";
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-signin"]);

    override function bodyContent() return jsx('
        <div className="container h-75 p-5">
            <div className="h-100 row justify-content-center align-items-center">
                <div className="card col-auto">
                    <div className="card-body">
                        <h2 className="card-title">Sign in / Sign up</h2>

                        <div><a className="d-inline-block py-1" href="/signin/facebook"><i className="fab fa-facebook"></i> Facebook</a></div>
                        <div><a className="d-inline-block py-1" href="/signin/github"><i className="fab fa-github"></i> GitHub</a></div>
                    </div>
                </div>
            </div>
        </div>
    ');
}