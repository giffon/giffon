package db;

@:enum abstract CampaignState(String) from String to String {
    var Created = "created";
    var Published = "published";
    var Ended = "ended";
    var Succeed = "succeed"; //charged
    var Cancelled = "cancelled";
    var Shipped = "shipped";
}