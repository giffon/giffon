package giffon;

import haxe.io.*;
import giffon.config.Stage;

class R {
    static public function R(path:String) {
        return switch (Stage.stage) {
            case Production, Master:
                Path.join(["https://static.giffon.io", Stage.stage, path]);
            case _:
                path;
        };
    };
}