package giffon.browser;

import js.Browser.*;
import react.*;

class PageSettings {
    static public function onReady():Void {
        ReactDOM.render(React.createElement(SettingsForm, {
            current_settings: haxe.Json.parse(document.body.getAttribute("data-current-settings")),
        }), document.getElementById("settings-root"));
    }
}
