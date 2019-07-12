package dev;

import haxe.io.*;

class Selenium {
    static var containerName(default, never) = "selenium";
    static var networkName(default, never) = "selenium-net";
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
            "network", "create", networkName
        ]);
        Sys.command("docker", [
            "run", "-d",
            "--name", containerName + "-hub",
            "--net", networkName,
            "-p", "4444:4444",
            "--rm",
            "selenium/hub:3.141.59-radium"
        ]);
        Sys.command("docker", [
            "run", "-d",
            "--name", containerName + "-chrome",
            "--net", networkName,
            "-P",
            "-p", "5900:5900",
            "-e", "HUB_HOST=" + containerName + "-hub",
            "-e", "VNC_NO_PASSWORD=1",
            "-v", "/dev/shm:/dev/shm",
            "--rm",
            "selenium/node-chrome-debug:3.141.59-radium"
        ]);
    }

    static public function stop():Void {
        Sys.command("docker", ["stop", containerName + "-hub"]);
        Sys.command("docker", ["stop", containerName + "-chrome"]);
        Sys.command("docker", ["stop", containerName + "-firefox"]);
        Sys.command("docker", ["network", "rm", networkName]);
    }
}