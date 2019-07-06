package giffon;

class ChargeInfo {
    static public var serviceChargeRate(default, never):thx.Decimal = 0.08;
    static public function totalNeeded(wish:giffon.db.Wish) {
        var totalPrice = wish.wish_total_price.ceilTo(2).trim();
        var additionalCost = wish.wish_additional_cost_amount.ceilTo(2).trim();
        var totalPriceWithAdditionalCost = totalPrice + additionalCost;
        var serviceCharge = (totalPriceWithAdditionalCost * ChargeInfo.serviceChargeRate).ceilTo(2).trim();
        var amount = (totalPriceWithAdditionalCost + serviceCharge).trim();

        var additionalCostDescription = if (additionalCost > 0) {
            var desc = switch (wish.wish_additional_cost_description) {
                case null: "additional cost";
                case v: v;
            };
            '\n+\n${desc} (${additionalCost})';
        } else {
            "";
        }
        return {
            amount: amount,
            breakdown: 'total item price (${totalPrice})${additionalCostDescription}\n+\n${(serviceChargeRate * 100).trim()}% service charge (${serviceCharge})\n\n= ${amount}'
        }
    }
}