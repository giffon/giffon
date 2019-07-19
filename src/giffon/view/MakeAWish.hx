package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
using giffon.lang.MakeAWish;

class MakeAWish extends Page {
    override function title() return language.makeAWish() + " - Giffon";
    override function path() return "make-a-wish";
    override function render() return super.render();

    override function requiredSignin() return true;

    override function bodyClasses() return super.bodyClasses().concat(["page-make-a-wish"]);

    // function wishFormHTML() {
    //     return {__html: ReactDOMServer.renderToString(cast React.createElement(giffon.browser.WishForm))};
    // }

    override function bodyContent() return jsx('
        <div className="container">
            <h1>${language.makeAWish()}</h1>
            <div id="make-a-wish-root" className="mb-5"></div>
        </div>
    ');
}