package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import giffon.server.ServerMain.*;
import haxe.*;
import haxe.io.*;
import giffon.db.*;
import giffon.R.*;
using giffon.ResponseTools;
using giffon.lang.Page;
using giffon.lang.LanguageTools;
using StringTools;

class Page extends ReactComponent {
    var base(get, never):Null<String>;
    function get_base() return switch ((this.props.expressResponse:js.npm.express.Response).locals.base) {
        case null, "": "/";
        case b: haxe.io.Path.addTrailingSlash(b);
    };

    var user(get, never):Null<User>;
    function get_user() return (this.props.expressResponse:js.npm.express.Response).getUser();

    var language(get, never):giffon.lang.Language;
    function get_language() return (this.props.expressResponse:js.npm.express.Response).locals.language;

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

    function baseTag() return jsx('
        <base href=${base} />
    ');

    function fullstory() {
        // only track production traffic
        switch (giffon.config.Stage.stage) {
            case Production: //pass
            case _: return null;
        }

        var scriptContent = "
            window['_fs_debug'] = false;
            window['_fs_host'] = 'fullstory.com';
            window['_fs_org'] = 'NPXHJ';
            window['_fs_namespace'] = 'FS';
            (function(m,n,e,t,l,o,g,y){
                if (e in m) {if(m.console && m.console.log) { m.console.log('FullStory namespace conflict. Please set window[\"_fs_namespace\"].');} return;}
                g=m[e]=function(a,b,s){g.q?g.q.push([a,b,s]):g._api(a,b,s);};g.q=[];
                o=n.createElement(t);o.async=1;o.crossOrigin='anonymous';o.src='https://'+_fs_host+'/s/fs.js';
                y=n.getElementsByTagName(t)[0];y.parentNode.insertBefore(o,y);
                g.identify=function(i,v,s){g(l,{uid:i},s);if(v)g(l,v,s)};g.setUserVars=function(v,s){g(l,v,s)};g.event=function(i,v,s){g('event',{n:i,p:v},s)};
                g.shutdown=function(){g(\"rec\",!1)};g.restart=function(){g(\"rec\",!0)};
                g.log = function(a,b) { g(\"log\", [a,b]) };
                g.consent=function(a){g(\"consent\",!arguments.length||a)};
                g.identifyAccount=function(i,v){o='account';v=v||{};v.acctId=i;g(o,v)};
                g.clearUserCookie=function(){};
            })(window,document,window['_fs_namespace'],'script','user');
        ";
        var scriptHtml = {__html: scriptContent};
        return jsx('
            <Fragment>
                <script dangerouslySetInnerHTML=${scriptHtml} />
            </Fragment>
        ');
    }

    function gtmHead() {
        // only track production traffic
        switch (giffon.config.Stage.stage) {
            case Production: //pass
            case _: return null;
        }

        var scriptContent = "
            (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
            new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
            j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
            'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
            })(window,document,'script','dataLayer','GTM-TSVCXGW');
        ";
        var scriptHtml = {__html: scriptContent};
        return jsx('
            <Fragment>
                <script dangerouslySetInnerHTML=${scriptHtml} />
            </Fragment>
        ');
    }

    function gtmBody() {
        // only track production traffic
        switch (giffon.config.Stage.stage) {
            case Production: //pass
            case _: return null;
        }
        return jsx('
            <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-TSVCXGW"
            height="0" width="0" style=${{display:"none", visibility:"hidden"}}></iframe></noscript>
        ');
    }

    function path():String throw "should be overridden";

    function canonicalOfLang(lang:Null<giffon.lang.Language>):String {
        return switch (lang) {
            case null:
                Path.join([canonicalBase, path()]);
            case _:
                Path.join([canonicalBase, lang.code() , path()]);
        }
    }

    function canonical() {
        return jsx('
            <link rel="canonical" href=${canonicalOfLang(base == "/" ? null : language)} />
        ');
    }

    function hreflang() {
        var links = [
            for (lang in Type.allEnums(giffon.lang.Language)) {
                jsx('
                    <link key=${lang.code()} rel="alternate" hrefLang=${lang.code()} href=${canonicalOfLang(lang)} />
                ');
            }
        ];
        links.push(
            jsx('
                <link key="x-default" rel="alternate" hrefLang="x-default" href=${canonicalOfLang(null)} />
            ')
        );
        return links;
    }

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

    function useCurrencyFlags() return false;
    function currencyFlagsCss() return if (useCurrencyFlags())
        jsx('
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/currency-flags@1.8.0/dist/currency-flags.min.css"
                integrity="sha256-93qPfpLSGzRTJsyLOst+lp0VdYmY9Bqzw4z6By0pYhM="
                crossOrigin="anonymous"
            />
        ');
    else
        null;

    function useEmoji() return false;
    function emojiCss() return if (useEmoji())
        jsx('
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/emoji.css@1.0.4/dist/emoji.min.css"
                integrity="sha256-DTsMpJD6Zg8GpZTJVOCEp2BLvkkQ9wwhAkBbrOGC0cw="
                crossOrigin="anonymous"
            />
        ');
    else
        null;

    function depCss() return jsx('
        <Fragment>
            <link rel="stylesheet"
                href="https://fonts.googleapis.com/css?family=Nothing+You+Could+Do%7CWork+Sans"
            />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.10.2/css/all.min.css"
                integrity="sha256-zmfNZmXoNWBMemUOo1XUGFfc0ihGGLYdgtJS3KCr/l0="
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
                href="https://cdn.jsdelivr.net/npm/react-datepicker@2.9.3/dist/react-datepicker.min.css"
                integrity="sha256-yySl4qcUS7M+bpiq/+Ns5KR/oL7UiobOWIKzJ2ejSR8="
                crossOrigin="anonymous"
            />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/react-block-ui@1.3.1/dist/style.css"
                integrity="sha256-zQ8cKXBKcAKSsepjbYn3y/mHnWWwMBsK3KvoQCOauEY="
                crossOrigin="anonymous"
            />
            ${currencyFlagsCss()}
            ${emojiCss()}
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
                src="https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.2.1/js.cookie.min.js"
                integrity="sha256-oE03O+I6Pzff4fiMqwEGHbdfcW7a3GRRxlL+U49L5sA="
                crossOrigin="anonymous"
            ></script>
            <script
                src="https://js.stripe.com/v3/"
            ></script>
            <script
                src=${R("/js/vendor.js")}
            ></script>
            <script
                src=${R("/js/rellax.min.js")}
            ></script>
        </Fragment>
    ');

    function css() return jsx('
        <Fragment>
            <link rel="stylesheet" type="text/css" href=${R("/css/style.css")} />
            <link rel="stylesheet" type="text/css" href=${R("/css/fontsize.css")} />
            <link rel="stylesheet" type="text/css" href=${R("/css/color.css")} />
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
            ${gtmHead()}
            ${fullstory()}
            <meta charSet="UTF-8" />
            <meta httpEquiv="X-UA-Compatible" content="IE=edge" />
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
            ${baseTag()}
            <title>${title()}</title>
            ${descriptionTag()}
            ${canonical()}
            ${hreflang()}
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
                "signout";
            else
                "signout?redirectTo=" + Path.join([base, path()]).urlEncode();

            return jsx('
                <ul className="navbar-nav ml-auto">
                    <li className="nav-item">
                        <a className="nav-link user-name" href=${user.user_profile_url}>${user.user_name}</a>
                    </li>
                    <li>
                        <a className="nav-link" href="settings">${language.settings()}</a>
                    </li>
                    <li className="nav-item">
                        <a className="nav-link" href=${signoutHref}>${language.signOut()}</a>
                    </li>
                </ul>
            ');
        } else {
            var signinHref = "signin?redirectTo=" + Path.join([base, path()]).urlEncode();
            return jsx('
                <ul className="navbar-nav ml-auto">
                    <li className="nav-item">
                        <a className="nav-link signInBtn" href=${signinHref}>${language.signInUp()}</a>
                    </li>
                </ul>
            ');
        }
    }

    function bodyContent() return null;

    function body() return jsx('
        <body className=${bodyClasses().join(" ")} {...bodyAttributes()}>
            ${gtmBody()}
            <div className="content">
                <nav className="navbar navbar-light navbar-expand-md font_xs_s font_md_m">
                    <a className="navbar-brand mr-0" href="" style=${{backgroundImage: 'url(${R("/images/logo-blue.svg")})'}}>
                        Giffon
                    </a>
                    <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample04" aria-controls="navbarsExample04" aria-expanded="false" aria-label="Toggle navigation">
                        <span className="navbar-toggler-icon" />
                    </button>
                    <div className="collapse navbar-collapse" id="navbarsExample04">
                        <ul className="navbar-nav mr-auto">
                            <li className="nav-item">
                                <a className="nav-link" href="make-a-wish">${language.makeAWish()}</a>
                            </li>
                            <li className="nav-item dropdown">
                                <a className="nav-link dropdown-toggle" href="#" id="navbarUseCasesDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    ${language.useCases()}
                                </a>
                                <div className="dropdown-menu" aria-labelledby="navbarUseCasesDropdownMenuLink">
                                    <a className="dropdown-item" href="use-cases/video-creators">${language.forVideoCreators()}</a>
                                    <a className="dropdown-item" href="use-cases/oss-developers">${language.forOpenSourceDevelopers()}</a>
                                </div>
                            </li>
                        </ul>
                        ${navbarSignIn()}
                    </div>
                </nav>
                ${bodyContent()}
            </div>
            <footer className="p-0 bg_grey_900 color_grey_400 font_xs_xs font_md_s mt-5">
                <div className="container py-4 py-sm-5">
                    <div className="row">
                        <div className="col-12 col-sm-4 mb-4 mb-sm-0">
                            <div className="font_xs_s font_md_l">${language.socialNetwork()}</div>
                            <div className="row align-items-center font_xs_xl mt-2">
                                <div className="col-auto"><a href="https://www.facebook.com/giffon.io" style=${{'color': '#3578E5'}} target="_blank" rel="noopener" title=${language.giffonOnFacebook()}><i className="fab fa-facebook"></i></a></div>
                                <div className="col-auto"><a href="https://twitter.com/giffon_io" style=${{'color': '#1da1f2'}} target="_blank" rel="noopener" title=${language.giffonOnTwitter()}><i className="fab fa-twitter"></i></a></div>
                                <div className="col-auto"><a href="https://www.instagram.com/giffonio/" style=${{'color': '#C13584'}} target="_blank" rel="noopener" title=${language.giffonOnInstagram()}><i className="fab fa-instagram"></i></a></div>
                            </div>
                        </div>
                        <div className="col-12 col-sm-4 mb-4 mb-sm-0">
                            <div className="font_xs_s font_md_l">${language.paymentOption()}</div>
                            <div className="row align-items-center mt-2">
                                <div className="col-auto"><img alt="Visa" title="Visa" src=${R("/images/visa.svg")} width="35"/></div>
                                <div className="col-auto"><img alt="Mastercard" title="Mastercard" src=${R("/images/mastercard.svg")} width="30"/></div>
                                <div className="col-auto"><img alt="American Express" title="American Express" src=${R("/images/ae.svg")} width="30"/></div>
                                <div className="col-auto"><img alt="PayPal" title="PayPal" src=${R("/images/pp-acceptance-small.png")} width="30"/></div>
                            </div>
                        </div>
                        <div className="col-12 col-sm-4 mb-4 mb-sm-0">
                            <div className="font_xs_s font_md_l">${language.languageOption()}</div>
                            <div className="language row align-items-center mt-2">
                                <div className="col-auto"><a href=${Path.join(["/en", path()])}>English</a></div>
                                <div className="col-auto"><a href=${Path.join(["/zh-HK", path()])}>中文(香港)</a></div>
                                <div className="col-auto"><a href=${Path.join(["/zh-TW", path()])}>中文(台灣)</a></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="p-3 bg_black d-md-flex">
                    <div className="col p-0 m-0">Giffon © 2019</div>
                    <div>
                        <a className="pr-2" href="terms">${language.termsAndConditions()}</a>
                        <a href="privacy">${language.privacyPolicy()}</a>
                    </div>
                </div>
            </footer>
        </body>
    ');

    override function render() {
        return jsx('
            <html lang=${giffon.lang.LanguageTools.code(language)}>
                ${head()}
                ${body()}
            </html>
        ');
    }
}