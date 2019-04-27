package giffon.browser;

import js.Browser.*;
import js.jquery.JQuery;
import giffon.config.*;

class PageIndex {
    static public function onReady():Void {
        (untyped new JQuery(".res-slick").slick)({
            arrows: false,
            infinite: false,
            speed: 300,
            slidesToShow: 4,
            slidesToScroll: 4,
            responsive: ([
                {
                    breakpoint: 992,
                    settings: {
                        slidesToShow: 3,
                        slidesToScroll: 3,
                    }
                },
                {
                    breakpoint: 768,
                    settings: {
                        slidesToShow: 2,
                        slidesToScroll: 2,
                    }
                },
                {
                    breakpoint: 576,
                    settings: {
                        slidesToShow: 1,
                        slidesToScroll: 1,
                    }
                }
            ]:Array<Dynamic>)
        });
    }
}

