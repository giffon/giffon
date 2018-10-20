class ChargeInfo {
    static public var serviceChargeRate(default, never):thx.Decimal = 0.1;
    static public function totalNeeded(campaign:db.Campaign) {
        var totalPrice = campaign.campaign_total_price.ceilTo(2);
        var amount = (totalPrice + (totalPrice * ChargeInfo.serviceChargeRate).ceilTo(2)).trim();
        return {
            amount: amount,
            breakdown: 'total item price (${totalPrice}) + ${(serviceChargeRate * 100).trim()}% service charge (${(totalPrice * serviceChargeRate).roundTo(2)}) = ${amount}'
        }
    }
}