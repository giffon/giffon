package giffon.config;

import giffon.Utils.*;

class GitHubInfo {
    static public var GITHUB_CLIENT_ID(default, never) = env("GITHUB_CLIENT_ID", "gh client id");
    static public var GITHUB_CLIENT_SECRET(default, never) = env("GITHUB_CLIENT_SECRET", "secret");
}