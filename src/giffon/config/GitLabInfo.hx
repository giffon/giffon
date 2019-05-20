package giffon.config;

import giffon.Utils.*;

class GitLabInfo {
    static public var GITLAB_APP_ID(default, never) = env("GITLAB_APP_ID", "gl client id");
    static public var GITLAB_APP_SECRET(default, never) = env("GITLAB_APP_SECRET", "secret");
}