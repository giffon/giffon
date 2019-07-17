package giffon.lang;

import giffon.lang.Language;

class LanguageTools {
    static public function code(lang:Language) return switch (lang) {
        case English: "en-US";
        case Cantonese: "zh-HK";
    }

    static public function langFromCode(code:String) return switch (code) {
        case "en-US":
            English;
        case "zh-HK":
            Cantonese;
        case _:
            trace('Unsupported lang: $code');
            English;
    }
}