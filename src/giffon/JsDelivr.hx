package giffon;

import sys.FileSystem;
import haxe.*;
import haxe.io.*;
import haxe.macro.*;
import sys.io.*;
using Lambda;
using StringTools;
using Reflect;

private typedef ItemInfo = {
    type:String,
    name:String,
}

private typedef DirectoryInfo = ItemInfo & {
    files:Array<ItemInfo>,
}

private typedef FileInfo = ItemInfo & {
    hash:String,
    time:String,
    size:Int,
}

class JsDelivr {
    #if macro
    static final packageJson = Json.parse(File.getContent("package.json"));
    #end
    macro static public function jsDelivr(npmPackage:String, filePath:String) {
        var version = if (Reflect.hasField(packageJson.dependencies, npmPackage))
            Reflect.field(packageJson.dependencies, npmPackage);
        else if (Reflect.hasField(packageJson.devDependencies, npmPackage))
            Reflect.field(packageJson.devDependencies, npmPackage);
        else
            Context.error('Cannot find package version from package.json.', Context.currentPos());
        var cacheFile = 'src/cache/${npmPackage.urlEncode()}@${version}.json';

        if (!FileSystem.exists(cacheFile)) {
            var api = 'https://data.jsdelivr.com/v1/package/npm/${npmPackage}@${version}';
            var process = new Process("curl", ["-sSL", api, "-o", cacheFile]);
            if (process.exitCode() != 0) {
                var err = process.stderr.readAll().toString();
                Context.error('API call to $api failed. \n$err', Context.currentPos());
            }
            process.close();
        }

        var files = Json.parse(File.getContent(cacheFile));
        var file = fileInfo(files, filePath);
        var url = 'https://cdn.jsdelivr.net/npm/${npmPackage}@${version}/${filePath}';
        var integrity = 'sha256-${file.hash}';
        
        return switch (Path.extension(file.name)) {
            case "js":
                macro react.React.createElement("script", {
                    src: $v{url},
                    integrity: $v{integrity},
                    crossOrigin: "anonymous",
                });
            case "css":
                macro react.React.createElement("link", {
                    rel: "stylesheet",
                    href: $v{url},
                    integrity: $v{integrity},
                    crossOrigin: "anonymous",
                });
            case ext:
                Context.error('Unknown extension: $ext', Context.currentPos());
        }
    }

    static function fileInfo(info:DirectoryInfo, path:String):Null<FileInfo> {
        var parts = path.split("/");
        var partInfo = info.files.find(item -> item.name == parts[0]);
        return switch (parts.length) {
            case 1:
                cast partInfo;
            case _:
                fileInfo(cast partInfo, parts.slice(1).join("/"));
        }
    }
}