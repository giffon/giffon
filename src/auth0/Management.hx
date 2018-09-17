package auth0;

extern class Management {
    public function new(options:{
        var domain:String;
        var token:String;
    }):Void;

    public function getUser(userId:String, callb:Dynamic):Void;

    public function patchUserMetadata(userId:String, userMetadata:Dynamic, callb:Dynamic):Void;

    public function linkUser(userId:String, secondaryUserToken:String, callb:Dynamic):Void;
}