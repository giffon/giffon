describe('front page', function() {
    it('should display Giffon', function() {
        browser.url("/");
        browser.pause(1000);
        console.log(browser.getText('h1=Giffon'));
    });
});