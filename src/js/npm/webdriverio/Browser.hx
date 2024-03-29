package js.npm.webdriverio;

import haxe.Constraints;
import haxe.extern.*;

extern class Browser {
    public function addValue(rest:Rest<Dynamic>):Dynamic;
    public function clearElement(rest:Rest<Dynamic>):Dynamic;
    public function click(selector:String):Dynamic;
    public function doubleClick(rest:Rest<Dynamic>):Dynamic;
    public function dragAndDrop(rest:Rest<Dynamic>):Dynamic;
    public function leftClick(rest:Rest<Dynamic>):Dynamic;
    public function middleClick(rest:Rest<Dynamic>):Dynamic;
    public function moveToObject(rest:Rest<Dynamic>):Dynamic;
    public function rightClick(rest:Rest<Dynamic>):Dynamic;
    public function selectByAttribute(rest:Rest<Dynamic>):Dynamic;
    public function selectByIndex(rest:Rest<Dynamic>):Dynamic;
    public function selectByValue(rest:Rest<Dynamic>):Dynamic;
    public function selectByVisibleText(rest:Rest<Dynamic>):Dynamic;
    public function selectorExecute(rest:Rest<Dynamic>):Dynamic;
    public function selectorExecuteAsync(rest:Rest<Dynamic>):Dynamic;
    public function setValue(selector:String, values:Dynamic):Dynamic;
    public function submitForm(selector:String):Dynamic;
    public function deleteCookie(?name:String):Dynamic;
    public function getCookie(rest:Rest<Dynamic>):Dynamic;
    public function setCookie(rest:Rest<Dynamic>):Dynamic;
    public function getGridNodeDetails(rest:Rest<Dynamic>):Dynamic;
    public function gridProxyDetails(rest:Rest<Dynamic>):Dynamic;
    public function gridTestSession(rest:Rest<Dynamic>):Dynamic;
    public function background(rest:Rest<Dynamic>):Dynamic;
    public function closeApp(rest:Rest<Dynamic>):Dynamic;
    public function context(rest:Rest<Dynamic>):Dynamic;
    public function contexts(rest:Rest<Dynamic>):Dynamic;
    public function currentActivity(rest:Rest<Dynamic>):Dynamic;
    public function deviceKeyEvent(rest:Rest<Dynamic>):Dynamic;
    public function getAppStrings(rest:Rest<Dynamic>):Dynamic;
    public function getCurrentDeviceActivity(rest:Rest<Dynamic>):Dynamic;
    public function getCurrentPackage(rest:Rest<Dynamic>):Dynamic;
    public function getDeviceTime(rest:Rest<Dynamic>):Dynamic;
    public function getGeoLocation(rest:Rest<Dynamic>):Dynamic;
    public function getNetworkConnection(rest:Rest<Dynamic>):Dynamic;
    public function getOrientation(rest:Rest<Dynamic>):Dynamic;
    public function hideDeviceKeyboard(rest:Rest<Dynamic>):Dynamic;
    public function hold(rest:Rest<Dynamic>):Dynamic;
    public function installApp(rest:Rest<Dynamic>):Dynamic;
    public function isAppInstalled(rest:Rest<Dynamic>):Dynamic;
    public function isLocked(rest:Rest<Dynamic>):Dynamic;
    public function launch(rest:Rest<Dynamic>):Dynamic;
    public function lock(rest:Rest<Dynamic>):Dynamic;
    public function longPressKeycode(rest:Rest<Dynamic>):Dynamic;
    public function openNotifications(rest:Rest<Dynamic>):Dynamic;
    public function orientation(rest:Rest<Dynamic>):Dynamic;
    public function performMultiAction(rest:Rest<Dynamic>):Dynamic;
    public function performTouchAction(rest:Rest<Dynamic>):Dynamic;
    public function pressKeycode(rest:Rest<Dynamic>):Dynamic;
    public function pullFile(rest:Rest<Dynamic>):Dynamic;
    public function pullFolder(rest:Rest<Dynamic>):Dynamic;
    public function pushFile(rest:Rest<Dynamic>):Dynamic;
    public function release(rest:Rest<Dynamic>):Dynamic;
    public function removeApp(rest:Rest<Dynamic>):Dynamic;
    public function reset(rest:Rest<Dynamic>):Dynamic;
    public function rotate(rest:Rest<Dynamic>):Dynamic;
    public function setGeoLocation(rest:Rest<Dynamic>):Dynamic;
    public function setImmediateValue(rest:Rest<Dynamic>):Dynamic;
    public function setNetworkConnection(rest:Rest<Dynamic>):Dynamic;
    public function setOrientation(rest:Rest<Dynamic>):Dynamic;
    public function settings(rest:Rest<Dynamic>):Dynamic;
    public function shake(rest:Rest<Dynamic>):Dynamic;
    public function startActivity(rest:Rest<Dynamic>):Dynamic;
    public function strings(rest:Rest<Dynamic>):Dynamic;
    public function swipe(rest:Rest<Dynamic>):Dynamic;
    public function swipeDown(rest:Rest<Dynamic>):Dynamic;
    public function swipeLeft(rest:Rest<Dynamic>):Dynamic;
    public function swipeRight(rest:Rest<Dynamic>):Dynamic;
    public function swipeUp(rest:Rest<Dynamic>):Dynamic;
    public function toggleAirplaneMode(rest:Rest<Dynamic>):Dynamic;
    public function toggleData(rest:Rest<Dynamic>):Dynamic;
    public function toggleLocationServices(rest:Rest<Dynamic>):Dynamic;
    public function toggleTouchIdEnrollment(rest:Rest<Dynamic>):Dynamic;
    public function toggleWiFi(rest:Rest<Dynamic>):Dynamic;
    public function touch(rest:Rest<Dynamic>):Dynamic;
    public function touchAction(rest:Rest<Dynamic>):Dynamic;
    public function touchId(rest:Rest<Dynamic>):Dynamic;
    public function touchMultiPerform(rest:Rest<Dynamic>):Dynamic;
    public function touchPerform(rest:Rest<Dynamic>):Dynamic;
    public function unlock(rest:Rest<Dynamic>):Dynamic;
    public function getAttribute(selector:String, attributeName:String):Dynamic;
    public function getCssProperty(rest:Rest<Dynamic>):Dynamic;
    public function getElementSize(rest:Rest<Dynamic>):Dynamic;
    public function getHTML(selector:String, ?includeSelectorTag:Bool):String;
    public function getLocation(rest:Rest<Dynamic>):Dynamic;
    public function getLocationInView(rest:Rest<Dynamic>):Dynamic;
    public function getSource(rest:Rest<Dynamic>):Dynamic;
    public function getTagName(rest:Rest<Dynamic>):Dynamic;
    public function getText(selector:String):Dynamic;
    public function getTitle(rest:Rest<Dynamic>):Dynamic;
    public function getUrl():String;
    public function getValue(rest:Rest<Dynamic>):Dynamic;
    public function actions(rest:Rest<Dynamic>):Dynamic;
    public function alertAccept(rest:Rest<Dynamic>):Dynamic;
    public function alertDismiss(rest:Rest<Dynamic>):Dynamic;
    public function alertText(rest:Rest<Dynamic>):Dynamic;
    public function applicationCacheStatus(rest:Rest<Dynamic>):Dynamic;
    public function back(rest:Rest<Dynamic>):Dynamic;
    public function buttonDown(rest:Rest<Dynamic>):Dynamic;
    public function buttonPress(rest:Rest<Dynamic>):Dynamic;
    public function buttonUp(rest:Rest<Dynamic>):Dynamic;
    public function cookie(rest:Rest<Dynamic>):Dynamic;
    public function doDoubleClick(rest:Rest<Dynamic>):Dynamic;
    public function element(rest:Rest<Dynamic>):Dynamic;
    public function elementActive(rest:Rest<Dynamic>):Dynamic;
    public function elementIdAttribute(rest:Rest<Dynamic>):Dynamic;
    public function elementIdClear(rest:Rest<Dynamic>):Dynamic;
    public function elementIdClick(rest:Rest<Dynamic>):Dynamic;
    public function elementIdCssProperty(rest:Rest<Dynamic>):Dynamic;
    public function elementIdDisplayed(rest:Rest<Dynamic>):Dynamic;
    public function elementIdElement(rest:Rest<Dynamic>):Dynamic;
    public function elementIdElements(rest:Rest<Dynamic>):Dynamic;
    public function elementIdEnabled(rest:Rest<Dynamic>):Dynamic;
    public function elementIdLocation(rest:Rest<Dynamic>):Dynamic;
    public function elementIdLocationInView(rest:Rest<Dynamic>):Dynamic;
    public function elementIdName(rest:Rest<Dynamic>):Dynamic;
    public function elementIdProperty(rest:Rest<Dynamic>):Dynamic;
    public function elementIdRect(rest:Rest<Dynamic>):Dynamic;
    public function elementIdScreenshot(rest:Rest<Dynamic>):Dynamic;
    public function elementIdSelected(rest:Rest<Dynamic>):Dynamic;
    public function elementIdSize(rest:Rest<Dynamic>):Dynamic;
    public function elementIdText(rest:Rest<Dynamic>):Dynamic;
    public function elementIdValue(rest:Rest<Dynamic>):Dynamic;
    public function elements(selector:String):{
        selector: String,
        value: Array<Dynamic>
    };
    public function execute(rest:Rest<Dynamic>):Dynamic;
    public function executeAsync(rest:Rest<Dynamic>):Dynamic;
    public function file(rest:Rest<Dynamic>):Dynamic;
    public function forward(rest:Rest<Dynamic>):Dynamic;
    public function frame(id:Dynamic):Dynamic;
    public function frameParent():Dynamic;
    public function imeActivate(rest:Rest<Dynamic>):Dynamic;
    public function imeActivated(rest:Rest<Dynamic>):Dynamic;
    public function imeActiveEngine(rest:Rest<Dynamic>):Dynamic;
    public function imeAvailableEngines(rest:Rest<Dynamic>):Dynamic;
    public function imeDeactivated(rest:Rest<Dynamic>):Dynamic;
    public function init(rest:Rest<Dynamic>):Dynamic;
    public function keys(rest:Rest<Dynamic>):Dynamic;
    public function localStorage(rest:Rest<Dynamic>):Dynamic;
    public function localStorageSize(rest:Rest<Dynamic>):Dynamic;
    public function location(rest:Rest<Dynamic>):Dynamic;
    public function log(rest:Rest<Dynamic>):Dynamic;
    public function logTypes(rest:Rest<Dynamic>):Dynamic;
    public function moveTo(rest:Rest<Dynamic>):Dynamic;
    public function refresh():Dynamic;
    public function screenshot(rest:Rest<Dynamic>):Dynamic;
    public function session(rest:Rest<Dynamic>):Dynamic;
    public function sessionStorage(rest:Rest<Dynamic>):Dynamic;
    public function sessionStorageSize(rest:Rest<Dynamic>):Dynamic;
    public function sessions(rest:Rest<Dynamic>):Dynamic;
    public function source(rest:Rest<Dynamic>):Dynamic;
    public function status(rest:Rest<Dynamic>):Dynamic;
    public function submit(rest:Rest<Dynamic>):Dynamic;
    public function timeouts(rest:Rest<Dynamic>):Dynamic;
    public function timeoutsAsyncScript(rest:Rest<Dynamic>):Dynamic;
    public function timeoutsImplicitWait(rest:Rest<Dynamic>):Dynamic;
    public function title(rest:Rest<Dynamic>):Dynamic;
    public function touchClick(rest:Rest<Dynamic>):Dynamic;
    public function touchDown(rest:Rest<Dynamic>):Dynamic;
    public function touchFlick(rest:Rest<Dynamic>):Dynamic;
    public function touchLongClick(rest:Rest<Dynamic>):Dynamic;
    public function touchMove(rest:Rest<Dynamic>):Dynamic;
    public function touchScroll(rest:Rest<Dynamic>):Dynamic;
    public function touchUp(rest:Rest<Dynamic>):Dynamic;
    public function url(?url:String):String;
    public function window(rest:Rest<Dynamic>):Dynamic;
    public function windowHandle(rest:Rest<Dynamic>):Dynamic;
    public function windowHandleFullscreen(rest:Rest<Dynamic>):Dynamic;
    public function windowHandleMaximize(rest:Rest<Dynamic>):Dynamic;
    public function windowHandlePosition(rest:Rest<Dynamic>):Dynamic;
    public function windowHandleSize(rest:Rest<Dynamic>):Dynamic;
    public function windowHandles(rest:Rest<Dynamic>):Dynamic;
    public function hasFocus(rest:Rest<Dynamic>):Dynamic;
    public function isEnabled(rest:Rest<Dynamic>):Dynamic;
    public function isExisting(rest:Rest<Dynamic>):Dynamic;
    public function isSelected(rest:Rest<Dynamic>):Dynamic;
    public function isVisible(rest:Rest<Dynamic>):Dynamic;
    public function isVisibleWithinViewport(rest:Rest<Dynamic>):Dynamic;
    public function addCommand(rest:Rest<Dynamic>):Dynamic;
    public function call(rest:Rest<Dynamic>):Dynamic;
    public function chooseFile(rest:Rest<Dynamic>):Dynamic;
    public function debug(rest:Rest<Dynamic>):Dynamic;
    public function end(rest:Rest<Dynamic>):Dynamic;
    public function endAll(rest:Rest<Dynamic>):Dynamic;
    public function getCommandHistory(rest:Rest<Dynamic>):Dynamic;
    public function pause(rest:Rest<Dynamic>):Dynamic;
    public function reload(rest:Rest<Dynamic>):Dynamic;
    public function saveScreenshot(rest:Rest<Dynamic>):Dynamic;
    public function scroll(rest:Rest<Dynamic>):Dynamic;
    public function uploadFile(rest:Rest<Dynamic>):Dynamic;
    public function waitForEnabled(rest:Rest<Dynamic>):Dynamic;
    public function waitForExist(selector:String, ?ms:Float, ?reverse:Bool):Bool;
    public function waitForSelected(rest:Rest<Dynamic>):Dynamic;
    public function waitForText(rest:Rest<Dynamic>):Dynamic;
    public function waitForValue(rest:Rest<Dynamic>):Dynamic;
    public function waitForVisible(selector:String, ?ms:Float, ?reverse:Bool):Bool;
    public function waitUntil(condition:Function, ?timeout:Float, ?timeoutMsg:String, ?interval:Float):Dynamic;
    public function close(rest:Rest<Dynamic>):Dynamic;
    public function getCurrentTabId(rest:Rest<Dynamic>):Dynamic;
    public function getTabIds(rest:Rest<Dynamic>):Dynamic;
    public function getViewportSize(rest:Rest<Dynamic>):Dynamic;
    public function newWindow(rest:Rest<Dynamic>):Dynamic;
    public function setViewportSize(rest:Rest<Dynamic>):Dynamic;
    public function switchTab(rest:Rest<Dynamic>):Dynamic;

    public var desiredCapabilities:Dynamic;
    public var requestHandler:Dynamic;
    public var logger:Dynamic;
    public var options:Dynamic;
    public var isMobile:Bool;
    public var isIOS:Bool;
    public var isAndroid:Bool;
    public var sessionId:String;
}