package test;

import js.npm.jasmine.Global.*;
import test.Test.Global.*;

@:native("global")
extern class Global {
    static public var browser:Dynamic;
}

class Test {
    static function main():Void {
        describe("front page", function() {
            it('should display Giffon', function() {
                browser.url("/");
                browser.pause(1000);
                trace(browser.getText('h1=Giffon'));
            });
        });
    }
}