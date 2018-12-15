class Auth0Info {
    static public var AUTH0_CLIENT_ID(default, never) = 'iI1IXOjJzqm2QQ6PclJ61HKwhW8QHJXz';
    static public var AUTH0_DOMAIN(default, never) = 'giffon.auth0.com';
    static public var AUTH0_PUBKEY(default, never) = CompileTime.readFile("../auth0/giffon.cer");
    #if nodejs
    static public var AUTH0_CLIENT_SECRET(default, never) = Utils.env("AUTH0_CLIENT_SECRET", "secret");
    #end
}