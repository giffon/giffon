package auth0;

/*
    Auth0.js v9
    https://auth0.com/docs/libraries/auth0js/v9
*/

typedef WebAuthOptions = {
    var domain:String;
    var clientID:String;
    @:optional var redirectUri:String;
    @:optional var scope:String;
    @:optional var audience:String;
    @:optional var responseType:String;
    @:optional var responseMode:String;
    @:optional var leeway:Int;
    @:optional var _disableDeprecationWarnings:Bool;
}

typedef AuthorizeOptions = {
    @:optional var audience:String;
    @:optional var connection:String;
    @:optional var scope:String;
    @:optional var responseType:String;
    @:optional var clientID:String;
    @:optional var redirectUri:String;
    @:optional var state:String;
    @:optional var prompt:String;
}

typedef LoginOptions = {
    @:optional var username:String;
    @:optional var email:String;
    var password:String;
    var realm:String;
}

extern class WebAuth {
    public function new(options:WebAuthOptions):Void;

    public function authorize(options:AuthorizeOptions):Void;

    public var popup:{
        function authorize(options:AuthorizeOptions, callb:Dynamic):Void;
    };

    public function login(options:LoginOptions):Void;

    public function crossOriginVerification():Void;

    public function buildAuthorizeUrl(options:{
        clientID:String,
        responseType:String,
        redirectUri:String,
        state:String,
        nonce:String,
    }):Void;

    public function passwordlessStart(options:{
        var connection:String;
        var send:String;
        @:optional var phoneNumber:String;
        @:optional var email:String;
    }, callb:Dynamic):Void;

    public function passwordlessLogin(options:{
        var connection:String;
        var verificationCode:String;
        @:optional var phoneNumber:String;
        @:optional var email:String;
    }, callb:Dynamic):Void;

    public function parseHash(options:{
        @:optional var state:String;
        @:optional var nonce:String;
        @:optional var hash:String;
    }, callb:Dynamic):{
        var accessToken:String;
        var expiresIn:String;
        var idToken:String;
    };

    public function checkSession(options:{
        @:optional var nonce:String;
        @:optional var audience:String;
        @:optional var scope:String;
    }, callb:Dynamic):Void;

    public function logout(options:{
        @:optional var returnTo:String;
        @:optional var clientID:String;
        @:optional var federated:String;
    }):Void;

    public function signup(options:{
        var email:String;
        var password:String;
        var username:String;
        var connection:String;
        @:optional var user_metadata:Dynamic;
    }):Void;

    public function changePassword(options:{
        var connection:String;
        var email:String;
    }, callb:Dynamic):Void;
}