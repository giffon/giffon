package giffon.lang;

import giffon.lang.Language;

class LanguageTools {
    static public function code(lang:Language) return switch (lang) {
        case English: "en";
        case Cantonese: "zh-HK";
        case Chinese: "zh-TW";
    }

    static public function langFromCode(code:String) return switch (code) {
        case "en" | "en-US":
            English;
        case "zh" | "zh-TW":
            Chinese;
        case "zh-HK":
            Cantonese;
        case _:
            trace('Unsupported lang: $code');
            English;
    }
}