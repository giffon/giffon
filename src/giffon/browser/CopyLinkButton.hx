package giffon.browser;

import react.*;
import react.ReactMacro.jsx;
import js.npm.react_clipboard_js.Clipboard;
import js.Browser.*;
import giffon.R.*;
using StringTools;
using giffon.lang.Wish;

class CopyLinkButton extends ReactComponent {
    var clipboardText(get, never):String;
    function get_clipboardText() return props.clipboardText;

    var language(get, never):giffon.lang.Language;
    function get_language() return BrowserMain.instance.language;

    function new(props):Void {
        super(props);
        state = {
            copySucceeded: false,
        };
    }

    function onCopySuccess() {
        setState({copySucceed: true});
    }

    override function render() {
        return jsx('
            <Clipboard
                data-clipboard-text=${clipboardText}
                button-className="btn btn-link"
                onSuccess=${onCopySuccess}
            >
                <i className="far fa-copy"></i> ${state.copySucceed ? language.copiedPermalink() : language.copyPermalink()}
            </Clipboard>
        ');
    }
}