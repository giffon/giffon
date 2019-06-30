package giffon.view;

import react.*;
import react.ReactMacro.jsx;

class SignInButton extends ReactComponent {
    var logo(get, null):String;
    function get_logo() return props.logo;

    var networkName(get, null):String;
    function get_networkName() return props.logo;

    var href(get, null):String;
    function get_href() return props.href;

    var label(get, null):String;
    function get_label() return props.label;

    override function render() {
        return jsx('
            <div className="mb-2">
                <a className="signInBtn d-flex align-items-center border-bottom rounded-sm shadow-sm p-2" href=${href}>
                    <img className="logo mx-1" src=${logo} alt=${networkName + " logo"} />
                    <span className="flex-grow-1 text-center">${label}</span>
                </a>
            </div>
        ');
    }
}