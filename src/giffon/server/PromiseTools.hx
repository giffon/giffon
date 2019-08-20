package giffon.server;

#if (haxe_ver >= 4)
import js.lib.Promise;
#else
import js.Promise;
#end

class PromiseTools {
    static public function handleError<T>(p:Promise<T>, next:Dynamic):Promise<T> {
        return p.catchError(next);
    }
}