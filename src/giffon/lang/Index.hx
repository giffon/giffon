package giffon.lang;

class Index {
    static public function htmlTitle(lang:Language) return switch (lang) {
        case English: "Giffon: A crowd-gifting platform";
        case Cantonese: "Giffon 夾份禮物眾籌";
        case Chinese: "Giffon 禮物眾籌";
    }

    static public function htmlDescription(lang:Language) return switch (lang) {
        case English: "A crowd-gifting platform where you can state what you want and let your friends collectively buy it as a gift for you.";
        case Cantonese: "任何人都可以上嚟許願, 等朋友夾份買禮物送俾你嘅禮物眾籌平台.";
        case Chinese: "任何人都可以上來許願, 讓朋友湊錢買禮物送你的禮物眾籌平台.";
    }

    static public function slogan(lang:Language) return switch (lang) {
        case English: "All About Trust";
        case Cantonese: "講個信字";
        case Chinese: "講個信字";
    }

    static public function title(lang:Language) return switch (lang) {
        case English: "Crowd-funding platform\nthat tells the way\nmoney is really spent.";
        case Cantonese: "會話你知錢去左邊既眾籌平台";
        case Chinese: "會告訴你錢去哪了的眾籌平台";
    }

    static public function browseAllWishes(lang:Language) return switch (lang) {
        case English: "Browse All Wishes";
        case Cantonese: "睇晒所有願望";
        case Chinese: "瀏覽所有願望";
    }

    static public function honestyLyrics(lang:Language) return switch (lang) {
        case English : "Honesty is hardly ever heard\nAnd mostly what I need from you ♪";
        case Cantonese | Chinese : "請相信我哋\n請珍惜我哋\n來年多點人情味 ♪";
    }
    
    static public function desp(lang:Language) return switch (lang) {
        case English: "Whenever people talk about charities and crowd-funding, they often hesitate about donation. The reason is that there are too many scandals around tech startups and non-profits, like Kickstarter campaigns not able to fulfill product delivery and their founders disappeared, or charities took a cut too much for “operational costs”. It is similar to how Hong Kong pedestrians avoid flag-sellers because they know too little about the flag-selling organizations.\n\n";
        case Cantonese: "每當有人討論慈善團體或者眾籌，都會猶豫捐唔捐錢。最主要既原因，係因為以往有好多關於初創公司同非牟利團體既醜聞，例如 Kickstarter 走數事件，或者慈善機構的大額營運成本。最貼近生活既例子，就係平日街上見到賣旗活動，行人都會因為團體不明來歷而避開唔買。";
        case Chinese: "每當有人討論慈善團體或者眾籌，都會猶豫捐唔捐錢。最主要既原因，係因為以往有好多關於初創公司同非牟利團體既醜聞，例如 Kickstarter 走數事件，或者慈善機構的大額營運成本。最貼近生活既例子，就係平日街上見到賣旗活動，行人都會因為團體不明來歷而避開唔買。";
    }

    static public function despBold(lang:Language) return switch (lang) {
        case English: "\nWe come up with a solution to tackle this problem of trust.";
        case Cantonese: "為左解決信任既問題，我地諗左個辦法。";
        case Chinese: "為左解決信任既問題，我地諗左個辦法。";
    }

    static public function howToStart(lang:Language) return switch (lang) {
        case English: "How Giffon Works";
        case Cantonese: "點樣用 Giffon?";
        case Chinese: "怎樣用 Giffon?";
    }

    static public function howToDesp(lang:Language) return switch (lang) {
        case English: "As simple as 🎂";
        case Cantonese: "食件餅咁簡單";
        case Chinese: "就是小菜一碟";
    }

    static public function howToStep1Title(lang:Language) return switch (lang) {
        case English: "1. Create a Wish";
        case Cantonese: "1. 創造你既願望";
        case Chinese: "1. 創造你的願望";
    }

    static public function howToStep1(lang:Language) return switch (lang) {
        case English: "User creates a wish on Giffon, states the exact items in need.";
        case Cantonese: "用戶許一個願望，要寫明需要既物品";
        case Chinese: "用戶許一個願望，要寫明需要的物品";
    }

    static public function howToStep2Title(lang:Language) return switch (lang) {
        case English: "2. Find Supporters";
        case Cantonese: "2. 搵人幫下手";
        case Chinese: "2. 尋找支持者";
    }

    static public function howToStep2(lang:Language) return switch (lang) {
        case English: "User can write their stores behind, find supporters to chip in, with no fixed amount.";
        case Cantonese: "用戶可以寫低背後既小故事，請廣傳搵人夾份，金額不限";
        case Chinese: "用戶可以寫下背後的小故事，尋找支持者湊錢，金額不限";
    }

    static public function howToStep3Title(lang:Language) return switch (lang) {
        case English: "3. Reach the Goal";
        case Cantonese: "3. 願望成真";
        case Chinese: "3. 願望成真";
    }

    static public function howToStep3(lang:Language) return switch (lang) {
        case English: "Once suceeded, Giffon will order and send the items to user.";
        case Cantonese: "願望成真個陣，Giffon 會立即安排送出禮物!";
        case Chinese: "當願望成真，Giffon 會立即安排送出禮物!";
    }

    static public function wishSucceed(lang:Language) return switch (lang) {
        case English: "Once a wish is success, gifts will be delivered to wish owner!";
        case Cantonese: "願望成真個陣，Giffon 會立即安排送出禮物!";
        case Chinese: "當願望成真，Giffon 會立即安排送出禮物!";
    }

    static public function whyGiffon(lang:Language) return switch (lang) {
        case English: "Why Giffon?";
        case Cantonese: "點解用 Giffon?";
        case Chinese: "為何用 Giffon?";
    }

    static public function note1Title(lang:Language) return switch (lang) {
        case English: "Every Dollar Counts";
        case Cantonese: "每一蚊都係錢";
        case Chinese: "一塊錢都是錢";
    }

    static public function note1(lang:Language) return switch (lang) {
        case English: "Users in Giffon are free to support with NO fixed amount. Feel free :)";
        case Cantonese: "用家可以隨心意支持願望，多少無拘。";
        case Chinese: "用家可以隨心意支持願望，多少無拘。";
    }

    static public function note2Title(lang:Language) return switch (lang) {
        case English: "Make it Trustworthy";
        case Cantonese: "值得信任";
        case Chinese: "值得信任";
    }

    static public function note2(lang:Language) return switch (lang) {
        case English: "Wish owners receive exact gifts but not money, you know exactly where the money goes.";
        case Cantonese: "許願既人直接收到禮物而唔係錢，你可以知道筆錢使左去邊。";
        case Chinese: "許願的人直接收到禮物而不是金錢，你可以知道款項用在哪。";
    }

    static public function note3Title(lang:Language) return switch (lang) {
        case English: "We handle it all";
        case Cantonese: "幫你搞掂晒";
        case Chinese: "幫你辦妥一切";
    }

    static public function note3(lang:Language) return switch (lang) {
        case English: "We help to handle the purchase and shipment, more carefree for the supporters and owner.";
        case Cantonese: "我地會幫手購買同運送禮物，大家唔使麻煩。";
        case Chinese: "我們會幫忙購買及運送禮物，大家不用掛心。";
    }

    static public function note4Title(lang:Language) return switch (lang) {
        case English: "Peace of Mind";
        case Cantonese: "私隱保障";
        case Chinese: "私隱保障";
    }

    static public function note4(lang:Language) return switch (lang) {
        case English: "We provide anonymous options, and no card number will be saved.";
        case Cantonese: "我地有不記名選項，亦唔會儲存信用卡號碼。";
        case Chinese: "我們有不記名的選項，也不會儲存信用卡號碼。";
    }

    



    static public function makeAWishNow(lang:Language) return switch (lang) {
        case English: "Make a Wish Now";
        case Cantonese | Chinese: "立即許願";
    }

    static public function recentWishes(lang:Language) return switch (lang) {
        case English: "Recent wishes";
        case Cantonese | Chinese: "最新願望";
    }

    static public function support(lang:Language) return switch (lang) {
        case English: "Support!";
        case Cantonese | Chinese: "支持!";
    }

    static public function whyWish(lang:Language) return switch (lang) {
        case English: "Why make wishes on Giffon?";
        case Cantonese: "用Giffon許願有咩好?";
        case Chinese: "用Giffon許願有甚麼好?";
    }

    static public function forWishMakers(lang:Language) return switch (lang) {
        case English: "For Wish Makers";
        case Cantonese | Chinese: "對於許願者";
    }

    static public function getExactGift(lang:Language) return switch (lang) {
        case English: "get exactly what you want, every single time";
        case Cantonese: "每次收到都係你想要嘅禮物";
        case Chinese: "每次收到都是你想要的禮物";
    }

    static public function peopleWantToGift(lang:Language) return switch (lang) {
        case English: "people want to gift you, they just don\'t know what to buy";
        case Cantonese: "大家其實都會想送野俾你, 只係唔知送咩好";
        case Chinese: "大家其實都會想送禮給你, 只是不知道該送甚麼";
    }

    static public function noUselessGift(lang:Language) return switch (lang) {
        case English: "no longer need to deal with gifts that have no value to you";
        case Cantonese: "無需再操心處理無用嘅禮物";
        case Chinese: "無需再操心處理無用的禮物";
    }

    static public function getWantYouWantForFree(lang:Language) return switch (lang) {
        case English: "get what you want for free";
        case Cantonese: "免費得到你想要嘅野";
        case Chinese: "免費得到你想要的東西";
    }

    static public function whySupportFriendsOnGiffon(lang:Language) return switch (lang) {
        case English: "Why support friends on Giffon?";
        case Cantonese: "用Giffon夾份送禮有咩好?";
        case Chinese: "用Giffon湊錢送禮有甚麼好?";
    }

    static public function forSupporters(lang:Language) return switch (lang) {
        case English: "For Supporters";
        case Cantonese | Chinese: "對於支持者";
    }

    static public function showAppreciation(lang:Language) return switch (lang) {
        case English: "show that you are thankful, appreciating someone";
        case Cantonese: "向你嘅對象表達感謝";
        case Chinese: "向你的對象表達感謝";
    }

    static public function moneySpentForMakingReceiverHappy(lang:Language) return switch (lang) {
        case English: "your money spent is going to make the receiver happy";
        case Cantonese: "你嘅捐款會用喺啱嘅禮物上面";
        case Chinese: "你的捐款會用在正確的禮物上";
    }

    static public function aGoodGiftIsNeverTooExpensive(lang:Language) return switch (lang) {
        case English: "a good gift is never too expensive once your friends chip in";
        case Cantonese: "夾份就唔使擔心禮物太貴";
        case Chinese: "湊錢就不用擔心禮物太貴";
    }

    static public function giftInsteadOfMoney(lang:Language) return switch (lang) {
        case English: "be sure your loved one will receive the nice gift instead of money that may be spent on cigarettes";
        case Cantonese: "確保你嘅對象係會收到指定嘅禮物, 唔會拎咗錢去用喺其他地方";
        case Chinese: "確保你的對象會收到指定禮物, 不會把錢花在其他地方";
    }

/*
    static public function (lang:Language) return switch (lang) {
        case English: "";
        case Cantonese: "";
    }
*/
}