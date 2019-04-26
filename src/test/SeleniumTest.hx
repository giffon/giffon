package test;

import utest.Assert;
import utest.Runner;
import utest.ui.Report;
import haxe.io.*;
import selenium.webdriver.*;
import selenium.webdriver.remote.webelement.*;
import python.*;
import giffon.Utils.*;
using Lambda;
using StringTools;

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
        itemUrl: "https://www.amazon.com/Haxe-Development-Essentials-Jeremy-McCurdy/dp/1785289780",
        wishUrl: null,
        itemName: "Haxe Game Development Essentials",
        itemPrice: 24.99,
        wishDescription: "I believe Haxe is the future!",
    };

    function setupClass():Void {
        driver = new Remote(hubUrl, DesiredCapabilities.CHROME);
    }

    function teardownClass():Void {
        driver.quit();
    }

    function waitUntil(fn:Void->Bool, timeoutSeconds:Float = 5.0) {
        var t = Sys.time();
        while (!fn() && (Sys.time() - t < timeoutSeconds)) {
            Sys.sleep(0.1);
        }
    }

    function logInUser(user:{
        email:String,
        password:String,
        name:String
    }):Void {
        driver.get(baseUrl);
        var signInBtn:WebElement = driver.find_element_by_class_name("signInBtn");
        Assert.isTrue(signInBtn.is_displayed());
        signInBtn.click();
        
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
        var userNameElement:WebElement = driver.find_element_by_class_name("user-name");
        Assert.equals(user.name, userNameElement.text);
    }

    function testSimple():Void {
        driver.get(baseUrl);
        Assert.stringContains("Giffon", driver.title);
    }

    function testBasics():Void {
        logInUser(FacebookTestUsers.user1);
    }

    static function main():Void {
        utest.UTest.run([new SeleniumTest()]);
    }
}