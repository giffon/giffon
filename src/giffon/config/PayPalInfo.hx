package giffon.config;

import giffon.Utils.*;

class PayPalInfo {
    static public var PAYPAL_CLIENT_ID(default, never):String = env("PAYPAL_CLIENT_ID", "");
    static public var PAYPAL_CLIENT_SECRET(default, never):String = env("PAYPAL_CLIENT_SECRET", "");
}