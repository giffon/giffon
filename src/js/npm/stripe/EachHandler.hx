package js.npm.stripe;

import haxe.extern.*;

typedef EachHandler<T> = EitherType<T->Bool, T->?Bool->Void>;