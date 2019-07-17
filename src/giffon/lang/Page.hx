package giffon.lang;

class Page {
    static public function termsAndConditions(lang:Language) return switch (lang) {
        case English: "Terms and Conditions";
        case Cantonese: "使用條款";
    }

    static public function privacyPolicy(lang:Language) return switch (lang) {
        case English: "Privacy Policy";
        case Cantonese: "私隱政策";
    }
}