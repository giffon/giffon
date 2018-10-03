package dev;

import haxe.io.*;

class Mysql {
    static var containerName(default, never) = "mysql";
    static function main():Void {
        switch (Sys.args()) {
            case [] | ["start"]:
                Sys.command("docker", [
                    "run", "-d",
                    "--name", containerName,
                    "--rm",
                    "-e", "MYSQL_ROOT_PASSWORD=" + DBInfo.password,
                    "-e", "MYSQL_DATABASE=" + DBInfo.database,
                    "-v", Path.join([Sys.getCwd(), "dev", "initdb"]) + ":/docker-entrypoint-initdb.d",
                    "-p", "3306:3306", "mysql:5.6"
                ]);
            case ["stop"]:
                Sys.command("docker", ["stop", containerName]);
            case _:
                throw "invalid args";
        }
    }
}