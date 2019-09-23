# Giffon

[![pipeline status](https://gitlab.com/giffon.io/giffon/badges/master/pipeline.svg)](https://gitlab.com/giffon.io/giffon/commits/master)

https://giffon.io

## Development info

Giffon uses Haxe-compiled JS on both client and server sides.

### Develop with VS Code Remote Containers

Install these

 * [Docker](https://docs.docker.com/install/#supported-platforms)
   Community Edition is enough. In case your machine does not meet the requirements of Docker for Mac and Docker for Windows, you can use [Docker Toolbox](https://docs.docker.com/toolbox/overview/) instead.
 * [Visual Studio Code](https://code.visualstudio.com/)
 * [Visual Studio Code Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

After you have cloned the project:

 1. `git submodule update --init` to make sure the git submodules are up-to-date.
 2. Open the project folder in VS Code. Select reopen in dev constainer when it prompts to do so, or use the green button at the bottom-left corner. It will build a container that contain Haxe, node, and run `npm install` automatically. It will also launch a MySQL container.
 3. `npm run-script build` to build everything.
 4. `npm start` to start the server. It should be accessible via https://localhost:3000. Use <kbd>ctrl</kbd> + <kbd>c</kbd> to stop the server. When the server script is rebuilt, the server will be automatically restarted by nodemon.
 
### Local automated testing

 1. Run Giffon locally first (see above).
 2. `haxe run-selenium.hxml`.
 3. `npm test`

### Deployment

Deployment is automated by GitLab CI. The `master` branch is deployed to https://master.giffon.io; the `production` branch is deployed to https://giffon.io. Pushing to `production` is a manual process.
