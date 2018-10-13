import js.npm.express.*;

class ResponseTools {
    static public function getUser(res:Response):Null<db.User> {
        return res.locals.user;
    }

    static public function setUser(res:Response, user:db.User):Void {
        res.locals.user = user;
    }
}