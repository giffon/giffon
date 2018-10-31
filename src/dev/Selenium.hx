package dev;

import haxe.io.*;

class Selenium {
    static var containerName(default, never) = "selenium";
    static var networkName(default, never) = "selenium-net";
    static function main():Void {
        switch (Sys.args()) {
            case [] | ["start"]:
                Sys.command("docker", [
                    "network", "create", networkName
                ]);
                Sys.command("docker", [
                    "run", "-d",
                    "--name", containerName + "-hub",
                    "--net", networkName,
                    "-p", "4444:4444",
                    "--rm",
                    "selenium/hub:3.14.0-krypton"
                ]);
                Sys.command("docker", [
                    "run", "-d",
                    "--name", containerName + "-chrome",
                    "--net", networkName,
                    "-P",
                    "-p", "5900:5900",
                    "-e", "HUB_HOST=" + containerName + "-hub",
                    "-v", "/dev/shm:/dev/shm",
                    "--rm",
                    "selenium/node-chrome-debug:3.14.0-krypton"
                ]);
                Sys.command("docker", [
                    "run", "-d",
                    "--name", containerName + "-firefox",
                    "--net", networkName,
                    "-P",
                    "-p", "5901:5900",
                    "-e", "HUB_HOST=" + containerName + "-hub",
                    "-v", "/dev/shm:/dev/shm",
                    "--rm",
                    "selenium/node-firefox-debug:3.14.0-krypton"
                ]);
            case ["stop"]:
                Sys.command("docker", ["stop", containerName + "-hub"]);
                Sys.command("docker", ["stop", containerName + "-chrome"]);
                Sys.command("docker", ["stop", containerName + "-firefox"]);
                Sys.command("docker", ["network", "rm", networkName]);
            case _:
                throw "invalid args";
        }
    }
}