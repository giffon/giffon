package test;

import js.npm.jasmine.Global.*;
import js.npm.webdriverio.Global.*;
import js.node.Url;
import haxe.io.Path;
using StringTools;

class Test {
    static function __init__() {
        js.Node.require("dotenv").config({
            path: Path.join([Sys.getCwd(), "private", ".env"])
        });
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

        var user1Wish = {
            wishTitle: "Learn Haxe",
            itemUrl: "https://www.amazon.com/Haxe-Development-Essentials-Jeremy-McCurdy/dp/1785289780",
            wishUrl: null,
            itemName: "Haxe Game Development Essentials",
            itemPrice: 24.99,
            wishDescription: "I believe Haxe is the future!",
        };

        describe("basics", function() {
            it('should log in successfully', function() {
                logInUser(FacebookTestUsers.user1);
            });

            it("should be able to create new wish", function() {
                browser.url("/make-a-wish");
                expect(browser.waitForExist("#make-a-wish-root form")).toBe(true);
                browser.click("input[name='wish_title']");
                browser.clearElement("input[name='wish_title']");
                browser.setValue("input[name='wish_title']", user1Wish.wishTitle);
                browser.selectByValue("select[name='currency']", giffon.db.Currency.USD.getName());
                browser.click("input[name='items[0].item_name']");
                browser.setValue("input[name='items[0].item_name']", user1Wish.itemName);
                browser.click("input[name='items[0].item_url']");
                browser.setValue("input[name='items[0].item_url']", user1Wish.itemUrl);
                browser.click("input[name='items[0].item_price']");
                browser.setValue("input[name='items[0].item_price']", user1Wish.itemPrice);
                browser.click("textarea[name='wish_description']");
                browser.setValue("textarea[name='wish_description']", user1Wish.wishDescription);
                browser.click("input[name='acceptTerms']");
                browser.click("button[type='submit']");

                browser.waitUntil(function(){
                    var url = Url.parse(browser.getUrl());
                    return url.pathname != "/make-a-wish";
                });
            });

            it("should show wish", function() {
                browser.url("/home");
                expect(browser.waitForExist(".wish .item-name")).toBe(true);
                expect(browser.getText(".wish .item-name")).toBe(user1Wish.itemName);

                var wishUrl = user1Wish.wishUrl = browser.getAttribute(".wish a[href^='/wish/']", "href");
                expect(wishUrl).toMatch(new js.RegExp("/wish/[A-Za-z0-9]+$"));

                browser.url(wishUrl);

                expect(browser.waitForExist('.item .item-name')).toBe(true);
                expect(browser.getText(".item .item-name")).toBe(user1Wish.itemName);

                var wish_total = Std.parseFloat(browser.getText(".wish-total"));
                expect(wish_total).toBeGreaterThan(0);
                expect(wish_total).toBeLessThan(1000);

                var pledgeForms = browser.elements('form[action="${Path.join([wishUrl, "pledge"])}"]');
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

            it('should show other user\'s wish', function() {
                browser.url(user1Wish.wishUrl);

                expect(browser.waitForExist('.item .item-name')).toBe(true);
                expect(browser.getText(".item .item-name")).toBe(user1Wish.itemName);
            });

            var card_id = null;

            it('should allow user to add credit card', function() {
                browser.url("/home");

                expect(browser.waitForExist("a[href='/cards']")).toBe(true);
                browser.click("a[href='/cards']");

                browser.waitUntil(function(){
                    var url = Url.parse(browser.getUrl());
                    return url.hostname == baseUrl.hostname && url.pathname == "/cards";
                });

                expect(browser.waitForVisible("form[action='/cards']")).toBe(true);

                browser.waitForExist("#card-element iframe");
                browser.frame(browser.element("#card-element iframe").value);
                expect(browser.waitForEnabled("input[name='cardnumber']")).toBe(true);
                browser.click("input[name='cardnumber']");
                browser.setValue("input[name='cardnumber']", "4242 4242 4242 4242");
                browser.click("input[name='exp-date']");
                browser.setValue("input[name='exp-date']", "04 / 24");
                browser.click("input[name='cvc']");
                browser.setValue("input[name='cvc']", "444");
                browser.click("input[name='postal']");
                browser.setValue("input[name='postal']", "00000");

                browser.frameParent();

                browser.click("input#checkbox-terms");
                browser.click("button[type='submit']");

                expect(browser.waitForExist("span=Visa")).toBe(true);
                expect(browser.waitForExist("span=4242")).toBe(true);
                expect(browser.waitForExist("span.card-id")).toBe(true);
                card_id = browser.getHTML("span.card-id", false);
                expect(card_id).toBeTruthy();
            });

            it('should allow user to delete cards', function() {
                browser.url('/card/$card_id/delete');

                browser.waitUntil(function(){
                    var url = Url.parse(browser.getUrl());
                    return url.hostname == baseUrl.hostname && url.pathname == "/cards";
                });

                expect(browser.waitForVisible("form[action='/cards']")).toBe(true);
            });
        });
    }
}