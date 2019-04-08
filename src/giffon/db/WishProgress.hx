package giffon.db;

@:enum abstract WishProgress(String) from String to String {
    var None = "none";
    var Started = "started";
    var Halfway = "halfway";
    var Almost = "almost";
    var Done = "done";
}

class WishProgressTools {
    static public function pledgeStateFromAmount(current:Null<thx.Decimal>, totalNeeded:thx.Decimal):WishProgress {
        if (current == null) current = thx.Decimal.zero;
        var percent = (current / totalNeeded) * 100;
        return if (percent >= 85)
            Almost;
        else if (percent >= 50)
            Halfway;
        else if (percent > 0)
            Started;
        else
            None;
    }
}