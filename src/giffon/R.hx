package giffon;

import haxe.io.*;
import haxe.macro.*;
import giffon.config.Stage;
using StringTools;
using Lambda;

class R {
    static public var resourcesDir(default, never) = "www";

    #if macro
    static var hashes(default, never) = new Map<String,String>();
    static function hash(path:String) {
        return switch (hashes[path]) {
            case null:
                hashes[path] = haxe.crypto.Md5.make(sys.io.File.getBytes(path)).toHex();
            case h:
                h;
        }
    }
    #end

    macro static public function R(path:String) {
        if (!path.startsWith("/")) {
            Context.error('$path should relative to root (starts with /)', Context.currentPos());
        }

        var h = hash(Path.join([resourcesDir, path]));

        return macro @:privateAccess giffon.R._R($v{path}, $v{h});
    };

    static function _R(path:String, hash:String):String {
        return (switch (Stage.stage) {
            case Production, Master:
                Path.join(["https://static.giffon.io", Stage.stage, path]);
            case _:
                path;
        }) + "?md5=" + hash;
    }
}