package giffon.browser;

import js.Browser.*;
import react.*;

class PageMakeAWish {
    static public function onReady():Void {
        ReactDOM.render(React.createElement(WishForm), document.getElementById("make-a-wish-root"));
    }
}
