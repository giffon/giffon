package giffon.view;

import react.*;
import react.ReactMacro.jsx;

class SignInButton extends ReactComponent {
    var logo(get, null):String;
    function get_logo() return props.logo;

    var authMethod(get, null):giffon.db.AuthMethod;
    function get_authMethod() return props.authMethod;

    var href(get, null):String;
    function get_href() return props.href;

    var label(get, null):String;
    function get_label() return props.label;

    var disabled(get, null):Bool = false;
    function get_disabled() return props.disabled;

    function linkClasses() return [
        "signInBtn", "btn", "d-flex", "align-items-center", "border-bottom", "rounded-sm", "shadow-sm", "p-2"
    ].concat(disabled ? ["disabled"] : []);

    var title(get, null):String;
    function get_title() return props.title;

    override function render() {
        return jsx('
            <div className="mb-2">
                <a className=${linkClasses().join(" ")} href=${href} title=${title}>
                    <img className="logo mx-1" src=${logo} alt=${authMethod.getName() + " logo"} />
                    <span className="flex-grow-1 text-center">${label}</span>
                </a>
            </div>
        ');
    }
}