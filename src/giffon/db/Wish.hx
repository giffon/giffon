package giffon.db;

import thx.Decimal;

typedef Wish = {
    wish_id:Int,
    wish_hashid: String,
    wish_title: Null<String>,
    wish_description: Null<String>,
    wish_target_date: Date,
    wish_state: giffon.db.WishState,
    wish_owner: giffon.db.User,
    wish_total_price: Decimal,
    wish_total_needed: {
        amount: Decimal,
        breakdown: String,
    },
    wish_pledged: Null<Decimal>,
    wish_progress: giffon.db.WishProgress,
    supporters: Array<{
        user:User,
        pledge_date: Date,
        pledge_amount: Decimal,
    }>,
    items: Array<{
        item_id: Int,
        item_url: String,
        item_url_screenshot: Null<String>,
        item_name: String,
        item_price: thx.Decimal,
        item_currency: giffon.db.Currency,
        item_quantity: Int,
    }>,
}