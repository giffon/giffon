package giffon.browser;

import js.Browser.*;
import react.*;

class PageEditWish {
    static public function onReady():Void {
        ReactDOM.render(React.createElement(WishForm, {
            wish: haxe.Unserializer.run(document.body.getAttribute("data-wish")),
            submissionUrl: document.location.pathname,
        }), document.getElementById("edit-wish-root"));
    }
}
