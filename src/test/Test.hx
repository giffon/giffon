package test;

import js.npm.jasmine.Global.*;
import js.npm.webdriverio.Global.*;
using StringTools;

class Test {
    static function main():Void {
        var baseUrl = js.node.Url.parse(browser.options.baseUrl);

        describe("front page", function() {
            it('should display Giffon', function() {
                browser.url("/");
                expect(browser.waitForExist('h1=Giffon')).toBe(true);
            });
        });

        describe("log in", function() {
            it('should log in successfully with the sign in link', function() {
                browser.url("/");
                expect(browser.waitForExist(".signInBtn")).toBe(true);
                browser.click(".signInBtn");
                browser.waitUntil(function(){
                    var url = browser.getUrl();
                    return url.startsWith("https://www.facebook.com/login.php");
                });
                browser.click("#email");
                browser.setValue("#email", FacebookTestUsers.user1.email);
                browser.click("#pass");
                browser.setValue("#pass", FacebookTestUsers.user1.password);
                browser.submitForm("#login_form");
                browser.waitUntil(function(){
                    var url = js.node.Url.parse(browser.getUrl());
                    return url.hostname == baseUrl.hostname;
                });
                browser.waitForVisible(".user-name");
                expect(browser.getText(".user-name")).toBe("Open Graph Test User");
            });
        });
    }
}