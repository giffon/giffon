package test;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;
import haxe.io.*;
import selenium.webdriver.*;
import selenium.webdriver.support.ui.Select;
import selenium.webdriver.remote.switch_to.SwitchTo;
import selenium.webdriver.remote.webelement.*;
import python.*;
import giffon.Utils.*;
import thx.Decimal;
using Lambda;
using StringTools;
using test.SeleniumTest.SeleniumTools;

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
}

class SeleniumTest extends utest.Test {
    static function __init__() {
        Dotenv.load_dotenv(Path.join([Sys.getCwd(), "private", ".env"]));
    }

    static var webHost(default, never) = env("WEB_HOST", 
        switch (Sys.systemName()) {
            case "Windows", "Mac":
                "host.docker.internal";
            default:
                var ifs:Array<String> = Netifaces.interfaces();
                if (!ifs.has("docker0")) {
                    "localhost";
                } else {
                    var docker0Addresses = Netifaces.ifaddresses("docker0");
                    tee(docker0Addresses)[Netifaces.AF_INET].addr;
                }
        }
    );
    static var baseUrl(default, never) = 'https://${webHost}:3000';
    static var hubHost(default, never) = env("HUB_HOST", "localhost");
    static var hubUrl(default, never) = 'http://${hubHost}:4444/wd/hub';

    var driver:Remote;

    var user1Wish = {
        wishTitle: "Learn Haxe",
        items: [{
            itemUrl: "https://www.amazon.com/Haxe-Development-Essentials-Jeremy-McCurdy/dp/1785289780",
            itemName: "Haxe Game Development Essentials",
            itemPrice: Decimal.fromFloat(24.99),
            itemQuantity: 1,
        }],
        wishDescription: "I believe Haxe is the future!",
    };

    function setupClass():Void {
        var opts = new ChromeOptions();
        opts.add_argument("--disable-dev-shm-usage");
        opts.set_capability("acceptSslCerts", true);
        driver = new Remote(hubUrl, opts.to_capabilities());
    }

    function teardownClass():Void {
        driver.quit();
    }

    function waitUntil(fn:Void->Bool, timeoutSeconds:Float = 5.0, ?pos:haxe.PosInfos) {
        var fn = function() return try fn() catch(e:Dynamic) false;
        var t = Sys.time();
        while (!fn()) {
            Sys.sleep(0.1);
            if (Sys.time() - t > timeoutSeconds) {
                Assert.isTrue(fn(), "timeout", pos);
                return;
            }
        }
    }

    function waitExists(fn:Void->WebElement, timeoutSeconds:Float = 5.0, ?pos:haxe.PosInfos):WebElement {
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

    function signIn(user:{
        email:String,
        password:String,
        name:String
    }):Void {
        driver.get(Path.join([baseUrl, "signin", "facebook"]));

        waitUntil(function(){
            var url:String = driver.current_url;
            return url.startsWith("https://www.facebook.com/login.php");
        });

        var emailInput:WebElement = driver.find_element_by_css_selector("body #email");
        emailInput.click();
        emailInput.send_keys([user.email]);
        var passInput:WebElement = driver.find_element_by_css_selector("body #pass");
        passInput.click();
        passInput.send_keys([user.password]);
        var loginBtn:WebElement = driver.find_element_by_css_selector("body #loginbutton");
        loginBtn.click();

        waitUntil(function(){
            var url:String = driver.current_url;
            return url.startsWith(baseUrl);
        });
        assertNoLog();

        var body:WebElement = driver.find_element_by_tag_name("body");
        var cls:String = body.get_attribute("class");
        Assert.stringContains("signed-in", cls);

        var userNameElement:WebElement = driver.find_element_by_class_name("user-name");
        Assert.equals(user.name, userNameElement.text);
    }

    function signOut():Void {
        driver.get(Path.join([baseUrl, "signout"]));
        assertNoLog();
        var body:WebElement = driver.find_element_by_tag_name("body");
        var cls:String = body.get_attribute("class");
        Assert.stringContains("signed-out", cls);

        driver.get("https://facebook.com/");
        driver.delete_all_cookies();
        driver.refresh();
        driver.find_element_by_css_selector("body #email");

        // consume the facebook logs to keep the console empty
        driver.get_log("browser");
    }

    static function clearInput(input:WebElement) {
        var existingValue = Std.string(input.get_property("value"));
        input.send_keys([[for (i in 0...existingValue.length) String.fromCharCode(57347)]]);
    }

    function createWish(wish:{
        wishTitle: String,
        items: Array<{
            itemName: String,
            itemUrl: String,
            itemPrice: Decimal,
            itemQuantity: Int,
        }>,
        wishDescription: String,
    }) {
        driver.get(Path.join([baseUrl, "make-a-wish"]));
        assertNoLog();

        var titleInput:WebElement = driver.find_element_by_css_selector("input[name='wish_title']");
        titleInput.click();
        clearInput(titleInput);
        titleInput.send_keys([wish.wishTitle]);

        var currencySelect:Select = new Select(driver.find_element_by_css_selector("select[name='wish_currency']"));
        currencySelect.select_by_value(giffon.db.Currency.USD.getName());

        for (i in 0...wish.items.length) {
            var item = wish.items[i];

            var itemNameInput:WebElement = driver.find_element_by_css_selector('input[name="items[${i}].item_name"]');
            itemNameInput.click();
            itemNameInput.send_keys([item.itemName]);

            var itemUrlInput:WebElement = driver.find_element_by_css_selector('input[name="items[${i}].item_url"]');
            itemUrlInput.click();
            itemUrlInput.send_keys([item.itemUrl]);

            var itemPriceInput:WebElement = driver.find_element_by_css_selector('input[name="items[${i}].item_price"]');
            itemPriceInput.click();
            clearInput(itemPriceInput);
            itemPriceInput.send_keys([item.itemPrice.toString()]);

            var itemQuantityInput:WebElement = driver.find_element_by_css_selector('input[name="items[${i}].item_quantity"]');
            itemQuantityInput.click();
            clearInput(itemQuantityInput);
            itemQuantityInput.send_keys([Std.string(item.itemQuantity)]);

            if (i + 1 < wish.items.length) {
                // click add item btn
                var addItemBtn:WebElement = driver.find_element_by_css_selector("button.btn-add-item");
                addItemBtn.click();
            }
        }

        var wishDescriptionArea:WebElement = driver.find_element_by_css_selector('textarea[name="wish_description"]');
        wishDescriptionArea.click();
        wishDescriptionArea.send_keys([wish.wishDescription]);

        var acceptTermsInput:WebElement = driver.find_element_by_css_selector("input[name='acceptTerms']");
        acceptTermsInput.click();

        var submitBtn:WebElement = driver.find_element_by_css_selector("button[type='submit']");
        submitBtn.click();

        waitUntil(function(){
            var url:String = driver.current_url;
            return url.indexOf('/make-a-wish') == -1;
        });
        // assertNoLog(); TODO
        clearLog();
    }

    function clearLog():Void {
        driver.get_log("browser");
    }

    function assertNoLog(?pos:haxe.PosInfos):Void {
        var logs:Array<python.Dict<String, Dynamic>> = driver.get_log("browser");
        var logLines:Array<String> = [
            for (log in (logs.map(python.Lib.dictAsAnon):Array<BrowserLog>))
            '${log.level} ${log.source} ${log.message}'
        ];
        Assert.equals(0, logs.length, 'unexpected browser log:\n${logLines.join("\n")}', pos);
    }

    function testSimple():Void {
        driver.get(baseUrl);
        Assert.stringContains("Giffon", driver.title);
        assertNoLog();
    }

    function testBasics():Void {
        signIn(FacebookTestUsers.user1);
        createWish(user1Wish);

        driver.get(baseUrl);
        assertNoLog();

        // go to user page
        var userLink:WebElement = driver.find_element_by_css_selector("a.nav-link.user-name");
        var userUrl:String = userLink.get_attribute("href");
        Assert.match(~/\/user\?id=[A-Za-z0-9]+$/, userUrl);
        Assert.isTrue(userUrl.startsWith(baseUrl));
        driver.get(userUrl);
        assertNoLog();

        // go to wish page
        var wishLink:WebElement = driver.find_element_by_link_text(user1Wish.wishTitle);
        var wishUrl:String = wishLink.get_attribute("href");
        Assert.match(~/\/wish\/[A-Za-z0-9]+$/, wishUrl);
        Assert.isTrue(wishUrl.startsWith(baseUrl));
        

        // check wish page content
        function checkWish(signedInUser:Null<String>) {
            driver.get(wishUrl);
            assertNoLog();

            Assert.stringContains(user1Wish.wishTitle, driver.title);
            Assert.stringContains(FacebookTestUsers.user1.name, driver.title);

            for (item in user1Wish.items) {
                var itemLink:WebElement = driver.find_element_by_link_text(item.itemName);
                Assert.equals(item.itemUrl, itemLink.get_attribute("href"));
            }

            var body:WebElement = driver.find_element_by_tag_name("body");
            var dataWishTotalNeeded:String = body.get_attribute("data-wish-total-needed");
            Assert.isTrue(Decimal.fromString(dataWishTotalNeeded) > user1Wish.items[0].itemPrice);

            if (signedInUser == FacebookTestUsers.user1.name) {
                var cancelBtn = waitExists(function(){
                    return driver.find_visible_elements_by_css_selector("button.cancel-wish-btn")[0];
                });
                if (cancelBtn == null) return;

                var editBtn = waitExists(function(){
                    return driver.find_visible_elements_by_css_selector("a[href$='/edit']")[0];
                });
                if (editBtn == null) return;

                var couponForm = waitExists(function(){
                    return driver.find_visible_elements_by_css_selector("form.apply-coupon-form")[0];
                });
                if (couponForm == null) return;
            } else {
                var cancelBtns:Array<WebElement> = driver.find_visible_elements_by_css_selector("button.cancel-wish-btn");
                Assert.equals(0, cancelBtns.length);

                var editBtns:Array<WebElement> = driver.find_visible_elements_by_css_selector("a[href$='/edit']");
                Assert.equals(0, editBtns.length);

                var couponForms:Array<WebElement> = driver.find_visible_elements_by_css_selector("form.apply-coupon-form");
                Assert.equals(0, couponForms.length);
            }
        }
        checkWish(FacebookTestUsers.user1.name);

        signOut();

        checkWish(null);

        signIn(FacebookTestUsers.user2);

        checkWish(FacebookTestUsers.user2.name);

        // pledge

        var amountInput = waitExists(function(){
            return driver.find_element_by_css_selector("input[name='pledge_amount']");
        });
        if (amountInput == null) return;
        clearInput(amountInput);
        amountInput.send_keys(["5"]);

        (driver.switch_to:SwitchTo).frame(driver.find_element_by_css_selector("#card-number iframe"));
        var cardnumberInput = waitExists(function(){
            return driver.find_element_by_css_selector("input[name='cardnumber']");
        });
        if (cardnumberInput == null) return;
        var cardnumberValue = "";
        do {
            clearInput(cardnumberInput);
            cardnumberInput.send_keys(["4242 4242 4242 4242"]);
            cardnumberValue = cardnumberInput.get_property("value");
        } while (cardnumberValue != "4242 4242 4242 4242");
        var expDateInput:WebElement = driver.find_element_by_css_selector("input[name='exp-date']");
        expDateInput.send_keys(["0424"]);
        var cvcInput:WebElement = driver.find_element_by_css_selector("input[name='cvc']");
        cvcInput.send_keys(["444"]);
        var postalInput:WebElement = driver.find_element_by_css_selector("input[name='postal']");
        postalInput.send_keys(["00000"]);
        (driver.switch_to:SwitchTo).parent_frame();

        var termsInput:WebElement = driver.find_element_by_css_selector("input[name='acceptTerms']");
        termsInput.click();

        var submitBtn:WebElement = driver.find_element_by_css_selector("button[type='submit']");
        submitBtn.click();


        waitUntil(function(){
            var body:WebElement = driver.find_element_by_tag_name("body");
            var dataUserSupport:String = body.get_attribute("data-user-support");
            var userSupport:Null<giffon.db.Wish.WishSupport> = haxe.Unserializer.run(dataUserSupport);
            return userSupport != null && userSupport.pledge_amount == 5;
        });
        assertNoLog();

        // cancel pledge

        var cancelBtn = waitExists(function(){
            return driver.find_element_by_css_selector("button.btn-cancel-pledge");
        });
        if (cancelBtn == null) return;
        cancelBtn.click();

        waitUntil(function(){
            var body:WebElement = driver.find_element_by_tag_name("body");
            var dataUserSupport:String = body.get_attribute("data-user-support");
            var userSupport:Null<giffon.db.Wish.WishSupport> = haxe.Unserializer.run(dataUserSupport);
            return userSupport == null;
        });
        assertNoLog();

        waitExists(function(){
            return driver.find_element_by_css_selector("input[name='pledge_amount']");
        });
    }

    static function main():Void {
        utest.UTest.run([new SeleniumTest()]);
    }
}