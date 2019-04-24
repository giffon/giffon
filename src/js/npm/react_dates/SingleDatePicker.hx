package js.npm.react_dates;

@:jsRequire("react-dates", "SingleDatePicker")
extern class SingleDatePicker extends react.ReactComponent {
    static function __init__():Void {
        untyped __js__("import 'react-dates/initialize'");
    }
}