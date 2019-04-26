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
        if (totalNeeded <= 0) return Almost;
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

    static public function lowerBound(p:WishProgress):Float {
        return switch (p) {
            case Done:
                100;
            case Almost:
                85;
            case Halfway:
                50;
            case Started:
                0;
            case None:
                0;
        }
    }
}