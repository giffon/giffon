package giffon.lang;

import react.*;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class Settings {
    static public function settings(lang:Language) return Page.settings(lang);

    static public function socialAccounts(lang:Language) return switch (lang) {
        case English: "Social Accounts";
        case Cantonese | Chinese: "帳戶連結";
    }

    static public function authMethodName(lang:Language, auth:giffon.db.AuthMethod) return switch ([auth, lang]) {
        case [Facebook, English]: "Facebook";
        case [Facebook, Cantonese | Chinese]: "Facebook";
        case [GitHub, English]: "GitHub";
        case [GitHub, Cantonese | Chinese]: "GitHub";
        case [Twitter, English]: "Twitter";
        case [Twitter, Cantonese | Chinese]: "Twitter";
        case [GitLab, English]: "GitLab";
        case [GitLab, Cantonese | Chinese]: "GitLab";
        case [Google, English]: "Google";
        case [Google, Cantonese | Chinese]: "Google";
        case [YouTube, English]: "YouTube";
        case [YouTube, Cantonese | Chinese]: "YouTube";
        case [Twitch, English]: "Twitch";
        case [Twitch, Cantonese | Chinese]: "Twitch";
        case _: throw "Unknown";
    }

    static public function connectTo(lang:Language, auth:giffon.db.AuthMethod) return switch (lang) {
        case English: 'Connect to ${authMethodName(lang, auth)}';
        case Cantonese | Chinese: '連結 ${authMethodName(lang, auth)}';
    }

    static public function disconnectFrom(lang:Language, auth:giffon.db.AuthMethod) return switch (lang) {
        case English: 'Disconnect from ${authMethodName(lang, auth)}';
        case Cantonese | Chinese: '中斷連結 ${authMethodName(lang, auth)}';
    }

    static public function labelName(lang:Language) return switch (lang) {
        case English: "Name";
        case Cantonese | Chinese: "名字";
    }

    static public function customProfileUrl(lang:Language) return switch (lang) {
        case English: "Custom profile url";
        case Cantonese | Chinese: "自訂個人網址";
    }

    static public function customProfileUrlNote(lang:Language) return switch (lang) {
        case English: "Case-insensitive. Once set, it can not be changed within 24 hours.";
        case Cantonese | Chinese: "不區分大小寫. 設定後24小時內不能更改.";
    }

    static public function availableCharacters(lang:Language) return switch (lang) {
        case English: "Available characters";
        case Cantonese | Chinese: "可用字";
    }

    static public function email(lang:Language) return switch (lang) {
        case English: "Email";
        case Cantonese | Chinese: "電郵";
    }

    static public function emailNote(lang:Language) return switch (lang) {
        case English: "Giffon will use this email address to ask for your shipping address when your wishes complete.";
        case Cantonese: "當你願望達成嘅時候, Giffon會經你提供嘅電郵去問你禮物收件地址.";
        case Chinese: "當你願望達成時, Giffon會經你提供的電郵去問你禮物收件地址.";
    }

    static public function bio(lang:Language) return switch (lang) {
        case English: "Bio";
        case Cantonese | Chinese: "自我簡介";
    }

    static public function iAm(lang:Language) return switch (lang) {
        case English: "I am...";
        case Cantonese: "我係...";
        case Chinese: "我是...";
    }

    static public function avatar(lang:Language) return switch (lang) {
        case English: "Avatar";
        case Cantonese | Chinese: "頭像";
    }

    static public function submit(lang:Language) return Wish.submit(lang);
}