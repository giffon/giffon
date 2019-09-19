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
        
            <h1 className="font_xs_xl font_md_3xl fontw-700 text-center my-3 my-md-5">${language.makeAWish()}</h1>
            
                <div className="col-12 col-md-10 col-lg-9 mx-auto">
                    <div id="make-a-wish-root" className="font_xs_s font_md_m"></div>
                </div>
            
        </div>
    ');
}