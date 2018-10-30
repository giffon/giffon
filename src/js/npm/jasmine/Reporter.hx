package js.npm.jasmine;

import haxe.Constraints;

extern class Reporter {
    public function jasmineDone(suiteInfo:Dynamic, ?done:Function):Void;
    public function jasmineStarted(suiteInfo:Dynamic, ?done:Function):Void;
    public function specDone(result:Dynamic, ?done:Function):Void;
    public function specStarted(result:Dynamic, ?done:Function):Void;
    public function suiteDone(result:Dynamic, ?done:Function):Void;
    public function suiteStarted(result:Dynamic, ?done:Function):Void;
}