package giffon.browser;

import haxe.io.*;
import js.Browser.*;
import react.*;

class PageMakeAWish {
    static public function onReady():Void {
        ReactDOM.render(React.createElement(WishForm, {
            submissionUrl: Path.join([BrowserMain.instance.base, "make-a-wish"]),
        }), document.getElementById("make-a-wish-root"));
    }
}
