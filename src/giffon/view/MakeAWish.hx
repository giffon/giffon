package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
using giffon.ResponseTools;

class MakeAWish extends Page {
    override function title() return "Make a wish - Giffon";
    override function path() return "make-a-wish";
    override function render() return super.render();

    override function bodyClasses() return super.bodyClasses().concat(["page-make-a-wish"]);

    function wishFormHTML() {
        return ReactDOMServer.renderToString(cast React.createElement(giffon.browser.WishForm));
    }

    override function bodyContent() return jsx('
        <Fragment>
            <h1>Make a wish.</h1>
            <div id="make-a-wish-root">${wishFormHTML()}</div>
        </Fragment>
    ');
}