package giffon.lang;

import react.*;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class UseCasesOssDevs {
    static public function titleTag(lang:Language) return switch (lang) {
        case English: 'For Open Source Software Developers';
        case Cantonese: 'Giffon點樣幫到開源軟件開發者?';
    }

    static public function titleHeader(lang:Language) return switch (lang) {
        case English: 'Giffon for Open Source Software Developers';
        case Cantonese: 'Giffon點樣幫到開源軟件開發者?';
    }

    static public function introText(lang:Language) return switch (lang) {
        case English: jsx('
            <Fragment>
                <p>
                    There are many devs work on open source projects in their spare time. 
                    Those projects can be useful to a lot of people, yet it is still hard to make a living just by building open source works. 
                    Eventually, people are tired and projects go unmaintained <span className="ec ec-weary"></span>.
                </p>
                <p>
                    Giffon provides users an easy way to show their appreciation to the open source developers. 
                    The open source community as a whole can keep the good vibes, avoid developer burnout, and build the next-big-thing together <span className="ec ec-dark-sunglasses"></span>.
                </p>
                <p>
                    <a href="make-a-wish">Make a wish</a> in Giffon and let the community buy you a gift!
                </p>
            </Fragment>
        ');
        case Cantonese: jsx('
            <Fragment>
                <p>
                    有好多開發者都會用自己嘅空閒時間嚟做開源項目. 
                    而呢啲開源項目對好多大小公司都好有用, 但大多數開源項目本質上都係免費, 開發者淨做開源項目實在難以維持生計. 
                    往往開發者喺缺乏動力嘅情況下, 啲開源項目就慢慢停濟不前無人維護 <span className="ec ec-weary"></span>.
                </p>
                <p>
                    Giffon俾用家一個途徑去向開發者表達謝意. 
                    整個開源社群可以透過互相送禮維持一個良好嘅氣氛, 一齊去開發同維護各個好玩又有用嘅項目 <span className="ec ec-dark-sunglasses"></span>.
                </p>
                <p>
                    而家就喺Giffon<a href="make-a-wish">許願</a>講低你需要啲咩, 等大家夾份買俾你!
                </p>
            </Fragment>
        ');
    }

    static public function coupon(lang:Language) return switch (lang) {
        case English: 'Coupon';
        case Cantonese: '優惠券';
    }

    static public function couponDetail(lang:Language) return switch (lang) {
        case English: jsx('
            <Fragment>
                <p>Use the coupon code <span className="d-inline border bg-light p-1">OSS_ROCKS_JULY</span> on your wish to instantly get a 35 HKD or 5 USD pledge from Giffon.</p>
                <p className="text-muted mb-0">Applicable only to users connected with a GitHub or GitLab account. Valid until 2019-07-31. Limited quota: 50 users only!</p>
            </Fragment>
        ');
        case Cantonese: jsx('
            <Fragment>
                <p>喺你嘅願望輸入 <span className="d-inline border bg-light p-1">OSS_ROCKS_JULY</span> 就可以立即從Giffon得到35港元或5美金嘅支持.</p>
                <p className="text-muted mb-0">只適用於有連結GitHub或GitLab帳號嘅用家. 2019-07-31前使用. 限額: 50人.</p>
            </Fragment>
        ');
    }

    static public function wishIdeas(lang:Language) return UseCasesVideoCreators.wishIdeas(lang);

    static public function wishIdeasIntro(lang:Language) return switch (lang) {
        case English: 'Here are some goodies that can be useful to open source developers.';
        case Cantonese: '以下幾樣嘢應該會幾啱開源軟件開發者.';
    }

    static public function ideLicense(lang:Language) return switch (lang) {
        case English: 'IDE License';
        case Cantonese: '開發軟件';
    }

    static public function ideLicenseDescription(lang:Language) return switch (lang) {
        case English: 'Get a license to use the pro version of a good IDE to enhance development. JetBrains? Sublime? Visual Studio? Your choice.';
        case Cantonese: '用專業版開發軟件, 事半功倍. JetBrains? Sublime? Visual Studio? 隨你喜歡.';
    }

    static public function upgradeYourComputer(lang:Language) return switch (lang) {
        case English: 'Upgrade your computer';
        case Cantonese: '升級你部電腦';
    }

    static public function upgradeYourComputerDescription(lang:Language) return switch (lang) {
        case English: 'A faster computer means less waiting time during development. Stay in the zone.';
        case Cantonese: '部機行快啲, 少啲等待嘅時間. 維持最高嘅工作效率.';
    }

    static public function devSwags(lang:Language) return switch (lang) {
        case English: 'Dev Swags';
        case Cantonese: '開發者紀念品';
    }

    static public function devSwagsDescription(lang:Language) return switch (lang) {
        case English: 'Show off the love of your favourite projects by putting their logo stickers on your laptop, wearing branded T-shirts, hugging mascot stuffed animals.';
        case Cantonese: '喺你嘅手提電腦貼上你喜愛嘅開發項目logo貼紙, 着上IT品牌T-shirt, 抱一下IT吉祥物公仔.';
    }

    static public function makeAWishNow(lang:Language) return Index.makeAWishNow(lang);

    static public function howDoesGiffonCompareToOtherServices(lang:Language) return UseCasesVideoCreators.howDoesGiffonCompareToOtherServices(lang);

    static public function goodForIndividuals(lang:Language) return switch (lang) {
        case English: 'Good for individuals';
        case Cantonese: '適合開發者個人';
    }

    static public function developersReceiveGifts(lang:Language) return switch (lang) {
        case English: 'Developers receive gifts';
        case Cantonese: '開發者收實質禮物';
    }

    static public function developersReceiveGiftsDescription(lang:Language) return switch (lang) {
        case English: 'It is more likely for people to contribute if they know how their money will be spent.';
        case Cantonese: '知道捐出嚟嘅錢係會用嚟買咩, 大家會更放心捐.';
    }

    static public function serviceFeeAmount(lang:Language) return switch (lang) {
        case English: '${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% fee';
        case Cantonese: '${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% 服務費';
    }

    static public function serviceFeeAmountDescription(lang:Language) return switch (lang) {
        case English: 'The service charge is ${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% of the wish value, paid by contributions. Giffon is 100% free for developers.';
        case Cantonese: '服務費喺願望總值嘅 ${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}%, 由支持者夾份支付. Giffon唔會收取開發者任何費用.';
    }

    static public function projectTeamBased(lang:Language) return switch (lang) {
        case English: 'Project/team-based';
        case Cantonese: '適合個別項目/開發團隊';
    }

    static public function projectsTeamsReceiveMoney(lang:Language) return switch (lang) {
        case English: 'Projects/teams receive money';
        case Cantonese: '項目/團隊收錢';
    }

    static public function projectsTeamsReceiveMoneyDescription(lang:Language) return switch (lang) {
        case English: 'People state how the money is spent, but there is no enforcement or verification.';
        case Cantonese: '項目/團隊可以表示會點樣用啲錢, 但無任何機制驗證.';
    }

    static public function openCollectiveFees(lang:Language) return switch (lang) {
        case English: '5 or 10% + payment processor fees + payout fees';
        case Cantonese: '5或10%服務費 + 支付處理費 + 提款費用';
    }

    static public function openCollectiveFeesDescription(lang:Language) return switch (lang) {
        case English: '5 or 10% depended on handling method, plus roughly 3-5% payment processor fees, plus payout fees.';
        case Cantonese: '視乎選用服務計劃收取5或10%服務費, 另加3至5%支付處理費, 另加提款費用.';
    }

    static public function individualsReceiveMoney(lang:Language) return switch (lang) {
        case English: 'Individuals receive money';
        case Cantonese: '開發者收錢';
    }

    static public function individualsReceiveMoneyDescription(lang:Language) return switch (lang) {
        case English: 'Contributors do not know how their money contribution is spent.';
        case Cantonese: '支持者唔會知道啲錢會用去邊.';
    }

    static public function gitHubSponsorsFees(lang:Language) return switch (lang) {
        case English: 'Unknown processing fees apply (in the future)';
        case Cantonese: '未來收費不明';
    }

    static public function gitHubSponsorsFeesDescription(lang:Language) return switch (lang) {
        case English: jsx('
            <Fragment>GitHub Sponsors is free in its first year, but it <a href="https://help.github.com/en/articles/about-github-sponsors#about-the-github-sponsors-matching-fund" target="_blank" rel="noopener">stated</a> it may charge a nominal processing fee in the future.</Fragment>
        ');
        case Cantonese: jsx('
            <Fragment>GitHub Sponsors面世後頭一年免費, 但GitHub已<a href="https://help.github.com/en/articles/about-github-sponsors#about-the-github-sponsors-matching-fund" target="_blank" rel="noopener">表明</a>期後會收取費用.</Fragment>
        ');
    }
}