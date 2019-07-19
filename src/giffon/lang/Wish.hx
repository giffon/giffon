package giffon.lang;

import react.*;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class Wish {
    static public function wish(lang:Language) return switch (lang) {
        case English: "wish";
        case Cantonese: "願望";
    }

    static public function wishOfPerson(lang:Language, persion:String) return switch (lang) {
        case English: '${persion}\'s Wish';
        case Cantonese: '${persion}嘅願望';
    }

    static public function supporters(lang:Language, num:Int) return switch (lang) {
        case English: num == 1 ? "supporter" : "supporters";
        case Cantonese: "支持者";
    }

    static public function achieved(lang:Language) return switch (lang) {
        case English: "achieved";
        case Cantonese: "完成度";
    }

    static public function iWant(lang:Language) return switch (lang) {
        case English: "Well, I want...";
        case Cantonese: "我想要...";
    }

    static public function total(lang:Language) return switch (lang) {
        case English: "Total";
        case Cantonese: "總值";
    }

    static public function wishOwner(lang:Language) return switch (lang) {
        case English: "Wish Owner";
        case Cantonese: "許願者";
    }

    static public function supportTheWish(lang:Language) return switch (lang) {
        case English: "Support the Wish";
        case Cantonese: "幫手實現願望";
    }

    static public function youHavePledged(lang:Language) return switch (lang) {
        case English: "You have currently pledged";
        case Cantonese: "你現時承諾付出";
    }

    static public function cancelPledge(lang:Language) return switch (lang) {
        case English: "Cancel pledge";
        case Cantonese: "取消承諾";
    }

    static public function pledgeAmountIsHidden(lang:Language) return switch (lang) {
        case English: "The pledge amount is hidden.";
        case Cantonese: "付出金額已隱藏.";
    }

    static public function pledgeAmountVisibleToWishOwner(lang:Language) return switch (lang) {
        case English: "The pledge amount will be visible to the wish owner once the wish is completed.";
        case Cantonese: "付出金額會喺願望達成嘅時候顯示俾許願者.";
    }

    static public function pledgeAmountVisibleToAll(lang:Language) return switch (lang) {
        case English: "The pledge amount will be visible to all once the wish is completed.";
        case Cantonese: "付出金額會喺願望達成嘅時候公開顯示.";
    }

    static public function pledgeAmountBeHiddenFromAll(lang:Language) return switch (lang) {
        case English: "Pledge amount be hidden from all.";
        case Cantonese: "隱藏付出金額.";
    }

    static public function pledgeAmountBeVisibleToWishOwner(lang:Language) return switch (lang) {
        case English: "Pledge amount be visible to wish owner, hidden from others.";
        case Cantonese: "只向許願者顯示付出金額.";
    }

    static public function pledgeAmountBeVisibleToAll(lang:Language) return switch (lang) {
        case English: "Pledge amount be visible to all.";
        case Cantonese: "公開顯示付出金額.";
    }

    static public function youHaventPledgedYourSupportYet(lang:Language) return switch (lang) {
        case English: "You haven't pledged your support yet.";
        case Cantonese: "你未有承諾任何付出.";
    }

    static public function supportAmount(lang:Language) return switch (lang) {
        case English: "Support amount";
        case Cantonese: "支持金額";
    }

    static public function creditCard(lang:Language) return switch (lang) {
        case English: "Credit card";
        case Cantonese: "信用卡";
    }

    static public function pledgeAmountVisibility(lang:Language) return switch (lang) {
        case English: "Contribution amount visibility";
        case Cantonese: "付出金額顯示設定";
    }

    static public function pledgeAmountVisibilityNote(lang:Language) return switch (lang) {
        case English: "After the wish completes, everyone will be able to see you contributed, optionally with the amount.";
        case Cantonese: "願望達成後, 所有人都可以見到你有份支持. 你可以選擇性公開你付出嘅金額.";
    }

    static public function agreeTo(lang:Language, something:ReactElement) return MakeAWish.agreeTo(lang, something);
    static public function termsAndConditions(lang:Language) return MakeAWish.termsAndConditions(lang);
    static public function submit(lang:Language) return MakeAWish.submit(lang);

    static public function bibbidiBobbidiBoom(lang:Language) return switch (lang) {
        case English: "Bibbidi Bobbidi Boom!";
        case Cantonese: "嗎哩嗎哩空!";
    }

    static public function wishFulfilled(lang:Language) return switch (lang) {
        case English: "Wish fulfilled!";
        case Cantonese: "願望達成!";
    }

    static public function greatThanksForTheFollowingFriends(lang:Language) return switch (lang) {
        case English: "Great thanks for the following friends!";
        case Cantonese: "多謝以下有夾份嘅朋友!";
    }

    static public function supportersWithVisibleSupportAmounts(lang:Language) return switch (lang) {
        case English: "Supporters with visible support amounts.";
        case Cantonese: "選擇顯示金額嘅支持者.";
    }

    static public function supportersWithHiddenSupportAmounts(lang:Language) return switch (lang) {
        case English: "Supporters with hidden support amounts. Sorted by support amount in descending order.";
        case Cantonese: "選擇隱藏金額嘅支持者. 以付出金額多至少排列.";
    }

    static public function badgeSucceeded(lang:Language) return switch (lang) {
        case English: "succeeded";
        case Cantonese: "已達成";
    }

    static public function badgeUnpublished(lang:Language) return switch (lang) {
        case English: "unpublished";
        case Cantonese: "未發佈";
    }

    static public function badgeCancelled(lang:Language) return switch (lang) {
        case English: "cancelled";
        case Cantonese: "已取消";
    }

    static public function copy(lang:Language) return switch (lang) {
        case English: "copy";
        case Cantonese: "複製";
    }

    static public function copied(lang:Language) return switch (lang) {
        case English: "copied";
        case Cantonese: "已複製";
    }

    static public function copyPermalink(lang:Language) return switch (lang) {
        case English: "copy permalink";
        case Cantonese: "複製願望連結";
    }

    static public function copiedPermalink(lang:Language) return switch (lang) {
        case English: "copied permalink";
        case Cantonese: "已複製願望連結";
    }

    static public function howCanYouSupport(lang:Language) return switch (lang) {
        case English: "How can you support?";
        case Cantonese: "點幫手?";
    }

    static public function shareTheWishWithYourFriends(lang:Language) return switch (lang) {
        case English: "Share the wish with your friends.";
        case Cantonese: "話俾身邊嘅朋友知.";
    }

    static public function pledgeTheWishSinceEveryDollarMatters(lang:Language) return switch (lang) {
        case English: "Pledge the wish, since every $1 matters.";
        case Cantonese: "現金支持. 每一蚊都好有用.";
    }

    static public function pledgeNow(lang:Language) return switch (lang) {
        case English: "Pledge Now";
        case Cantonese: "即刻夾份";
    }

    static public function pledgeBelow(lang:Language) return switch (lang) {
        case English: "Pledge Below";
        case Cantonese: "即刻夾份";
    }

    static public function wishSettings(lang:Language) return switch (lang) {
        case English: "Settings";
        case Cantonese: "設定";
    }

    static public function useACoupon(lang:Language) return switch (lang) {
        case English: "Use a Coupon";
        case Cantonese: "使用優惠券";
    }

    static public function useAnyCouponCodeYouReceived(lang:Language) return switch (lang) {
        case English: "Use any coupon code you received.";
        case Cantonese: "輸入你收到嘅優惠券.";
    }

    static public function apply(lang:Language) return switch (lang) {
        case English: "Apply";
        case Cantonese: "使用";
    }

    static public function editWish(lang:Language) return EditWish.editWish(lang);

    static public function editWishNote(lang:Language) return switch (lang) {
        case English: "You may edit the wish info, but not the items.";
        case Cantonese: "除咗願望清單中嘅項目, 其他願望資料都可以修改.";
    }

    static public function cancelTheWish(lang:Language) return switch (lang) {
        case English: "Cancel the Wish";
        case Cantonese: "取消願望";
    }

    static public function cancelWishNote(lang:Language) return switch (lang) {
        case English: "Once cancelled, all existing pledges will be refunded to the supporters. The action cannot be undone.";
        case Cantonese: "取消願望後, Giffon會退回全數承諾金額俾支持者. 取消動作唔可能還原.";
    }
    static public function cancelWish(lang:Language) return switch (lang) {
        case English: "Cancel Wish";
        case Cantonese: "取消願望";
    }
}