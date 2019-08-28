package test;

import giffon.lang.*;
import giffon.lang.Language;
import js.npm.spellchecker.SpellChecker;
using Lambda;
using Reflect;

class Spellcheck {
    static var words = [
        "giffon",
        "Bibbidi",
        "Bobbidi",
        "cancelled",
        "permalink",
        "IDE",
        "JetBrains",
        "favourite",
        "url",
        "Bio",
        "GitLab",
        "online",
        "Facebook",
    ];
    static function main():Void {
        for (w in words) {
            SpellChecker.add(w);
        }

        var langClasses = CompileTime.getAllClasses("giffon.lang");
        for (cls in langClasses) {
            if (([Language, LanguageTools]:Array<Dynamic>).has(cls)) {
                continue;
            }
            var clsName = Type.getClassName(cls);
            var rtti = haxe.rtti.Rtti.getRtti(cls);
            for (staticField in rtti.statics) {
                if (staticField.isPublic) switch (staticField.type) {
                    case CFunction([{ t: CEnum("giffon.lang.Language", []) }], CClass("String", [])):
                        var engStr = cls.callMethod(cls.field(staticField.name), [English]);
                        var misspellPositions = SpellChecker.checkSpelling(engStr);
                        var misspellWords = [
                            for (pos in misspellPositions)
                            engStr.substring(pos.start, pos.end)
                        ];
                        if (misspellWords.length > 0) {
                            throw '${clsName}.${staticField.name} has ${misspellWords.length} misspelled words: ${misspellWords.join(", ")}';
                        }
                    case _: //pass
                }
            }
        }
    }
}