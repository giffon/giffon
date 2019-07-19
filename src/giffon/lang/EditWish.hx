package giffon.lang;

import react.*;
import react.ReactComponent.ReactElement;
import react.ReactMacro.jsx;

class EditWish {
    static public function editWish(lang:Language) return switch (lang) {
        case English: "Edit wish";
        case Cantonese: "修改願望";
    }
}