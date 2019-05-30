package giffon.view;

import react.*;
import react.ReactMacro.jsx;
import haxe.io.*;

class Settings extends Page {
    override function title() return "Settings - Giffon";
    override function path() return "settings";
    override function render() return super.render();

    override function requiredSignin() return true;

    override function bodyClasses() return super.bodyClasses().concat(["page-settings"]);

    override function bodyAttributes() {
        var attrs = super.bodyAttributes();
        attrs["data-current-settings"] = haxe.Json.stringify(({
            user_name: user.user_name,
            user_description: user.user_description == null ? "" : user.user_description,
        }:giffon.db.SettingsFormData.SettingsFormValues));
        return attrs;
    }

    override function bodyContent() return jsx('
        <div className="container">
            <h1>Settings</h1>
            <div id="settings-root" className="mb-5"></div>
        </div>
    ');
}