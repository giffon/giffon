package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import giffon.server.ServerMain.*;
import haxe.io.*;

class Page extends ReactComponent {
    function title():String return "Giffon";

    function description():Null<String> return null;
    function descriptionTag() return switch description() {
        case null:
            null;
        case desc:
             jsx('
                <meta name="description" content="<%=description%>" />
            ');
    };

    function gtag() {
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

    function icons() return jsx('
        <Fragment>
            <link rel="icon" href=${R("/favicon.ico")} type="image/x-icon" />
            <link rel="apple-touch-icon-precomposed" href=${R("/apple-icon-152x152.png")} />
            <link rel="icon" href=${R("/favicon-32x32.png")} sizes="32x32" />
            <link rel="shortcut icon" sizes="196x196" href=${R("/android-icon-192x192.png")} />

            <meta name="msapplication-TileColor" content="#B7F8DB" />
            <meta name="msapplication-TileImage" content=${R("android-icon-144x144.png")} />

            <link rel="mask-icon" href=${R("/images/6b.svg")} color="#B7F8DB" />
        </Fragment>
    ');

    function depCss() return jsx('
        <Fragment>
            <link rel="stylesheet"
                href="https://fonts.googleapis.com/css?family=Nothing+You+Could+Do%7CWork+Sans"
            />
            <link rel="stylesheet"
                href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
                integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf"
                crossorigin="anonymous"
            />
            <link rel="stylesheet"
                href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
                integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
                crossorigin="anonymous"
            />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"
                integrity="sha256-3h45mwconzsKjTUULjY+EoEkoRhXcOIU4l5YAw2tSOU="
                crossorigin="anonymous"
            />
            <link rel="stylesheet"
                href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"
                integrity="sha256-etrwgFLGpqD4oNAFW08ZH9Bzif5ByXK2lXNHKy7LQGo="
                crossorigin="anonymous"
            />
        </Fragment>
    ');

    function depJs() return jsx('
        <Fragment>
            <script
                src="https://code.jquery.com/jquery-3.4.0.min.js"
                integrity="sha256-BJeo0qm959uMBGb65z40ejJYGSgR7REI4+CW1fNKwOg="
                crossorigin="anonymous"
            ></script>
            <script
                src="https://cdn.jsdelivr.net/npm/popper.js@1.15.0/dist/umd/popper.min.js"
                integrity="sha256-fTuUgtT7O2rqoImwjrhDgbXTKUwyxxujIMRIK7TbuNU="
                crossorigin="anonymous"
            ></script>
            <script
                src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
                integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
                crossorigin="anonymous"
            ></script>
            <script
                src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"
                integrity="sha256-DHF4zGyjT7GOMPBwpeehwoey18z8uiz98G4PRu2lV0A="
                crossorigin="anonymous"
            ></script>
            <script
                src="https://cdnjs.cloudflare.com/ajax/libs/jsrsasign/8.0.12/jsrsasign-all-min.js"
                integrity="sha256-EI1piDYqyKFAy+ykWQZRjH5kkw9eIYE/IahQWg1rXt0="
                crossorigin="anonymous"></script>
            <script
                src="https://cdnjs.cloudflare.com/ajax/libs/js-cookie/2.2.0/js.cookie.min.js"
                integrity="sha256-9Nt2r+tJnSd2A2CRUvnjgsD+ES1ExvjbjBNqidm9doI="
                crossorigin="anonymous"></script>
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
        return [];
    }

    function bodyContent() return null;

    function body() return jsx('
        <body className=${bodyClasses().join(" ")}>
            ${bodyContent()}
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