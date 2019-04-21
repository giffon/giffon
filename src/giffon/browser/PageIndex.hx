package giffon.browser;

import js.Browser.*;
import js.jquery.JQuery;
import giffon.config.*;

class PageIndex {
    static public function onReady():Void {
        (untyped new JQuery(".res-slick").slick)({
            dots: true,
            infinite: false,
            speed: 300,
            slidesToShow: 4,
            slidesToScroll: 4,
            responsive: ([
                {
                    breakpoint: 1024,
                    settings: {
                        slidesToShow: 3,
                        slidesToScroll: 3,
                        infinite: true,
                        dots: true
                    }
                },
                {
                    breakpoint: 600,
                    settings: {
                        slidesToShow: 2,
                        slidesToScroll: 2
                    }
                },
                {
                    breakpoint: 480,
                    settings: {
                        slidesToShow: 1,
                        slidesToScroll: 1
                    }
                }
            ]:Array<Dynamic>)
        });
    }
}

