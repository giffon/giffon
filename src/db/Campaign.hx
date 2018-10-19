package db;

typedef Campaign = {
    campaign_id:Int,
    campaign_hashid: String,
    campaign_description: Null<String>,
    campaign_state: db.CampaignState,
    campaign_owner: db.User,
    campaign_total_price: thx.Decimal,
    items: Array<{
        item_id: Int,
        item_url: String,
        item_url_screenshot: js.node.Buffer,
        item_name: String,
        item_price: thx.Decimal
    }>,
}