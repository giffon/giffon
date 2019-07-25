package giffon.lang;

import react.*;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class MakeAWish {
    static public function makeAWish(lang:Language) return switch (lang) {
        case English: "Make a wish";
        case Cantonese | Chinese: "許願";
    }

    static public function myWish(lang:Language) return switch (lang) {
        case English: "My wish";
        case Cantonese | Chinese: "我的願望";
    }

    static public function title(lang:Language) return switch (lang) {
        case English: "Title";
        case Cantonese: "願望名";
        case Chinese: "願望名稱";
    }

    static public function currency(lang:Language) return switch (lang) {
        case English: "Currency";
        case Cantonese | Chinese: "貨幣";
    }

    static public function whatDoYouWant(lang:Language) return switch (lang) {
        case English: "What do you want?";
        case Cantonese: "你想要咩?";
        case Chinese: "你想要甚麼?";
    }

    static public function itemHelp(lang:Language, onlineShopTags:Array<ReactElement>) return switch (lang) {
        case English: jsx('
            <Fragment>
                Paste the online shopping link of the item you wanna receive. 
                For example, any items on ${onlineShopTags} or any online stores that can ship to your address.
            </Fragment>
        ');
        case Cantonese: jsx('
            <Fragment>
                輸入你想要嘅物品嘅網店連結. 網店可以係 ${onlineShopTags} 或者任何支援送貨到你屋企嘅網上商店.
            </Fragment>
        ');
        case Chinese: jsx('
            <Fragment>
                輸入你想要的物品的網店連結. 網店可以是 ${onlineShopTags} 或者任何支援送貨到你家的網上商店.
            </Fragment>
        ');
    }

    static public function addItem(lang:Language) return switch (lang) {
        case English: "Add item";
        case Cantonese | Chinese: "增加物品";
    }

    static public function itemName(lang:Language) return switch (lang) {
        case English: "Item name";
        case Cantonese | Chinese: "物品名稱";
    }

    static public function itemURL(lang:Language) return switch (lang) {
        case English: "Item URL";
        case Cantonese | Chinese: "連結";
    }

    static public function unitPrice(lang:Language) return switch (lang) {
        case English: "Unit price";
        case Cantonese | Chinese: "單價";
    }

    static public function quantity(lang:Language) return switch (lang) {
        case English: "Quantity";
        case Cantonese | Chinese: "數量";
    }

    static public function additionalCost(lang:Language) return switch (lang) {
        case English: "Additional cost";
        case Cantonese | Chinese: "其他費用";
    }

    static public function additionalCostPlaceHolder(lang:Language) return switch (lang) {
        case English: "e.g. standard shipping or priority shipping";
        case Cantonese | Chinese: "運費, 快件等等";
    }

    static public function additionalCostAmount(lang:Language) return switch (lang) {
        case English: "Amount";
        case Cantonese | Chinese: "其他費用金額";
    }

    static public function totalPrice(lang:Language) return switch (lang) {
        case English: "Total price";
        case Cantonese | Chinese: "總值";
    }

    static public function whyDoYouWantTheAbove(lang:Language) return switch (lang) {
        case English: "Why do you want the above?";
        case Cantonese: "點解想要?";
        case Chinese: "為甚麼想要?";
    }

    static public function because(lang:Language) return switch (lang) {
        case English: "Because...";
        case Cantonese | Chinese: "因為...";
    }

    static public function targetDate(lang:Language) return switch (lang) {
        case English: "Target date";
        case Cantonese | Chinese: "目標達成日期";
    }

    static public function targetDateNote(lang:Language) return switch (lang) {
        case English: "This is just a hint for your friends to know. You can always complete the wish early/late.";
        case Cantonese: "目標只係一個俾大家嘅提示. 你可以提早或者延遲達成願望.";
        case Chinese: "目標只是一個給大家的提示. 你可以提早或者延遲達成願望.";
    }

    static public function optional(lang:Language) return switch (lang) {
        case English: "optional";
        case Cantonese | Chinese: "選擇性";
    }

    static public function banner(lang:Language) return switch (lang) {
        case English: "Banner";
        case Cantonese | Chinese: "圖片";
    }

    static public function selectBanner(lang:Language) return switch (lang) {
        case English: "select";
        case Cantonese | Chinese: "選擇";
    }

    static public function replaceBanner(lang:Language) return switch (lang) {
        case English: "replace";
        case Cantonese | Chinese: "更換";
    }

    static public function removeBanner(lang:Language) return switch (lang) {
        case English: "remove";
        case Cantonese | Chinese: "移除";
    }

    static public function addressNote(lang:Language) return switch (lang) {
        case English: "We will ask for your shipping address by email once there is enough pledges collected.";
        case Cantonese: "當收集夠資金, Giffon會經電郵問你收貨地址.";
        case Chinese: "當收集足夠資金, Giffon會經電郵問你收貨地址.";
    }

    static public function couponNote(lang:Language) return switch (lang) {
        case English: "If you have a coupon, you can apply it after the wish is created.";
        case Cantonese: "優惠券可以喺你許願後嘅願望頁面使用.";
        case Chinese: "優惠券可以在你許願後的願望頁面使用.";
    }

    static public function agreeTo(lang:Language, something:ReactElement) return switch (lang) {
        case English: jsx('<Fragment>Agree to ${something}.</Fragment>');
        case Cantonese | Chinese: jsx('<Fragment>同意${something}.</Fragment>');
    }

    static public function termsAndConditions(lang:Language) return Page.termsAndConditions(lang).toLowerCase();

    static public function submit(lang:Language) return switch (lang) {
        case English: "Submit";
        case Cantonese | Chinese: "提交";
    }

/*
    static public function (lang:Language) return switch (lang) {
        case English: "";
        case Cantonese: "";
    }
*/
}