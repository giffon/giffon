package test;

import js.npm.jasmine.Global.*;
import js.npm.webdriverio.Global.*;
import js.node.Url;
import haxe.io.Path;
using StringTools;

class Test {
    static function __init__() {
        js.Node.require("dotenv").load();
    }
    static function main():Void {
        var baseUrl = Url.parse(browser.options.baseUrl);

        describe("front page", function() {
            it('should display Giffon', function() {
                browser.url("/");
                expect(browser.waitForExist('h1=Giffon')).toBe(true);
            });
        });

        describe("basics", function() {
            it('should log in successfully with the sign in link', function() {
                browser.url("/");
                expect(browser.waitForExist(".signInBtn")).toBe(true);
                browser.click(".signInBtn");
                browser.waitUntil(function(){
                    var url = browser.getUrl();
                    return url.startsWith("https://www.facebook.com/login.php");
                });
                browser.click("body #email");
                browser.setValue("body #email", FacebookTestUsers.user1.email);
                browser.click("body #pass");
                browser.setValue("body #pass", FacebookTestUsers.user1.password);
                browser.click("body #loginbutton");
                browser.waitUntil(function(){
                    var url = Url.parse(browser.getUrl());
                    return url.hostname == baseUrl.hostname;
                });
                browser.waitForVisible(".user-name");
                expect(browser.getText(".user-name")).toBe("Open Graph Test User");
            });

            it("should be able to create new campaign", function() {
                browser.url("/create-campaign");
                expect(browser.waitForExist("form[action='/create-campaign']")).toBe(true);
                browser.click("input[name='item_url']");
                browser.setValue("input[name='item_url']", "https://www.amazon.com/Haxe-Development-Essentials-Jeremy-McCurdy/dp/1785289780");
                browser.click("textarea[name='campaign_description']");
                browser.setValue("textarea[name='campaign_description']", "I believe Haxe is the future!");
                browser.click("input#checkbox-terms");
                browser.click("button[type='submit']");

                browser.waitUntil(function(){
                    var url = Url.parse(browser.getUrl());
                    return url.pathname != "/create-campaign";
                });
            });

            it("should show campaign", function() {
                browser.url("/home");
                expect(browser.waitForExist(".campaign .item-name")).toBe(true);
                expect(browser.getText(".campaign .item-name")).toBe("Haxe Game Development Essentials");

                var campaignUrl = browser.getAttribute(".campaign a[href^='/campaign/']", "href");
                expect(campaignUrl).toMatch(new js.RegExp("/campaign/[A-Za-z0-9]+$"));

                browser.url(campaignUrl);

                expect(browser.waitForExist('.item .item-name')).toBe(true);
                expect(browser.getText(".item .item-name")).toBe("Haxe Game Development Essentials");

                var campaign_total = Std.parseFloat(browser.getText(".campaign-total"));
                expect(campaign_total).toBeGreaterThan(0);
                expect(campaign_total).toBeLessThan(1000);

                var pledgeForms = browser.elements('form[action="${Path.join([campaignUrl, "pledge"])}"]');
                expect(pledgeForms.value.length).toBe(0);
            });
        });
    }
}