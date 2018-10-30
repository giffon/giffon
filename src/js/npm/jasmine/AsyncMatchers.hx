package js.npm.jasmine;

import js.Promise;

extern class AsyncMatchers {
    public var not:AsyncMatchers;
    public function toBeRejected():Promise<Dynamic>;
    public function toBeRejectedWith(expected:Dynamic):Promise<Dynamic>;
    public function toBeResolved():Promise<Dynamic>;
    public function toBeResolvedTo(expected:Dynamic):Promise<Dynamic>;
    public function withContext(message:String):AsyncMatchers;
}