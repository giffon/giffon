package auth0;

/*
    Lock v11 for Web
    https://auth0.com/docs/libraries/lock/v11/api
*/

extern class Auth0Lock {
    public function new(clientID:String, domain:String, ?options:Dynamic):Void;
    public function getUserInfo(accessToken:String, callback:Dynamic):Void;
    public function show(options:Dynamic):Void;
    public function hide():Void;
    public function on(event:String, callback:Dynamic):Void;
    public function resumeAuth(hash:String, callb:Dynamic):Void;
    public function checkSession(options:String, callback:Dynamic):Void;
    public function logout(options:Dynamic):Void;
}