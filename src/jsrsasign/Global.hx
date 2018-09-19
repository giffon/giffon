package jsrsasign;

extern class Global {
    inline static public function b64utoutf8(s:String):String {
        return untyped __js__("b64utoutf8")(s);
    }
}