package giffon.lang;

import react.*;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class User {
    static public function wishesInProgress(lang:Language) return switch (lang) {
        case English: "Wishes in Progress";
        case Cantonese: "未達成嘅願望";
    }

    static public function noWishesInProgress(lang:Language) return switch (lang) {
        case English: "No wishes in progress.";
        case Cantonese: "未有未達成嘅願望.";
    }

    static public function makeOneNow(lang:Language) return switch (lang) {
        case English: "Make one now";
        case Cantonese: "即刻許個願";
    }

    static public function completedWishes(lang:Language) return switch (lang) {
        case English: "Completed Wishes";
        case Cantonese: "已達成嘅願望";
    }

    static public function noCompletedWishes(lang:Language) return switch (lang) {
        case English: "No completed wishes.";
        case Cantonese: "未有已達成嘅願望.";
    }

    static public function cancelledWishes(lang:Language) return switch (lang) {
        case English: "Cancelled Wishes";
        case Cantonese: "已取消嘅願望";
    }

    static public function noCancelledWishes(lang:Language) return switch (lang) {
        case English: "No cancelled wishes.";
        case Cantonese: "未有已取消嘅願望.";
    }

    static public function cancelledWishesNote(lang:Language) return switch (lang) {
        case English: "Only wish owners can see their list of cancelled wishes.";
        case Cantonese: "只有許願者可以睇到佢嘅已取消願望清單.";
    }
}