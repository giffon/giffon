package db;

typedef Campaign = {
    campaign_id:Int,
    campaign_hashid: String,
    campaign_description: Null<String>,
    campaign_state: db.CampaignState,
    campaign_owner: db.User,
    campaign_total_price: thx.Decimal,
    campaign_total_needed: {
        amount: thx.Decimal,
        breakdown: String,
    },
    campaign_pledged: Null<thx.Decimal>,
    campaign_progress: db.CampaignProgress,
    items: Array<{
        item_id: Int,
        item_url: String,
        item_url_screenshot: js.node.Buffer,
        item_name: String,
        item_price: thx.Decimal
    }>,
}