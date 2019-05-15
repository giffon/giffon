package giffon;

import haxe.io.*;
import haxe.macro.*;
import giffon.config.Stage;
using StringTools;

class R {
    #if macro
    static var hashes(default, never):haxe.DynamicAccess<String> = CompileTime.parseJsonFile("src/resources.json");
    #end

    macro static public function R(path:String) {
        var rel = if (!path.startsWith("/")) {
            Context.error('$path should relative to root (starts with /)', Context.currentPos());
        } else {
            path.substr(1);
        }
        return switch (hashes[rel]) {
            case null:
                Context.error('Cannot find the hash of $path.', Context.currentPos());
            case hash:
                macro @:privateAccess giffon.R._R($v{path}, $v{hash});
        }
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