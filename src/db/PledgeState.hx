package db;

@:enum abstract PledgeState(String) from String to String {
    var Pledged = "pledged";
    var Charged = "charged";
    var Cancelled = "cancelled";
}