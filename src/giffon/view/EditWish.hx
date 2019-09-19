package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;
using giffon.lang.EditWish;

class EditWish extends Page {
    override function title() return '${language.editWish()} - ${wish.wish_title} - Giffon';
    override function path() return Path.join(["wish", wish.wish_hashid, "edit"]);
    override function render() return super.render();

    override function requiredSignin() return true;

    override function bodyClasses() return super.bodyClasses().concat(["page-edit-wish"]);

    override function bodyAttributes() {
        var attrs = super.bodyAttributes();
        var wishCopy = Reflect.copy(wish);
        wishCopy.supporters = null; // we shouldn't reveal the supporters until the wish is completed
        attrs["data-wish"] = haxe.Serializer.run(wishCopy);
        return attrs;
    }

    var wish(get, never):giffon.db.Wish;
    function get_wish():giffon.db.Wish return props.wish;

    override function bodyContent() return jsx('
        <div className="container">
        
            <h1 className="font_xs_xl font_md_3xl fontw-700 text-center my-3 my-md-5">${language.editWish()}</h1>
            
                <div className="col-12 col-md-10 col-lg-9 mx-auto">
                    <div id="edit-wish-root" className="font_xs_s font_md_m"></div>
                </div>
            
        </div>
    ');
}