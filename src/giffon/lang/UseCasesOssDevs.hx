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

    static public function multimediaSoftware(lang:Language) return switch (lang) {
        case English: 'Multimedia Software';
        case Cantonese: '多媒體軟件';
    }

    static public function multimediaSoftwareDescription(lang:Language) return switch (lang) {
        case English: 'Get professional graphic/video editing software to produce better works.';
        case Cantonese: '用專業軟件整圖整片都快靚正.';
    }

    static public function makeAWishNow(lang:Language) return Index.makeAWishNow(lang);

    static public function howDoesGiffonCompareToOtherServices(lang:Language) return switch (lang) {
        case English: 'How does Giffon compare to other services?';
        case Cantonese: 'Giffon對比其他類似服務';
    }

    static public function creatorsReceiveGifts(lang:Language) return switch (lang) {
        case English: 'Creators receive gifts';
        case Cantonese: '創作人收實質禮物';
    }

    static public function creatorsReceiveGiftsDescription(lang:Language) return switch (lang) {
        case English: 'It is more likely for people to contribute if they know how their money will be spent.';
        case Cantonese: '知道捐出嚟嘅錢係會用嚟買咩, 大家會更放心捐.';
    }

    static public function serviceFeeAmount(lang:Language) return switch (lang) {
        case English: '${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% fee';
        case Cantonese: '${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% 服務費';
    }

    static public function serviceFeeAmountDescription(lang:Language) return switch (lang) {
        case English: 'The service charge is ${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% of the wish value, paid by contributions. Giffon is 100% free for creators.';
        case Cantonese: '服務費喺願望總值嘅 ${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}%, 由支持者夾份支付. Giffon唔會收取創作人任何費用.';
    }

    static public function noRewardsRequired(lang:Language) return switch (lang) {
        case English: 'No rewards required';
        case Cantonese: '不必提供支持回報';
    }

    static public function noRewardsRequiredDescription(lang:Language) return switch (lang) {
        case English: 'Your work is your contributors\' best reward. Do not get sidetracked for preparing ad hoc swags.';
        case Cantonese: '你嘅作品就係支持者最好嘅回報. 唔好花心機落為整而整嘅紀念品.';
    }

    static public function creatorsReceiveMoney(lang:Language) return switch (lang) {
        case English: 'Creators receive money';
        case Cantonese: '創作人收錢';
    }

    static public function creatorsReceiveMoneyDescription(lang:Language) return switch (lang) {
        case English: 'Contributors do not know how their money contribution is spent.';
        case Cantonese: '支持者唔知道啲錢會用去邊, 未必有信心俾錢.';
    }

    static public function patreonFees(lang:Language) return switch (lang) {
        case English: '5 to 12% + payment processor fees + payout fees';
        case Cantonese: '5至12% + 支付處理費 + 提款費用';
    }

    static public function patreonFeesDescription(lang:Language) return switch (lang) {
        case English: '5 to 12% depended on the plan in use, plus payment processor fees ranged from 2.9-6% + 10-30cents, plus payout fees.';
        case Cantonese: '視乎選用服務計劃收取5至12%服務費, 另加2.9至6%加10至30仙美金支付處理費, 另加提款費用.';
    }

    static public function patronRewardsRecommended(lang:Language) return switch (lang) {
        case English: 'Patron rewards recommended';
        case Cantonese: '建議提供支持回報';
    }

    static public function patronRewardsRecommendedDescription(lang:Language) return switch (lang) {
        case English: 'It is common for creators to prepare many patron-only rewards, which distract creators from their creative work.';
        case Cantonese: '創作人通常都會提供回報俾支持者. 一般都會需要創作人花額外時間同心機製作.';
    }

    static public function kickstarterFees(lang:Language) return switch (lang) {
        case English: '5% + payment processor fees';
        case Cantonese: '5%服務費 + 支付處理費';
    }

    static public function kickstarterFeesDescription(lang:Language) return switch (lang) {
        case English: '5% fee to the funds collected for creators, plus payment processing fees (roughly 3-5%).';
        case Cantonese: '籌得款項5%為服務費, 另加通常為3至5%嘅支付處理費.';
    }

    static public function backerRewardsRecommended(lang:Language) return switch (lang) {
        case English: 'Backer rewards recommended';
        case Cantonese: '建議提供支持回報';
    }

    static public function backerRewardsRecommendedDescription(lang:Language) return switch (lang) {
        case English: 'It is common for creators to prepare many backer rewards, which distract creators from their creative work.';
        case Cantonese: '創作人通常都會提供回報俾支持者. 一般都會需要創作人花額外時間同心機製作.';
    }
}