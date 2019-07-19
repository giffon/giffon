package giffon.browser;

import react.*;
import react.ReactMacro.jsx;
import js.npm.react_clipboard_js.Clipboard;
import js.Browser.*;
import giffon.R.*;
using StringTools;
using giffon.lang.Wish;

class WishHowToHelpSection extends ReactComponent {
    var language(get, never):giffon.lang.Language;
    function get_language() return BrowserMain.instance.language;

    function new(props):Void {
        super(props);
        state = {
            copySucceed: false,
        };
    }

    function pledgeButton() {
        var bodyClasses = document.body.classList;
        var userSignedIn = bodyClasses.contains("signed-in");
        var href = if (!userSignedIn) {
            "signin?redirectTo=" + (location.pathname + "#pledge-form-root").urlEncode();
        } else {
            "#pledge-form-root";
        };
        var label = if (!userSignedIn) {
            language.pledgeNow();
        } else {
            language.pledgeBelow();
        };
        return jsx('
            <a className="btn btn-success w-100 rounded-0" href=${href}>${label}</a>
        ');
    }

    function onCopySuccess() {
        setState({copySucceed: true});
    }

    function onPathInputFocus(evt:ReactEvent) {
        var input:js.html.InputElement = cast evt.target;
        input.setSelectionRange(0, input.value.length);
    }

    override function render() {
        var bodyClasses = document.body.classList;
        var isUserWishOwner = bodyClasses.contains("user-is-wish-owner");
        
        if (isUserWishOwner)
            return null;

        var canonicalLinkEle:js.html.LinkElement = cast document.querySelector('link[rel="canonical"]');
        var canonicalPath = canonicalLinkEle.href;

        return jsx('
            <div className="bg6 p-3 px-md-5 pb-md-5 mb-md-5">
                <div className="text-center pb-3">
                    <img className="width_xs_15 mb-2" src=${R("/images/motivation.svg")}/>
                    <div className="font_xs_l font_md_xl">${language.howCanYouSupport()}</div>
                </div>

                <div className="d-md-flex">

                    <div className="p-3 p-md-4 mb-3 mb-md-0 bg_white col">
                        <div className="pb-3 font_xs_s font_md_l flex-grow-2">
                            ${language.shareTheWishWithYourFriends()}
                        </div>
                        <div className="input-group font_xs_s font_md_m">
                            <input
                                type="text"
                                defaultValue=${canonicalPath}
                                className="col p-1 form-control"
                                onFocus=${onPathInputFocus} />
                            <Clipboard
                                className="w-100 p-1"
                                data-clipboard-text=${canonicalPath}
                                button-className=${state.copySucceed ? "btn btn-outline-primary col-auto rounded-0" : "btn btn-success col-auto rounded-0"}
                                onSuccess=${onCopySuccess}
                            >
                                ${state.copySucceed ? language.copied() : language.copy()}
                            </Clipboard>
                        </div>
                    </div>
                    <div className="p-3 p-md-4 ml-md-3 bg_white col">
                        <div className="pb-3 font_xs_s font_md_l">
                            ${language.pledgeTheWishSinceEveryDollarMatters()}
                        </div>
                        ${pledgeButton()}
                    </div>
                </div>
            </div>
        ');
    }
}