package dev;

import haxe.io.*;

class Selenium {
    static var containerName(default, never) = "selenium-hub";
    static var networkName(default, never) = "selenium-net";
    static function main():Void {
        switch (Sys.args()) {
            case [] | ["start"]:
                Sys.command("docker", [
                    "run", "-d",
                    "--name", containerName,
                    "--network", "host",
                    "--rm",
                    "selenium/hub:3.14.0-krypton"
                ]);
                Sys.command("docker", [
                    "run", "-d",
                    "--name", containerName + "-chrome",
                    "--network", "host",
                    "-e", "HUB_HOST=localhost",
                    "-v", "/dev/shm:/dev/shm",
                    "--rm",
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