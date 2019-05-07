# Giffon

[![pipeline status](https://gitlab.com/giffon.io/giffon/badges/master/pipeline.svg)](https://gitlab.com/giffon.io/giffon/commits/master)

https://giffon.io

## Development info

Giffon uses Haxe-compiled JS on both client and server sides. To run a local version, you need:

 * [Haxe 3.4.7](https://haxe.org/download/version/3.4.7/).
 * [Node 8 or 10](https://nodejs.org/en/download/) for running the server program. Node 8.10 is recommended since it's what being used in our [AWS Lambda config](serverless.yml)).
 * [Docker](https://docs.docker.com/install/#supported-platforms) for running a local MySQL database. Community Edition is enough. In case your machine does not meet the requirements of Docker for Mac and Docker for Windows, you can use [Docker Toolbox](https://docs.docker.com/toolbox/overview/) instead.

### Run Giffon locally

After you have cloned the project:

 1. `git submodule update --init` to make sure the git submodules are up-to-date.
 2. `npm install` to get the node packages and haxelibs (package.json's postinstall).
 3. `npm run-script build` to build everything.
 4. `haxe run-mysql.hxml start` to start a local MySQL database. Use `haxe run-mysql.hxml stop` to stop it when you're done. Note that the database content will be gone once stopped.
 5. `npm start` to start the server. It should be accessible via https://localhost:3000. Use <kbd>ctrl</kbd> + <kbd>c</kbd> to stop the server.
 
### Local automated testing

 1. Run Giffon locally first (see above).
 2. `haxe run-selenium.hxml`.
 3. `npm test`

### Deployment

Deployment is automated by GitLab CI. The `master` branch is deployed to https://master.giffon.io; the `production` branch is deployed to https://giffon.io. Pushing to `production` is a manual process.
