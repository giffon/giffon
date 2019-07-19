package giffon.lang;

import react.*;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class Settings {
    static public function settings(lang:Language) return Page.settings(lang);

    static public function socialAccounts(lang:Language) return switch (lang) {
        case English: "Social Accounts";
        case Cantonese: "帳戶連結";
    }

    static public function authMethodName(lang:Language, auth:giffon.db.AuthMethod) return switch ([auth, lang]) {
        case [Facebook, English]: "Facebook";
        case [Facebook, Cantonese]: "Facebook";
        case [GitHub, English]: "GitHub";
        case [GitHub, Cantonese]: "GitHub";
        case [Twitter, English]: "Twitter";
        case [Twitter, Cantonese]: "Twitter";
        case [GitLab, English]: "GitLab";
        case [GitLab, Cantonese]: "GitLab";
        case [Google, English]: "Google";
        case [Google, Cantonese]: "Google";
        case [YouTube, English]: "YouTube";
        case [YouTube, Cantonese]: "YouTube";
        case [Twitch, English]: "Twitch";
        case [Twitch, Cantonese]: "Twitch";
        case _: throw "Unknown";
    }

    static public function connectTo(lang:Language, auth:giffon.db.AuthMethod) return switch (lang) {
        case English: 'Connect to ${authMethodName(lang, auth)}';
        case Cantonese: '連結 ${authMethodName(lang, auth)}';
    }

    static public function disconnectFrom(lang:Language, auth:giffon.db.AuthMethod) return switch (lang) {
        case English: 'Disconnect from ${authMethodName(lang, auth)}';
        case Cantonese: '中斷連結 ${authMethodName(lang, auth)}';
    }

    static public function name(lang:Language) return switch (lang) {
        case English: "Name";
        case Cantonese: "名字";
    }

    static public function customProfileUrl(lang:Language) return switch (lang) {
        case English: "Custom profile url";
        case Cantonese: "自訂個人網址";
    }

    static public function customProfileUrlNote(lang:Language) return switch (lang) {
        case English: "Case-insensitive. Once set, it can not be changed within 24 hours.";
        case Cantonese: "不區分大小寫. 設定後24小時內不能更改.";
    }

    static public function availableCharacters(lang:Language) return switch (lang) {
        case English: "Available characters";
        case Cantonese: "可用字";
    }

    static public function email(lang:Language) return switch (lang) {
        case English: "Email";
        case Cantonese: "電郵";
    }

    static public function emailNote(lang:Language) return switch (lang) {
        case English: "Giffon will use this email address to ask for your shipping address when your wishes complete.";
        case Cantonese: "當你願望達成嘅時候, Giffon會經你提供嘅電郵去問你禮物收件地址.";
    }

    static public function bio(lang:Language) return switch (lang) {
        case English: "Bio";
        case Cantonese: "自我簡介";
    }

    static public function iAm(lang:Language) return switch (lang) {
        case English: "I am...";
        case Cantonese: "我係...";
    }

    static public function avatar(lang:Language) return switch (lang) {
        case English: "Avatar";
        case Cantonese: "頭像";
    }

    static public function submit(lang:Language) return Wish.submit(lang);
}