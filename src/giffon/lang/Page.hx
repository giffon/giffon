package giffon.lang;

class Page {
    static public function makeAWish(lang:Language) return switch (lang) {
        case English: "Make a Wish";
        case Cantonese | Chinese: "許願";
    }

    static public function useCases(lang:Language) return switch (lang) {
        case English: "Use Cases";
        case Cantonese | Chinese: "使用對象";
    }

    static public function forVideoCreators(lang:Language) return switch (lang) {
        case English: "for video creators";
        case Cantonese | Chinese: "影片創作人";
    }

    static public function forOpenSourceDevelopers(lang:Language) return switch (lang) {
        case English: "for open source developers";
        case Cantonese | Chinese: "開源軟件開發者";
    }

    static public function signInUp(lang:Language) return switch (lang) {
        case English: "Sign in / Sign up";
        case Cantonese | Chinese: "登入/注冊";
    }

    static public function settings(lang:Language) return switch (lang) {
        case English: "Settings";
        case Cantonese | Chinese: "設定";
    }

    static public function signOut(lang:Language) return switch (lang) {
        case English: "Sign Out";
        case Cantonese | Chinese: "登出";
    }

    static public function termsAndConditions(lang:Language) return switch (lang) {
        case English: "Terms and Conditions";
        case Cantonese | Chinese: "使用條款";
    }

    static public function privacyPolicy(lang:Language) return switch (lang) {
        case English: "Privacy Policy";
        case Cantonese | Chinese: "私隱政策";
    }

    static public function giffonOnFacebook(lang:Language) return switch (lang) {
        case English: "Giffon on Facebook";
        case Cantonese | Chinese: "Giffon Facebook 專頁";
    }

    static public function giffonOnTwitter(lang:Language) return switch (lang) {
        case English: "Giffon on Twitter";
        case Cantonese | Chinese: "Giffon Twitter 帳號";
    }

    static public function giffonOnInstagram(lang:Language) return switch (lang) {
        case English: "Giffon on Instagram";
        case Cantonese | Chinese: "Giffon Instagram 帳號";
    }

    static public function giffonOnGitLab(lang:Language) return switch (lang) {
        case English: "Giffon on GitLab";
        case Cantonese | Chinese: "Giffon 源碼 (GitLab)";
    }

    static public function socialNetwork(lang:Language) return switch (lang) {
        case English: "Social Network";
        case Cantonese | Chinese: "社交網絡";
    }

    static public function paymentOption(lang:Language) return switch (lang) {
        case English: "Payment Option";
        case Cantonese | Chinese: "付款方式";
    }

    static public function languageOption(lang:Language) return switch (lang) {
        case English: "Language";
        case Cantonese | Chinese: "語言選擇";
    }
}