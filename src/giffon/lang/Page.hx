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
        case Cantonese | Chinese: "Giffon Facebook專頁";
    }

    static public function giffonOnTwitter(lang:Language) return switch (lang) {
        case English: "Giffon on Twitter";
        case Cantonese | Chinese: "Giffon Twitter帳號";
    }

    static public function giffonOnGitLab(lang:Language) return switch (lang) {
        case English: "Giffon on GitLab";
        case Cantonese | Chinese: "Giffon 源碼 (GitLab)";
    }
}