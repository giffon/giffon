package jsrsasign;

import haxe.extern.*;

@:native("KEYUTIL")
extern class KEYUTIL {
    static public var version:String;

    static public function generateKeypair(alg:String, keylenOrCurve:EitherType<Int, String>):{
        var prvKeyObj:Dynamic;
        var pubKeyObj:Dynamic;
    };

    static public function getDecryptedKeyHex(sEncryptedPEM:String, passcode:String):String;

    static public function getJWKFromKey(key:Dynamic):Dynamic;

    static public function getKey(param:Dynamic, ?passcode:String, ?hextype:String):Dynamic;

    static public function getKeyAndUnusedIvByPasscodeAndIvsalt(algName:String, passcode:String, hexadecimal:String):Dynamic;

    static public function getKeyFromCSRHex(csrHex:String):Dynamic;

    static public function getKeyFromCSRPEM(csrPEM:String):Dynamic;

    static public function getKeyFromEncryptedPKCS8PEM(pkcs8PEM:String, passcode:String):Dynamic;

    static public function getKeyFromPlainPrivatePKCS8Hex(prvKeyHex:String):Dynamic;

    static public function getKeyFromPlainPrivatePKCS8PEM(pkcs8PEM:String):Dynamic;

    static public function getPBKDF2KeyHexFromParam(info:{
        var pbkdf2Salt:String;
        var pkbdf2Iter:Int;
    }, passcode:String):String;

    static public function getPEM(keyObjOrHex:Dynamic, ?formatType:String, ?passwd:String, ?encAlg:String, ?hexType:String, ?ivsaltHex:String):Dynamic;

    static public function parseCSRHex(csrHex:String):{
        var p8pubkeyhex:String;
    };

    static public function parseHexOfEncryptedPKCS8(passcode:String):{
        var pbkdf2Salt:String;
        var pkbdf2Iter:Int;
        var ciphertext:String;
        var encryptionSchemeAlg:String;
        var encryptionSchemeIV:String;
    };

    static public function parsePKCS5PEM(sEncryptedPEM:String):{
        var cipher:String;
        var ivsalt:String;
        var type:String;
        var data:String;
    };

    static public function parsePlainPrivatePKCS8Hex(pkcs8PrvHex:String):{
        var algoid:String;
        var algparam:String;
        var keyidx:Int;
    };

    static public function parsePublicPKCS8Hex(pkcs8PubHex:String):{
        var algoid:String;
        var algparam:String;
        var key:String;
    };

    static public function parsePublicRawRSAKeyHex(pubRawRSAHex:String):{
        var n:String;
        var e:String;
    };
}