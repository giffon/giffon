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
        return jsx('
            <Fragment>
                <script async=${true} src="https://www.googletagmanager.com/gtag/js?id=UA-125793554-1"></script>
                <script dangerouslySetInnerHTML=${{__html: scriptContent}} />
            </Fragment>
        ');
    }
    function path():String throw "should be overridden";
    function canonical() return jsx('
        <link rel="canonical" href="${Path.join([canonicalBase, path()])}" />
    ');
    function head() return jsx('
        <head>
            ${gtag()}
            <meta charSet="UTF-8" />
            <meta httpEquiv="X-UA-Compatible" content="IE=edge" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>${title()}</title>
            ${descriptionTag()}
        </head>
    ');
    function body() return jsx('
        <body>
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