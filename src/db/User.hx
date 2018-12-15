package db;

typedef User = {
    user_id:Int,
    user_hashid:String,
    user_primary_email:String,
    user_name:String,
    user_has_card:Bool,
    stripe_customer:Null<js.npm.stripe.Customer>,
}