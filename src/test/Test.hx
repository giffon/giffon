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

    static var baseUrl(default, never) = Url.parse(browser.options.baseUrl);

    static function logInUser(user:{
        email:String,
        password:String,
        name:String
    }):Void {
        browser.url("/");
        expect(browser.waitForVisible(".signInBtn")).toBe(true);
        browser.click(".signInBtn");
        browser.waitUntil(function(){
            var url = browser.getUrl();
            return url.startsWith("https://www.facebook.com/login.php");
        });
        expect(browser.waitForVisible("body #email")).toBe(true);
        browser.click("body #email");
        browser.setValue("body #email", user.email);
        browser.click("body #pass");
        browser.setValue("body #pass", user.password);
        browser.click("body #loginbutton");
        browser.waitUntil(function(){
            var url = Url.parse(browser.getUrl());
            return url.hostname == baseUrl.hostname;
        });
        browser.waitForVisible(".user-name");
        expect(browser.getText(".user-name")).toBe(user.name);
    }

    static function main():Void {
        describe("front page", function() {
            it('should display Giffon', function() {
                browser.url("/");
                expect(browser.waitForExist('h1=Giffon')).toBe(true);
            });
        });

        var user1Campaign = {
            itemUrl: "https://www.amazon.com/Haxe-Development-Essentials-Jeremy-McCurdy/dp/1785289780",
            campaignUrl: null,
            itemName: "Haxe Game Development Essentials",
        };

        describe("basics", function() {
            it('should log in successfully', function() {
                logInUser(FacebookTestUsers.user1);
            });

            it("should be able to create new campaign", function() {
                browser.url("/create-campaign");
                expect(browser.waitForExist("form[action='/create-campaign']")).toBe(true);
                browser.click("input[name='item_url']");
                browser.setValue("input[name='item_url']", user1Campaign.itemUrl);
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
                expect(browser.getText(".campaign .item-name")).toBe(user1Campaign.itemName);

                var campaignUrl = user1Campaign.campaignUrl = browser.getAttribute(".campaign a[href^='/campaign/']", "href");
                expect(campaignUrl).toMatch(new js.RegExp("/campaign/[A-Za-z0-9]+$"));

                browser.url(campaignUrl);

                expect(browser.waitForExist('.item .item-name')).toBe(true);
                expect(browser.getText(".item .item-name")).toBe(user1Campaign.itemName);

                var campaign_total = Std.parseFloat(browser.getText(".campaign-total"));
                expect(campaign_total).toBeGreaterThan(0);
                expect(campaign_total).toBeLessThan(1000);

                var pledgeForms = browser.elements('form[action="${Path.join([campaignUrl, "pledge"])}"]');
                expect(pledgeForms.value.length).toBe(0);
            });

            it("should log out successfully", function() {
                browser.url("/home");
                expect(browser.waitForExist(".signOutBtn")).toBe(true);
                browser.click(".signOutBtn");

                browser.waitUntil(function(){
                    var url = Url.parse(browser.getUrl());
                    return url.hostname == baseUrl.hostname && url.pathname == "/";
                });

                expect(browser.waitForVisible(".signInBtn")).toBe(true);
            });

            it("should log out facebook as well", function() {
                browser.url("https://facebook.com/");
                browser.deleteCookie();
                browser.refresh();
                expect(browser.waitForVisible("body #email")).toBe(true);
            });
        });

        describe("another user", function(){
            it('should log in successfully', function() {
                logInUser(FacebookTestUsers.user2);
            });

            it('should show other user\'s campaign', function() {
                browser.url(user1Campaign.campaignUrl);

                expect(browser.waitForExist('.item .item-name')).toBe(true);
                expect(browser.getText(".item .item-name")).toBe(user1Campaign.itemName);
            });
        });
    }
}