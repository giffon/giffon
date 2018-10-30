package js.npm.jasmine;

import haxe.Constraints;

extern class Clock {
    public function install():Clock;
    public function mockDate(?initialDate:Dynamic):Void;
    public function tick(millis:Int):Void;
    public function uninstall():Void;
    public function withMock(func:Function):Void;
}