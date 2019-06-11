package giffon.db;

import thx.Decimal;

typedef Coupon = {
    coupon_id:Int,
    coupon_creator_id:Null<Int>,
    coupon_code:Null<String>,
    coupon_value_HKD:Null<Decimal>,
    coupon_value_USD:Null<Decimal>,
    coupon_quota:Null<Int>,
    coupon_deadline:Null<Date>,
}