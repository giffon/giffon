package test;

import utest.Assert;
import selenium.webdriver.*;
import selenium.webdriver.remote.webelement.*;

typedef BrowserLog = {
    level:String,
    message:String,
    timestamp:Int,
    source:String,
}

class SeleniumTools {
    static public function find_visible_elements_by_css_selector(driver:Remote, selector:String):Array<WebElement> {
        var elements:Array<WebElement> = driver.find_elements_by_css_selector(selector);
        return elements.filter(function(e) return e.is_displayed());
    }

    static public function assertNoLog(driver:Remote, ?pos:haxe.PosInfos):Void {
        var logs:Array<python.Dict<String, Dynamic>> = driver.get_log("browser");
        var logLines:Array<String> = [
            for (log in (logs.map(python.Lib.dictAsAnon):Array<BrowserLog>))
            '${log.level} ${log.source} ${log.message}'
        ];
        if (logs.length > 0)
            Assert.warn('unexpected browser log:\n${logLines.join("\n")}');
        clearLog(driver);
    }

    static public function clearLog(driver:Remote):Void {
        driver.get_log("browser");
    }

    static public function assertBodyNoHorizontalScrollbar(driver:Remote, ?pos:haxe.PosInfos):Void {
        // we want to wait because it's possible that the page's layout has not finish
        waitUntil(function(){
            var scrollLeft = driver.execute_script("document.scrollingElement.scrollLeft = 1; return document.scrollingElement.scrollLeft;");
            return scrollLeft == 0;
        }, "horizontal scrollbar detected", pos);
    }

    static public function clearInput(input:WebElement):Void {
        var existingValue = Std.string(input.get_property("value"));
        input.send_keys([[for (i in 0...existingValue.length) String.fromCharCode(57347)]]);
    }

    static public function waitUntil(fn:Void->Bool, timeoutSeconds:Float = 5.0, ?msg:String, ?pos:haxe.PosInfos) {
        var fn = function() return try fn() catch(e:Dynamic) false;
        var t = Sys.time();
        while (!fn()) {
            Sys.sleep(0.1);
            if (Sys.time() - t > timeoutSeconds) {
                Assert.isTrue(fn(), msg != null ? msg : "timeout", pos);
                return;
            }
        }
    }

    static public function waitExists(fn:Void->WebElement, timeoutSeconds:Float = 5.0, ?pos:haxe.PosInfos):WebElement {
        var fn = function() return try fn() catch(e:Dynamic) null;
        var t = Sys.time();
        var e = null;
        while ((e = fn()) == null) {
            Sys.sleep(0.1);
            if (Sys.time() - t > timeoutSeconds) {
                Assert.notNull(e = fn(), "timeout", pos);
                break;
            }
        }
        return e;
    }
}
