package dev;

import haxe.*;
import haxe.io.*;
import sys.*;
import sys.io.*;

class Resources {
    static var resourcesDir(default, never) = "www";
    static function hashDir(dir:String):DynamicAccess<Dynamic> {
        var hashes:DynamicAccess<Dynamic> = {};
        for (f in FileSystem.readDirectory(dir)) {
            var path = Path.join([dir, f]);
            if (FileSystem.isDirectory(path)) {
                var dirHashes = hashDir(path);
                for (k in dirHashes.keys()) {
                    hashes[Path.join([f, k])] = dirHashes[k];
                }
            } else {
                hashes[f] = haxe.crypto.Md5.make(File.getBytes(path)).toHex();
            }
        }
        return hashes;
    }
    static function main():Void {
        var hashes = hashDir(resourcesDir);
        File.saveContent("src/resources.json", Json.stringify(hashes, null, "  "));
    }
}