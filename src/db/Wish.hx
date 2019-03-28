package db;

typedef Wish = {
    wish_id:Int,
    wish_hashid: String,
    wish_description: Null<String>,
    wish_state: db.WishState,
    wish_owner: db.User,
    wish_total_price: thx.Decimal,
    wish_total_needed: {
        amount: thx.Decimal,
        breakdown: String,
    },
    wish_pledged: Null<thx.Decimal>,
    wish_progress: db.WishProgress,
    items: Array<{
        item_id: Int,
        item_url: String,
        item_url_screenshot: js.node.Buffer,
        item_name: String,
        item_price: thx.Decimal
    }>,
}