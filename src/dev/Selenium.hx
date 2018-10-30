package dev;

import haxe.io.*;

class Selenium {
    static var containerName(default, never) = "selenium-hub";
    static function main():Void {
        switch (Sys.args()) {
            case [] | ["start"]:
                Sys.command("docker", [
                    "run", "-d",
                    "--name", containerName,
                    "--rm",
                    "-p", "4444:4444",
                    "selenium/hub:3.14.0-krypton"
                ]);
                Sys.command("docker", [
                    "run", "-d",
                    "--name", containerName + "-chrome",
                    "--link", containerName + ":hub",
                    "-v", "/dev/shm:/dev/shm",
                    "--rm",
                    "-P",
                    "-p", "5900:5900",
                    "selenium/node-chrome-debug:3.14.0-krypton"
                ]);
            case ["stop"]:
                Sys.command("docker", ["stop", containerName]);
                Sys.command("docker", ["stop", containerName + "-chrome"]);
            case _:
                throw "invalid args";
        }
    }
}