package js.npm.aws_sdk;

import haxe.Constraints;

@:jsRequire("aws-sdk", "S3")
extern class S3 {
    public function new(?options:Dynamic):Void;
    public function upload(?params:Dynamic, ?options:Dynamic, ?callback:Dynamic):ManagedUpload;
}

@:jsRequire("aws-sdk", "S3.ManagedUpload")
extern class ManagedUpload {
    public function new(?options:Dynamic):Void;
    public function abort():Void;
    public function promise():js.Promise<Dynamic>;
    public function send(callback:Function):Void;
}