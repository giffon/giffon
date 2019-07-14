package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import giffon.server.ServerMain.*;
import haxe.*;
import haxe.io.*;
import giffon.db.*;
import giffon.R.*;
using giffon.ResponseTools;
using StringTools;

class Page extends ReactComponent {
    var user(get, never):Null<User>;
    function get_user() return (this.props.expressResponse:js.npm.express.ExpressResponse).getUser();

    function title():String return "Giffon";

    function description():Null<String> return null;
    function descriptionTag() return switch description() {
        case null:
            null;
        case desc:
             jsx('
                <meta name="description" content=${desc} />
            ');
    };

    function gtag() {
        // only track production traffic
        switch (giffon.config.Stage.stage) {
            case Production: //pass
            case _: return null;
        }

        var scriptContent = "
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', 'UA-125793554-1');
        ";
        var scriptHtml = {__html: scriptContent};
        return jsx('
            <Fragment>
                <script async=${true} src="https://www.googletagmanager.com/gtag/js?id=UA-125793554-1"></script>
                <script dangerouslySetInnerHTML=${scriptHtml} />
            </Fragment>
        ');
    }

    function path():String throw "should be overridden";
    function canonical() return jsx('
        <link rel="canonical" href="${Path.join([canonicalBase, path()])}" />
    ');

    function requiredSignin() return false;

    function icons() return jsx('
        <Fragment>
            <link rel="icon" href=${R("/favicon.ico")} type="image/x-icon" />
            <link rel="apple-touch-icon-precomposed" href=${R("/apple-icon-152x152.png")} />
            <link rel="icon" href=${R("/favicon-32x32.png")} sizes="32x32" />
            <link rel="shortcut icon" sizes="196x196" href=${R("/android-icon-192x192.png")} />

            <meta name="msapplication-TileColor" content="#B7F8DB" />
            <meta name="msapplication-TileImage" content=${R("/android-icon-144x144.png")} />

            <link rel="mask-icon" href=${R("/images/logo.svg")} color="#B7F8DB" />
        </Fragment>
    ');

    function depCss() return jsx('
        <Fragment>
            <link rel="stylesheet"
                href="https://fonts.googleapis.com/css?family=Nothing+You+Could+Do%7CWork+Sans"
            />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.8.2/css/all.min.css"
                integrity="sha256-BtbhCIbtfeVWGsqxk1vOHEYXS6qcvQvLMZqjtpWUEx8="
                crossOrigin="anonymous"
            />
            <link rel="stylesheet"
                href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
                integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
                crossOrigin="anonymous"
            />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"
                integrity="sha256-3h45mwconzsKjTUULjY+EoEkoRhXcOIU4l5YAw2tSOU="
                crossOrigin="anonymous"
            />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"
                integrity="sha256-etrwgFLGpqD4oNAFW08ZH9Bzif5ByXK2lXNHKy7LQGo="
                crossOrigin="anonymous"
            />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/react-datepicker@2.4.0/dist/react-datepicker.min.css"
                integrity="sha256-gqbLY1z4MASV3jriFFdY5GqRszB+KDUkseSY+RYVAVU="
                crossOrigin="anonymous"
            />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/currency-flags@1.8.0/dist/currency-flags.min.css"
                integrity="sha256-93qPfpLSGzRTJsyLOst+lp0VdYmY9Bqzw4z6By0pYhM="
                crossOrigin="anonymous"
            />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/emoji.css@1.0.4/dist/emoji.min.css"
                integrity="sha256-DTsMpJD6Zg8GpZTJVOCEp2BLvkkQ9wwhAkBbrOGC0cw="
                crossOrigin="anonymous"
            />
        </Fragment>
    ');

    function depJs() return jsx('
        <Fragment>
            <script
                src="https://cdn.jsdelivr.net/npm/jquery@3.4.1/dist/jquery.min.js"
                integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
                crossOrigin="anonymous"
            ></script>
            <script
                src="https://cdn.jsdelivr.net/npm/popper.js@1.15.0/dist/umd/popper.min.js"
                integrity="sha256-fTuUgtT7O2rqoImwjrhDgbXTKUwyxxujIMRIK7TbuNU="
                crossOrigin="anonymous"
            ></script>
            <script
                src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
                integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
                crossOrigin="anonymous"
            ></script>
            <script
                src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.js"
                integrity="sha256-m6pXPkN4hzt6yBzLHZVM6bsrGpM5R60wEiY93GBNhQU="
                crossOrigin="anonymous"
            ></script>
            <script
                src="https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.2.0/js.cookie.min.js"
                integrity="sha256-9Nt2r+tJnSd2A2CRUvnjgsD+ES1ExvjbjBNqidm9doI="
                crossOrigin="anonymous"></script>
            <script
                src="https://js.stripe.com/v3/"
            ></script>
            <script
                src=${R("/js/vendor.js")}
            ></script>
        </Fragment>
    ');

    function css() return jsx('
        <Fragment>
            <link rel="stylesheet" type="text/css" href=${R("/css/style.css")} />
        </Fragment>
    ');

    function js() return jsx('
        <Fragment>
            <script
                src=${R("/js/BrowserMain.js")}
            ></script>
        </Fragment>
    ');

    function head() return jsx('
        <head>
            ${gtag()}
            <meta charSet="UTF-8" />
            <meta httpEquiv="X-UA-Compatible" content="IE=edge" />
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
            <title>${title()}</title>
            ${descriptionTag()}
            ${canonical()}
            ${icons()}
            ${depCss()}
            ${depJs()}
            ${css()}
            ${js()}
        </head>
    ');

    function bodyClasses():Array<String> {
        return [
            user != null ? "signed-in" : "signed-out",
        ];
    }

    function bodyAttributes():DynamicAccess<String> {
        return {};
    }

    function navbarSignIn() {
        if (user != null) {
            var signoutHref = if (requiredSignin())
                "/signout";
            else
                "/signout?redirectTo=" + Path.join(["/", path()]).urlEncode();

            return jsx('
                <ul className="navbar-nav ml-auto">
                    <li className="nav-item">
                        <a className="nav-link user-name" href=${user.user_profile_url}>${user.user_name}</a>
                    </li>
                    <li>
                        <a className="nav-link" href="/settings">Settings</a>
                    </li>
                    <li className="nav-item">
                        <a className="nav-link" href=${signoutHref}>Sign Out</a>
                    </li>
                </ul>
            ');
        } else {
            var signinHref = "/signin?redirectTo=" + Path.join(["/", path()]).urlEncode();
            return jsx('
                <ul className="navbar-nav ml-auto">
                    <li className="nav-item">
                        <a className="nav-link signInBtn" href=${signinHref}>Sign in / Sign up</a>
                    </li>
                </ul>
            ');
        }
    }

    function bodyContent() return null;

    function body() return jsx('
        <body className=${bodyClasses().join(" ")} {...bodyAttributes()}>
            <div className="content">
                <nav className="navbar navbar-light navbar-expand-md font_xs_s font_md_m">
                    <a className="navbar-brand mr-0" href="/" style=${{backgroundImage: 'url(${R("/images/logo-blue.svg")})'}}>
                        Giffon
                    </a>
                    <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample04" aria-controls="navbarsExample04" aria-expanded="false" aria-label="Toggle navigation">
                        <span className="navbar-toggler-icon" />
                    </button>
                    <div className="collapse navbar-collapse" id="navbarsExample04">
                        <ul className="navbar-nav mr-auto">
                            <li className="nav-item">
                                <a className="nav-link" href="/make-a-wish">Make a Wish</a>
                            </li>
                            <li className="nav-item dropdown">
                                <a className="nav-link dropdown-toggle" href="#" id="navbarUseCasesDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    Use Cases
                                </a>
                                <div className="dropdown-menu" aria-labelledby="navbarUseCasesDropdownMenuLink">
                                    <a className="dropdown-item" href="/use-cases/video-creators">for video creators</a>
                                    <a className="dropdown-item" href="/use-cases/oss-developers">for open source developers</a>
                                </div>
                            </li>
                        </ul>
                        ${navbarSignIn()}
                    </div>
                </nav>
                ${bodyContent()}
            </div>
            <footer className="p-5 color_white text-center container-fluid font_xs_xs font_md_s mt-5">
                <div>
                    <div className="p-2 color_white_o50">Giffon - where birds of a feather flock together</div>
                    <div className="copyright p-2">Copyright © Giffon. All Rights Reserved.</div>
                    <a className="p-2" href="/terms">Terms and Conditions</a>
                    <a className="p-2" href="/privacy">Privacy Policy</a>
                </div>
                <div className="social row justify-content-center mt-2">
                    <div className="col-auto"><a href="https://www.facebook.com/giffon.io" target="_blank" rel="noopener" title="Giffon on Facebook"><i className="fab fa-facebook"></i></a></div>
                    <div className="col-auto"><a href="https://twitter.com/giffon_io" target="_blank" rel="noopener" title="Giffon on Twitter"><i className="fab fa-twitter"></i></a></div>
                    <div className="col-auto"><a href="https://gitlab.com/giffon.io/giffon" target="_blank" rel="noopener" title="Giffon on GitLab"><i className="fab fa-gitlab"></i></a></div>
                </div>
            </footer>
        </body>
    ');

    override function render() {
        return jsx('
            <html lang="en">
                ${head()}
                ${body()}
            </html>
        ');
    }
}