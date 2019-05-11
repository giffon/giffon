package giffon.browser;

import react.*;
import react.ReactMacro.jsx;
import js.npm.react_clipboard_js.Clipboard;
import js.Browser.*;
import giffon.R.*;
using StringTools;

class WishHowToHelpSection extends ReactComponent {
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
            "/signin?redirectTo=" + (location.pathname + "#pledge-form-root").urlEncode();
        } else {
            "#pledge-form-root";
        };
        var label = if (!userSignedIn) {
            "Pledge Now";
        } else {
            "Pledge Below";
        };
        return jsx('
            <a className="btn btn-success w-100" href=${href}><i className="fas fa-child"></i> ${label}</a>
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
            <div className="mb-5 mt-3 p-3 p-md-5 bg6 d-md-flex align-items-sm-center">
                <div className="p-3 text-center flex-grow-1">
                    <img className="width_xs_30 mb-2" src=${R("/images/motivation.svg")}/>
                    <div className="font_xs_l font_md_xl">How can you support?</div>
                </div>
                <div className="p-3 p-md-4 mb-3 mb-md-0 bg_white">
                    <div className="pb-3 font_xs_s font_md_l flex-grow-2">
                        Share the wish with your friends.
                    </div>
                    <div className="row mx-0">
                        <input
                            type="text"
                            defaultValue=${canonicalPath}
                            className="col p-1 form-control mr-1"
                            onFocus=${onPathInputFocus} />
                        <Clipboard
                            className="w-100 p-1"
                            data-clipboard-text=${canonicalPath}
                            button-className=${state.copySucceed ? "btn btn-outline-primary col-auto" : "btn btn-success col-auto"}
                            onSuccess=${onCopySuccess}
                        >
                            ${state.copySucceed ? "copied" : "copy"}
                        </Clipboard>
                    </div>
                </div>
                <div className="p-3 p-md-4 ml-md-3 bg_white flex-grow-2">
                    <div className="pb-3 font_xs_s font_md_l">
                        Pledge the wish, since every $1 matters.
                    </div>
                    ${pledgeButton()}
                </div>
            </div>
        ');
    }
}