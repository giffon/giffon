package giffon.db;

typedef User = {
    user_id:Int,
    user_hashid:String,
    user_primary_email:Null<String>,
    user_name:String,
    user_avatar:Null<String>,
    user_description:Null<String>,
    user_profile_url:String,
}