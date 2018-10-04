package db;

@:enum abstract SurpriseCampaignProgress(String) from String to String {
    var Started = "started";
    var Halfway = "halfway";
    var Almost = "almost";
    var Done = "done";
}