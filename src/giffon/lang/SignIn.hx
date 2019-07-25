package giffon.lang;

import react.*;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class SignIn {
    static public function signInUp(lang:Language) return Page.signInUp(lang);

    static public function signInWith(lang:Language, auth:giffon.db.AuthMethod) return switch (lang) {
        case English: 'Sign in with ${Settings.authMethodName(lang, auth)}';
        case Cantonese | Chinese: '用 ${Settings.authMethodName(lang, auth)} 登入';
    }
}