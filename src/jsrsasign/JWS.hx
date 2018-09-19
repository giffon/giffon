package jsrsasign;

@:native("KJUR.jws.JWS")
extern class JWS {
    public function new():Void;

    static public var jwsalg2sigalg:Dynamic<String>;

    static public function getEncodedSignatureValueFromJWS(sJWS:String):String;

    static public function getJWKthumbprint(o:Dynamic):String;

    static public function inArray(item:String, a:Array<String>):Bool;

    static public function includedArray(a1:Array<String>, a2:Array<String>):Bool;

    static public function isSafeJSONString(s:String):Int;

    static public function parse(sJWS:String):{
        var headerObj:Dynamic;
        var payloadObj:Dynamic;
        var headerPP:String;
        var payloadPP:String;
        var sigHex:String;
    };

    static public function parseJWS(sJWS:String):Void;

    static public function readSafeJSONString(s:String):Dynamic;

    static public function sign(alg:String, spHead:String, spPayload:String, key:String, pass:String):String;

    static public function verify(sJWS:String, key:Dynamic, acceptAlgs:String):Bool;

    static public function verifyJWT(sJWT:String, key:Dynamic, acceptField:{
        @:optional var alg:Array<String>;
        @:optional var iss:Array<String>;
        @:optional var sub:Array<String>;
        @:optional var aud:Array<String>;
        @:optional var jti:String;
        @:optional var verifyAt:Float;
        @:optional var gracePeriod:Float;
    }):Bool;
}