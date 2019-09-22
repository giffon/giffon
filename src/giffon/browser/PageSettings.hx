package giffon.browser;

import haxe.Json;
import js.Browser.*;
import react.*;
import react.ReactMacro.jsx;

@:jsRequire("react-switch", "default")
extern class Switch extends ReactComponent {

}

class SocialToggleVisible extends ReactComponent {
    var authMethod(get, never):giffon.db.AuthMethod;
    function get_authMethod() return props.authMethod;

    var initialChecked(get, never):Bool;
    function get_initialChecked() return props.initialChecked;

    var disabled(get, never):Bool;
    function get_disabled() return props.disabled;

    var checked(get, set):Bool;
    function get_checked() return state.checked;
    function set_checked(v) {
        setState({
            checked: v,
        });
        return v;
    }

    function new(props) {
        super(props);
        state = {
            checked: initialChecked,
        };
    }

    function handleChange(v:Bool):Void {
        checked = v;
        trace("checked? " + v);

    }

    override function render() return jsx('
        <div className="d-flex align-items-center h-100">
            <span className="mr-1">show on profile</span>
            <Switch onChange=${handleChange} checked=${checked} disabled=${disabled} />
        </div>
    ');
}

class PageSettings {
    static public function onReady():Void {
        ReactDOM.render(React.createElement(SettingsForm, {
            current_settings: haxe.Json.parse(document.body.getAttribute("data-current-settings")),
        }), document.getElementById("settings-root"));

        for (div in document.getElementsByClassName("socialToggleVisible")){
            ReactDOM.render(React.createElement(SocialToggleVisible, {
                authMethod: giffon.db.AuthMethod.createByName(div.dataset.authmethod),
                initialChecked: Json.parse(div.dataset.checked),
                disabled: Json.parse(div.dataset.disabled),
            }), div);
        }
    }
}
