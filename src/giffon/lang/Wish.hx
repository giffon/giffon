package giffon.lang;

import react.*;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class Wish {
    static public function wish(lang:Language) return switch (lang) {
        case English: "wish";
        case Cantonese | Chinese: "願望";
    }

    static public function wishOfPerson(lang:Language, persion:String) return switch (lang) {
        case English: '${persion}\'s Wish';
        case Cantonese: '${persion}嘅願望';
        case Chinese: '${persion}的願望';
    }

    static public function supporters(lang:Language, num:Int) return switch (lang) {
        case English: num == 1 ? "supporter" : "supporters";
        case Cantonese | Chinese: "支持者";
    }

    static public function achieved(lang:Language) return switch (lang) {
        case English: "achieved";
        case Cantonese | Chinese: "完成度";
    }

    static public function iWant(lang:Language) return switch (lang) {
        case English: "Well, I want...";
        case Cantonese | Chinese: "我想要...";
    }

    static public function total(lang:Language) return switch (lang) {
        case English: "Total";
        case Cantonese | Chinese: "總值";
    }

    static public function wishOwner(lang:Language) return switch (lang) {
        case English: "Wish Owner";
        case Cantonese | Chinese: "許願者";
    }

    static public function supportTheWish(lang:Language) return switch (lang) {
        case English: "Support the Wish";
        case Cantonese: "幫手實現願望";
        case Chinese: "幫忙實現願望";
    }

    static public function youHavePledged(lang:Language) return switch (lang) {
        case English: "You have currently pledged";
        case Cantonese | Chinese: "你現時承諾付出";
    }

    static public function cancelPledge(lang:Language) return switch (lang) {
        case English: "Cancel pledge";
        case Cantonese | Chinese: "取消承諾";
    }

    static public function pledgeAmountIsHidden(lang:Language) return switch (lang) {
        case English: "The pledge amount is hidden.";
        case Cantonese | Chinese: "付出金額已隱藏.";
    }

    static public function pledgeAmountVisibleToWishOwner(lang:Language) return switch (lang) {
        case English: "The pledge amount will be visible to the wish owner once the wish is completed.";
        case Cantonese: "付出金額會喺願望達成嘅時候顯示俾許願者.";
        case Chinese: "付出金額會在願望達成的時候顯示予許願者.";
    }

    static public function pledgeAmountVisibleToAll(lang:Language) return switch (lang) {
        case English: "The pledge amount will be visible to all once the wish is completed.";
        case Cantonese: "付出金額會喺願望達成嘅時候公開顯示.";
        case Chinese: "付出金額會在願望達成的時候公開顯示.";
    }

    static public function pledgeAmountBeHiddenFromAll(lang:Language) return switch (lang) {
        case English: "Pledge amount be hidden from all.";
        case Cantonese | Chinese: "隱藏付出金額.";
    }

    static public function pledgeAmountBeVisibleToWishOwner(lang:Language) return switch (lang) {
        case English: "Pledge amount be visible to wish owner, hidden from others.";
        case Cantonese | Chinese: "只向許願者顯示付出金額.";
    }

    static public function pledgeAmountBeVisibleToAll(lang:Language) return switch (lang) {
        case English: "Pledge amount be visible to all.";
        case Cantonese | Chinese: "公開顯示付出金額.";
    }

    static public function pledgeNameIsHidden(lang:Language) return switch (lang) {
        case English: "The pledge is anonymous.";
        case Cantonese | Chinese: "匿名付出.";
    }

    static public function pledgeNameVisibleToWishOwner(lang:Language) return switch (lang) {
        case English: "Your name will be visible to the wish owner once the wish is completed.";
        case Cantonese: "你嘅名會喺願望達成嘅時候顯示俾許願者.";
        case Chinese: "你的名字會在願望達成的時候顯示予許願者.";
    }

    static public function pledgeNameVisibleToAll(lang:Language) return switch (lang) {
        case English: "Your name will be visible to all once the wish is completed.";
        case Cantonese: "你嘅名會喺願望達成嘅時候公開顯示.";
        case Chinese: "你的名字會在願望達成的時候公開顯示.";
    }

    static public function pledgeNameBeHiddenFromAll(lang:Language) return switch (lang) {
        case English: "The pledge be anonymous.";
        case Cantonese | Chinese: "匿名付出.";
    }

    static public function pledgeNameBeVisibleToWishOwner(lang:Language) return switch (lang) {
        case English: "Your name be visible to wish owner, hidden from others.";
        case Cantonese | Chinese: "只向許願者顯示你的名字.";
    }

    static public function pledgeNameBeVisibleToAll(lang:Language) return switch (lang) {
        case English: "Your name be visible to all.";
        case Cantonese | Chinese: "公開顯示你的名字.";
    }

    static public function youHaventPledgedYourSupportYet(lang:Language) return switch (lang) {
        case English: "You haven't pledged your support yet.";
        case Cantonese | Chinese: "你未有承諾任何付出.";
    }

    static public function supportAmount(lang:Language) return switch (lang) {
        case English: "Support amount";
        case Cantonese | Chinese: "支持金額";
    }

    static public function creditCard(lang:Language) return switch (lang) {
        case English: "Credit card";
        case Cantonese | Chinese: "信用卡";
    }

    static public function pledgeAmountVisibility(lang:Language) return switch (lang) {
        case English: "Contribution amount visibility";
        case Cantonese | Chinese: "付出金額顯示設定";
    }

    static public function pledgeAmountVisibilityNote(lang:Language) return switch (lang) {
        case English: "You can choose whether you want to show your contribution amount after the wish completes.";
        case Cantonese: "你可以選擇性喺願望達成後公開你付出嘅金額.";
        case Chinese: "你可以選擇性在願望達成後公開你付出的金額.";
    }

    static public function pledgeNameVisibility(lang:Language) return switch (lang) {
        case English: "Contributor name visibility";
        case Cantonese | Chinese: "支持者名稱顯示設定";
    }

    static public function pledgeNameVisibilityNote(lang:Language) return switch (lang) {
        case English: "You can choose whether you want to show your name as contributor after the wish completes.";
        case Cantonese: "你可以選擇性喺願望達成後公開你嘅支持身分.";
        case Chinese: "你可以選擇性在願望達成後公開你的支持身分.";
    }

    static public function agreeTo(lang:Language, something:ReactElement) return MakeAWish.agreeTo(lang, something);
    static public function termsAndConditions(lang:Language) return MakeAWish.termsAndConditions(lang);
    static public function submit(lang:Language) return MakeAWish.submit(lang);

    static public function bibbidiBobbidiBoom(lang:Language) return switch (lang) {
        case English: "Bibbidi Bobbidi Boom!";
        case Cantonese | Chinese: "嗎哩嗎哩空!";
    }

    static public function wishFulfilled(lang:Language) return switch (lang) {
        case English: "Wish fulfilled!";
        case Cantonese | Chinese: "願望達成!";
    }

    static public function greatThanksForTheFollowingFriends(lang:Language) return switch (lang) {
        case English: "Great thanks for the following friends!";
        case Cantonese: "多謝以下有夾份嘅朋友!";
        case Chinese: "多謝以下有湊錢的朋友!";
    }

    static public function supportersWithVisibleSupportAmounts(lang:Language) return switch (lang) {
        case English: "Supporters with visible support amounts.";
        case Cantonese: "選擇顯示金額嘅支持者.";
        case Chinese: "選擇顯示金額的支持者.";
    }

    static public function supportersWithHiddenSupportAmounts(lang:Language) return switch (lang) {
        case English: "Supporters with hidden support amounts. Sorted by support amount in descending order.";
        case Cantonese: "選擇隱藏金額嘅支持者. 以付出金額多至少排列.";
        case Chinese: "選擇隱藏金額的支持者. 以付出金額多至少排列.";
    }

    static public function badgeSucceeded(lang:Language) return switch (lang) {
        case English: "succeeded";
        case Cantonese | Chinese: "已達成";
    }

    static public function badgeUnpublished(lang:Language) return switch (lang) {
        case English: "unpublished";
        case Cantonese | Chinese: "未發佈";
    }

    static public function badgeCancelled(lang:Language) return switch (lang) {
        case English: "cancelled";
        case Cantonese | Chinese: "已取消";
    }

    static public function copy(lang:Language) return switch (lang) {
        case English: "copy";
        case Cantonese | Chinese: "複製";
    }

    static public function copied(lang:Language) return switch (lang) {
        case English: "copied";
        case Cantonese | Chinese: "已複製";
    }

    static public function copyPermalink(lang:Language) return switch (lang) {
        case English: "copy permalink";
        case Cantonese | Chinese: "複製願望連結";
    }

    static public function copiedPermalink(lang:Language) return switch (lang) {
        case English: "copied permalink";
        case Cantonese | Chinese: "已複製願望連結";
    }

    static public function howCanYouSupport(lang:Language) return switch (lang) {
        case English: "How can you support?";
        case Cantonese: "點幫手?";
        case Chinese: "怎幫忙?";
    }

    static public function shareTheWishWithYourFriends(lang:Language) return switch (lang) {
        case English: "Share the wish with your friends.";
        case Cantonese: "話俾身邊嘅朋友知.";
        case Chinese: "通知身邊的朋友.";
    }

    static public function pledgeTheWishSinceEveryDollarMatters(lang:Language) return switch (lang) {
        case English: "Pledge the wish, since every $1 matters.";
        case Cantonese: "現金支持. 每一蚊都好有用.";
        case Chinese: "現金支持. 每一塊都有用.";
    }

    static public function pledgeNow(lang:Language) return switch (lang) {
        case English: "Pledge Now";
        case Cantonese: "即刻夾份";
        case Chinese: "立即湊錢";
    }

    static public function pledgeBelow(lang:Language) return switch (lang) {
        case English: "Pledge Below";
        case Cantonese: "即刻夾份";
        case Chinese: "立即湊錢";
    }

    static public function wishSettings(lang:Language) return switch (lang) {
        case English: "Settings";
        case Cantonese | Chinese: "設定";
    }

    static public function useACoupon(lang:Language) return switch (lang) {
        case English: "Use a Coupon";
        case Cantonese | Chinese: "使用優惠券";
    }

    static public function useAnyCouponCodeYouReceived(lang:Language) return switch (lang) {
        case English: "Use any coupon code you received.";
        case Cantonese: "輸入你收到嘅優惠券.";
        case Chinese: "輸入你收到的優惠券.";
    }

    static public function apply(lang:Language) return switch (lang) {
        case English: "Apply";
        case Cantonese | Chinese: "使用";
    }

    static public function editWish(lang:Language) return EditWish.editWish(lang);

    static public function editWishNote(lang:Language) return switch (lang) {
        case English: "You may edit the wish info, but not the items.";
        case Cantonese: "除咗願望清單中嘅項目, 其他願望資料都可以修改.";
        case Chinese: "除了願望清單中的項目, 其他願望資料都可以修改.";
    }

    static public function cancelTheWish(lang:Language) return switch (lang) {
        case English: "Cancel the Wish";
        case Cantonese | Chinese: "取消願望";
    }

    static public function cancelWishNote(lang:Language) return switch (lang) {
        case English: "Once cancelled, all existing pledges will be refunded to the supporters. The action cannot be undone.";
        case Cantonese: "取消願望後, Giffon會退回全數承諾金額俾支持者. 取消動作唔可能還原.";
        case Chinese: "取消願望後, Giffon會退回全數承諾金額給支持者. 取消動作不可能還原.";
    }
    static public function cancelWish(lang:Language) return switch (lang) {
        case English: "Cancel Wish";
        case Cantonese | Chinese: "取消願望";
    }
}