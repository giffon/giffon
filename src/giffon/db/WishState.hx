package giffon.db;

@:enum abstract WishState(String) from String to String {
    var Created = "created";
    var Published = "published";
    var Ended = "ended";
    var Succeed = "succeed"; //charged
    var Cancelled = "cancelled";
    var Shipped = "shipped";
}