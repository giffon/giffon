package giffon.server;

import js.*;

class PromiseTools {
    static public function handleError<T>(p:Promise<T>, next:Dynamic):Promise<T> {
        return p.catchError(next);
    }
}