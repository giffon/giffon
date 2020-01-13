package test;

import react.ReactComponent.ReactElement;
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
        "GitHub",
        "devs",
        "HKD",
        "USD",
        "PayPal",
        "Instagram",
        "Kickstarter"
    ];

    static function main():Void {
        for (w in words) {
            SpellChecker.add(w);
        }

        var langClasses = CompileTime.getAllClasses("giffon.lang");
        var misspells = [];
        for (cls in langClasses) {
            if (([Language, LanguageTools]:Array<Dynamic>).has(cls)) {
                continue;
            }
            var clsName = Type.getClassName(cls);
            var rtti = haxe.rtti.Rtti.getRtti(cls);
            for (staticField in rtti.statics) {
                var misspellWords = if (!staticField.isPublic) [] else switch (staticField.type) {
                    case CFunction([{ t: CEnum("giffon.lang.Language", []) }], CClass("String", [])):
                        var engStr = cls.callMethod(cls.field(staticField.name), [English]);
                        var misspellPositions = SpellChecker.checkSpelling(engStr);
                        [
                            for (pos in misspellPositions)
                            engStr.substring(pos.start, pos.end)
                        ];
                    case CFunction([{ t: CEnum("giffon.lang.Language", []) }], CTypedef("react.ReactElement", [])):
                        var ele = cls.callMethod(cls.field(staticField.name), [English]);
                        var misspellWords = [];
                        iterateReactElementString(ele, function(s) {
                            for (pos in SpellChecker.checkSpelling(s)) {
                                misspellWords.push(s.substring(pos.start, pos.end));
                            }
                        });
                        misspellWords;
                    case _:
                        Sys.println('Not checking ${clsName}.${staticField.name}');
                        [];
                };
                
                if (misspellWords.length > 0) {
                    misspells.push({
                        source: '${clsName}.${staticField.name}',
                        words: misspellWords,
                    });
                }
            }
        }
        if (misspells.length > 0) {
            for (m in misspells) {
                Sys.println('${m.source} has ${m.words.length} misspelled words: ${m.words.join(", ")}');
            }
            Sys.exit(1);
        }
    }

    static function iterateReactElementString(ele:ReactElement, f:(s:String)->Void) {
        var children:Array<Dynamic> = Std.downcast(ele.props.children, Array);
        if (children != null) {
            for (child in children) {
                if (Std.is(child, String)) {
                    f(child);
                } else if (child.props != null) {
                    iterateReactElementString(child, f);
                }
            }
        }
    }
}