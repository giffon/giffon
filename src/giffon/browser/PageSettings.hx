package giffon.browser;

import haxe.Timer;
import js.html.DivElement;
import haxe.io.*;
import haxe.Json;
import js.jquery.*;
import js.Browser.*;
import react.*;
import react.ReactMacro.jsx;
import giffon.db.SettingsFormData;

@:jsRequire("react-switch", "default")
extern class Switch extends ReactComponent {

}

class SocialToggleVisible extends ReactComponent {
    var authMethod(get, never):giffon.db.AuthMethod;
    function get_authMethod() return props.authMethod;

    var initialChecked(get, never):Bool;
    function get_initialChecked() return props.initialChecked;

    var initialDisabled(get, never):Bool;
    function get_initialDisabled() return props.initialDisabled;

    var disabled(get, set):Bool;
    function get_disabled() return state.disabled;
    function set_disabled(v) {
        setState({
            disabled: v,
        });
        return v;
    }

    var checked(get, set):Bool;
    function get_checked() return state.checked;
    function set_checked(v) {
        setState({
            checked: v,
        });
        return v;
    }

    final switchContainerRef:ReactRef<DivElement> = React.createRef();

    function new(props) {
        super(props);
        state = {
            checked: initialChecked,
            disabled: initialDisabled,
        };
    }

    function handleChange(v:Bool):Void {
        var previousValue = checked;
        disabled = true;
        checked = v;
        var data:SocialSetVisibleValue = {
            social: authMethod.getName(),
            visible: v,
        };
        JQuery.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: Path.join([BrowserMain.instance.base, "settings", "socialSetVisible"]),
            data: haxe.Json.stringify(data),
        })
            .done(function(data:String, textStatus:String, jqXHR){
                disabled = false;

                var j:Dynamic = new JQuery(switchContainerRef.current);
                j
                    .tooltip({
                        trigger: "manual",
                        title: "saved",
                        placement: "right",
                        offset: "0,5",
                    })
                    .tooltip("show");

                Timer.delay(function() {
                    j.tooltip("hide");
                }, 1500);
            })
            .fail(function(err){
                alert(err);
                checked = previousValue;
                disabled = false;
            });
    }

    override function render() return jsx('
        <div className="d-flex align-items-center h-100" ref=${switchContainerRef}>
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
                initialChecked: Json.parse(div.dataset.checked) == true,
                initialDisabled: Json.parse(div.dataset.disabled) == true,
            }), div);
        }
    }
}
