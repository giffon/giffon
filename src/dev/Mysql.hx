package dev;

import haxe.io.*;

class Mysql {
    static var containerName(default, never) = "mysql";
    static function main():Void {
        switch (Sys.args()) {
            case [] | ["start"]:
                start();
            case ["stop"]:
                stop();
            case ["restart"]:
                stop();
                start();
            case _:
                throw "invalid args";
        }
    }

    static public function start():Void {
        Sys.command("docker", [
            "run", "-d",
            "--name", containerName,
            "--rm",
            "-e", "MYSQL_ROOT_PASSWORD=" + DBInfo.password,
            "-e", "MYSQL_DATABASE=" + DBInfo.database,
            "-v", Path.join([Sys.getCwd(), "dev", "initdb"]) + ":/docker-entrypoint-initdb.d",
            "-p", "3306:3306",
            "mysql:5.7"
        ]);
    }

    static public function stop():Void {
        Sys.command("docker", ["stop", containerName]);
    }
}