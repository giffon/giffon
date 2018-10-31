package test;

import js.npm.jasmine.Global.*;
import js.npm.webdriverio.Global.*;

class Test {
    static function main():Void {
        describe("front page ", function() {
            it('should display Giffon', function() {
                browser.url("/");
                expect(browser.waitForExist('h1=Giffon')).toBeTruthy();
            });
        });
    }
}