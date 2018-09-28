package jsrsasign;

#if nodejs
@:jsRequire("jsrsasign")
extern class Global {
    static public function b64utoutf8(s:String):String;
}
#else
extern class Global {
    inline static public function b64utoutf8(s:String):String {
        return untyped __js__("b64utoutf8")(s);
    }
}
#end