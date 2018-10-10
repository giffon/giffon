# Giffon

https://giffon.io

## Development info

Giffon uses Haxe-compiled JS on both client and server sides. To run a local version, you need:

 * [Haxe 3.4.7](https://haxe.org/download/version/3.4.7/).
 * [Node 8 (or up)](https://nodejs.org/en/download/) for running the server program.
 * [Docker](https://docs.docker.com/install/#supported-platforms) for running a local MySQL database. Community Edition is enough. In case your machine does not meet the requirements of Docker for Mac and Docker for Windows, you can use [Docker Toolbox](https://docs.docker.com/toolbox/overview/) instead.

After you have cloned the project:

 1. `git submodule update --init` to make sure the git submodules are up-to-date.
 2. `npm install` to get the node packages and haxelibs. (See package.json's postinstall.)
 3. `haxe run-mysql.hxml start` to start a local MySQL database. Use `haxe run-mysql.hxml stop` to stop it when you're done. Note that the database content will be gone once stopped.
 4. `npm start` to build and run the server. It should be accessible via http://localhost:3000. Use <kbd>ctrl</kbd>+<kbd>c</kbd> to stop the server.