package giffon.db;

import thx.Decimal;

typedef WishSupport = {
    user:User,
    pledge_date: Date,
    pledge_amount: Decimal,
    pledge_visibility: giffon.db.PledgeVisibility,
}

typedef Wish = {
    wish_id:Int,
    wish_hashid: String,
    wish_title: Null<String>,
    wish_description: Null<String>,
    wish_target_date: Date,
    wish_state: giffon.db.WishState,
    wish_owner: giffon.db.User,
    wish_currency: giffon.db.Currency,
    wish_banner_url: Null<String>,
    wish_total_price: Decimal,
    wish_total_needed: {
        amount: Decimal,
        breakdown: String,
    },
    wish_pledged: Decimal,
    wish_progress: giffon.db.WishProgress,
    supporters: Array<WishSupport>,
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