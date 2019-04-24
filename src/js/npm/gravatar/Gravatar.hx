package js.npm.gravatar;

@:jsRequire("gravatar")
extern class Gravatar {
    static public function url(email:String, ?options:Dynamic, ?protocol:Dynamic):String;
    static public function profile_url(email:String, ?options:Dynamic, ?protocol:Dynamic):String;
}