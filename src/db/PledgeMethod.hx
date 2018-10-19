package db;

@:enum abstract PledgeMethod(String) from String to String {
    var StripeCard = "stripe-card";
}