package db;

@:enum abstract Currency(String) from String to String {
    var USD = "USD";
    var HKD = "HKD";
}