package giffon.lang;

import react.*;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class UseCasesVideoCreators {
    static public function titleTag(lang:Language) return switch (lang) {
        case English: 'For Video Creator';
        case Cantonese: 'Giffon點樣幫到影片創作人?';
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
                    <a href="make-a-wish">Make a wish</a> in Giffon and let the community buy you a gift!
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
                    而家就喺Giffon<a href="make-a-wish">許願</a>講低你需要啲咩, 等大家夾份買俾你!
                </p>
            </Fragment>
        ');
    }

    static public function wishIdeas(lang:Language) return switch (lang) {
        case English: 'Wish ideas';
        case Cantonese: '許個咩願好?';
    }

    static public function wishIdeasIntro(lang:Language) return switch (lang) {
        case English: 'Here are some goodies that can be useful to video creators.';
        case Cantonese: '以下幾樣嘢應該會幾啱影片創作人.';
    }

    static public function studioMicrophone(lang:Language) return switch (lang) {
        case English: 'Studio Microphone';
        case Cantonese: '專業錄音室咪';
    }

    static public function studioMicrophoneDescription(lang:Language) return switch (lang) {
        case English: 'Your fans deserve hearing you in good quality.';
        case Cantonese: '等觀眾可以聽清楚你把靚聲.';
    }

    static public function actionCamera(lang:Language) return switch (lang) {
        case English: 'Action Camera';
        case Cantonese: '戶外錄影器材';
    }

    static public function actionCameraDescription(lang:Language) return switch (lang) {
        case English: 'Your outdoor action looks different with a professional action camera.';
        case Cantonese: '用專業器材拍出嚟嘅畫面就係唔一樣.';
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
}