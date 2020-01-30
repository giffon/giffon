package giffon.lang;

import react.*;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class UseCasesVideoCreators {
    static public function titleTag(lang:Language) return switch (lang) {
        case English: 'For Video Creators';
        case Cantonese: 'Giffon點樣幫到影片創作人?';
        case Chinese: 'Giffon怎樣幫助影片創作人?';
    }

    static public function titleHeader(lang:Language) return switch (lang) {
        case English: 'Giffon for Video Creators';
        case Cantonese: 'Giffon點樣幫到影片創作人?';
        case Chinese: 'Giffon怎樣幫助影片創作人?';
    }

    static public function introText(lang:Language) return switch (lang) {
        case English: jsx('
            <Fragment>
                <p>
                    Producing videos may cost a lot <span className="ec ec-money-with-wings"></span>. You need recording equipments, post-production software, props etc.
                </p>
                <p>
                    Let your fans help you to cut your cost, and to produce better videos <span className="ec ec-video-camera"></span>.
                </p>
                <p>
                    Make a wish in Giffon and let the community buy you a gift!
                </p>
            </Fragment>
        ');
        case Cantonese: jsx('
            <Fragment>
                <p>
                    製作影片要器材, 要後製, 要道具... 真係所費不菲<span className="ec ec-money-with-wings"></span>.
                </p>
                <p>
                    你話如果俾個機會你嘅fans幫輕吓, 等你可以出條高質啲嘅片<span className="ec ec-video-camera"></span>, 大家都開心!
                </p>
                <p>
                    而家就喺Giffon許願講低你需要啲咩, 等大家夾份買俾你!
                </p>
            </Fragment>
        ');
        case Chinese: jsx('
            <Fragment>
                <p>
                    製作影片要器材, 要後製, 要道具... 真的所費不菲<span className="ec ec-money-with-wings"></span>.
                </p>
                <p>
                    試想給你的粉絲一個機會資助一下, 讓你可以製作出一段高質的影片<span className="ec ec-video-camera"></span>, 大家都開心!
                </p>
                <p>
                    現在就在Giffon許願說出你的需要, 讓大家湊錢買給你!
                </p>
            </Fragment>
        ');
    }

    static public function wishIdeas(lang:Language) return switch (lang) {
        case English: 'Wish ideas';
        case Cantonese: '許個咩願好?';
        case Chinese: '許甚麼願好?';
    }

    static public function wishIdeasIntro(lang:Language) return switch (lang) {
        case English: 'Here are some goodies that can be useful to video creators.';
        case Cantonese: '以下幾樣嘢應該會幾啱影片創作人.';
        case Chinese: '以下幾件好物挺適合影片創作人.';
    }

    static public function studioMicrophone(lang:Language) return switch (lang) {
        case English: 'Studio Microphone';
        case Cantonese: '專業錄音室咪';
        case Chinese: '專業錄音器材';
    }

    static public function studioMicrophoneDescription(lang:Language) return switch (lang) {
        case English: 'Your fans deserve hearing you in good quality.';
        case Cantonese: '等觀眾可以聽清楚你把靚聲.';
        case Chinese: '讓觀眾可以聽清楚你迷人聲線.';
    }

    static public function actionCamera(lang:Language) return switch (lang) {
        case English: 'Action Camera';
        case Cantonese | Chinese: '戶外錄影器材';
    }

    static public function actionCameraDescription(lang:Language) return switch (lang) {
        case English: 'Your outdoor action looks different with a professional action camera.';
        case Cantonese: '用專業器材拍出嚟嘅畫面就係唔一樣.';
        case Chinese: '用專業器材拍出來的畫面就是不一樣.';
    }

    static public function multimediaSoftware(lang:Language) return switch (lang) {
        case English: 'Multimedia Software';
        case Cantonese | Chinese: '多媒體軟件';
    }

    static public function multimediaSoftwareDescription(lang:Language) return switch (lang) {
        case English: 'Get professional graphic/video editing software to produce better works.';
        case Cantonese: '用專業軟件整圖整片都快靚正.';
        case Chinese: '用專業軟件製圖製片都快捷精巧.';
    }

    static public function makeAWishNow(lang:Language) return Index.makeAWishNow(lang);

    static public function howDoesGiffonCompareToOtherServices(lang:Language) return switch (lang) {
        case English: 'How does Giffon compare to other services?';
        case Cantonese | Chinese: 'Giffon對比其他類似服務';
    }

    static public function creatorsReceiveGifts(lang:Language) return switch (lang) {
        case English: 'Creators receive gifts';
        case Cantonese | Chinese: '創作人收實質禮物';
    }

    static public function creatorsReceiveGiftsDescription(lang:Language) return switch (lang) {
        case English: 'It is more likely for people to contribute if they know how their money will be spent.';
        case Cantonese: '知道捐出嚟嘅錢係會用嚟買咩, 大家會更放心捐.';
        case Chinese: '知道捐出來的資金會用來買甚麼, 大家會更放心捐助.';
    }

    static public function serviceFeeAmount(lang:Language) return switch (lang) {
        case English: '${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% fee';
        case Cantonese | Chinese: '${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% 服務費';
    }

    static public function serviceFeeAmountDescription(lang:Language) return switch (lang) {
        case English: 'The service charge is ${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}% of the wish value, paid by contributions. Giffon is 100% free for creators.';
        case Cantonese: '服務費喺願望總值嘅 ${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}%, 由支持者夾份支付. Giffon唔會收取創作人任何費用.';
        case Chinese: '服務費是願望總值的 ${(giffon.ChargeInfo.serviceChargeRate*100).trim().toString()}%, 由支持者湊合支付. Giffon不會收取創作人任何費用.';
    }

    static public function noRewardsRequired(lang:Language) return switch (lang) {
        case English: 'No rewards required';
        case Cantonese | Chinese: '不必提供支持回報';
    }

    static public function noRewardsRequiredDescription(lang:Language) return switch (lang) {
        case English: 'Your work is your contributors\' best reward. Do not get sidetracked for preparing ad hoc swags.';
        case Cantonese: '你嘅作品就係支持者最好嘅回報. 唔好花心機落為整而整嘅紀念品.';
        case Chinese: '你的作品就是支持者最好的回報. 不要花心思在不必要的週邊.';
    }

    static public function creatorsReceiveMoney(lang:Language) return switch (lang) {
        case English: 'Creators receive money';
        case Cantonese | Chinese: '創作人收錢';
    }

    static public function creatorsReceiveMoneyDescription(lang:Language) return switch (lang) {
        case English: 'Contributors do not know how their money contribution is spent.';
        case Cantonese: '支持者唔知道啲錢會用去邊, 未必有信心俾錢.';
        case Chinese: '支持者不知道資金會用在哪, 未必有信心捐助.';
    }

    static public function patreonFees(lang:Language) return switch (lang) {
        case English: '5 to 12% + payment processor fees + payout fees';
        case Cantonese | Chinese: '5至12% + 支付處理費 + 提款費用';
    }

    static public function patreonFeesDescription(lang:Language) return switch (lang) {
        case English: '5 to 12% depended on the plan in use, plus payment processor fees ranged from 2.9-6% + 10-30cents, plus payout fees.';
        case Cantonese | Chinese: '視乎選用服務計劃收取5至12%服務費, 另加2.9至6%加10至30仙美金支付處理費, 另加提款費用.';
    }

    static public function patronRewardsRecommended(lang:Language) return switch (lang) {
        case English: 'Patron rewards recommended';
        case Cantonese | Chinese: '建議提供支持回報';
    }

    static public function patronRewardsRecommendedDescription(lang:Language) return switch (lang) {
        case English: 'It is common for creators to prepare many patron-only rewards, which distract creators from their creative work.';
        case Cantonese: '創作人通常都會提供回報俾支持者. 一般都會需要創作人花額外時間同心機製作.';
        case Chinese: '創作人通常都會提供回報予支持者. 一般都會需要創作人花額外時間和心思製作.';
    }

    static public function kickstarterFees(lang:Language) return switch (lang) {
        case English: '5% + payment processor fees';
        case Cantonese | Chinese: '5%服務費 + 支付處理費';
    }

    static public function kickstarterFeesDescription(lang:Language) return switch (lang) {
        case English: '5% fee to the funds collected for creators, plus payment processing fees (roughly 3-5%).';
        case Cantonese: '籌得款項5%為服務費, 另加通常為3至5%嘅支付處理費.';
        case Chinese: '籌得款項5%為服務費, 另加通常為3至5%的支付處理費.';
    }

    static public function backerRewardsRecommended(lang:Language) return switch (lang) {
        case English: 'Backer rewards recommended';
        case Cantonese | Chinese: '建議提供支持回報';
    }

    static public function backerRewardsRecommendedDescription(lang:Language) return switch (lang) {
        case English: 'It is common for creators to prepare many backer rewards, which distract creators from their creative work.';
        case Cantonese: '創作人通常都會提供回報俾支持者. 一般都會需要創作人花額外時間同心機製作.';
        case Chinese: '創作人通常都會提供回報予支持者. 一般都會需要創作人花額外時間和心思製作.';
    }
}