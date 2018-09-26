import js.*;
import js.Browser.*;
import js.jquery.JQuery;
import haxe.*;

class BrowserMain {
    static function main():Void {
        new BrowserMain();
    }

    public function new():Void {
        new JQuery(onReady);
    }

    function onReady():Void {
        var localStorage = js.Browser.getLocalStorage();
        var urlParams = new js.html.URLSearchParams(window.location.search);
        switch (urlParams.get("beta")) {
            case null:
                //pass
            case "1":
                localStorage.setItem("beta", "1");
            case _:
                localStorage.removeItem("beta");
        }
        if (localStorage.getItem("beta") == "1") {
            new JQuery("body")
                .addClass("beta");
        }

        if (location.hash == "#_=_") {
            removeHash();
        }
    }

    static function removeHash():Void { 
        var scrollV, scrollH, loc = window.location;
        if (window.history.pushState != null) {
            window.history.pushState("", document.title, loc.pathname + loc.search);
        } else {
            // Prevent scrolling by storing the page's current scroll offset
            scrollV = document.body.scrollTop;
            scrollH = document.body.scrollLeft;

            loc.hash = "";

            // Restore the scroll offset, should be flicker free
            document.body.scrollTop = scrollV;
            document.body.scrollLeft = scrollH;
        }
    }
}