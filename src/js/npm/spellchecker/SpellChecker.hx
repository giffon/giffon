package js.npm.spellchecker;

#if (haxe_ver >= 4)
import js.lib.Promise;
#else
import js.Promise;
#end

typedef SpellcheckerType = Dynamic;

@:jsRequire("spellchecker")
extern class SpellChecker {
    static public function isMisspelled(word:String):Bool;
    static public function getCorrectionsForMisspelling(word:String):Array<String>;
    static public function checkSpelling(corpus:String):Array<{start:Int, end:Int}>;
    static public function checkSpellingAsync(corpus:String):Promise<Array<{start:Int, end:Int}>>;
    static public function add(word:String):Void;

    static public var USE_SYSTEM_DEFAULTS:SpellcheckerType;
    static public var ALWAYS_USE_SYSTEM:SpellcheckerType;
    static public var ALWAYS_USE_HUNSPELL:SpellcheckerType;
}

@:jsRequire("spellchecker", "Spellchecker")
extern class SpellCheckerInstance {
    public function isMisspelled(word:String):Bool;
    public function getCorrectionsForMisspelling(word:String):Array<String>;
    public function checkSpelling(corpus:String):Array<{start:Int, end:Int}>;
    public function checkSpellingAsync(corpus:String):Promise<Array<{start:Int, end:Int}>>;
    public function add(word:String):Void;

    public function new():Void;
    public function setSpellcheckerType(type:SpellcheckerType):Void;
}