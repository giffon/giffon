package giffon.db;

@:enum abstract WishState(String) from String to String {
    var Created = "created";
    var Published = "published";
    var Succeed = "succeed";
    var Cancelled = "cancelled";
}