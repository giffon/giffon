package js.npm.jasmine;

import haxe.Constraints;

typedef Configuration = {
    @:optional public var failFast:Bool;
    @:optional public var hideDisabled:Bool;
    @:optional public var oneFailurePerSpec:Bool;
    @:optional public var random:Bool;
    @:optional public var seed:Function;
    @:optional public var specFilter:Function;
}

extern class Env {
    public function addReporter(reporterToAdd:Reporter):Void;
    public function clearReporters():Void;
    public function configuration():Configuration;
    public function configure(configuration:Configuration):Void;
    public function hideDisabled():Void;
    public function provideFallbackReporter(reporterToAdd:Reporter):Void;
    public function randomizeTests(value:Bool):Void;
    public function seed(value:Float):Void;
    public function stopOnSpecFailure(value:Bool):Void;
    public function throwOnExpectationFailure(value:Bool):Void;
}