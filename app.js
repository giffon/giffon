const express = require("express");
const launchChrome = require('@serverless-chrome/lambda');
const Cdp = require('chrome-remote-interface');

const app = express();

async function screenshot(url, mobile = false) {
    let result;

    const [tab] = await Cdp.List();
    const client = await Cdp({ host: '127.0.0.1', target: tab });

    const {
        Network, Page, Runtime, Emulation,
    } = client;

    Network.requestWillBeSent((params) => {
        console.log('Chrome is sending request for:', params.request.url)
    });

    try {
        await Promise.all([Network.enable(), Page.enable()])

        if (mobile) {
            await Network.setUserAgentOverride({
                userAgent:
                    'Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_1 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/14A403 Safari/602.1',
            })
        }

        await Emulation.setDeviceMetricsOverride({
            mobile: !!mobile,
            deviceScaleFactor: 0,
            scale: 1, // mobile ? 2 : 1,
            width: mobile ? 375 : 1280,
            height: 0,
        })

        console.log("Page.navigate?");
        await Page.navigate({ url })

        console.log("Page.loadEventFired?");
        await Page.loadEventFired()

        console.log("height?");
        const {
            result: {
                value: { height },
            },
        } = await Runtime.evaluate({
            expression: `(
                () => ({ height: document.body.scrollHeight })
            )();
            `,
            returnByValue: true,
        });
        console.log("height: " + height);

        await Emulation.setDeviceMetricsOverride({
            mobile: !!mobile,
            deviceScaleFactor: 0,
            scale: 1, // mobile ? 2 : 1,
            width: mobile ? 375 : 1280,
            height: height,
        });
        console.log("Emulation.setDeviceMetricsOverride");

        const screenshot = await Page.captureScreenshot({ format: 'png' });
        console.log("screenshoted");

        result = screenshot.data
    } catch (error) {
        console.error(error);
    }

    await client.close();
    console.log("client.close");

    return result
}

app.get("/", function (req, res) {
    res.send("hello world");
});

app.get("/chrome/*", function (req, res) {
    async function run(chrome) {
        const url = req.params[0];
        const mobile = false;
        let data;
        try {
            data = await screenshot(url, mobile);
        } catch (error) {
            res.send(500, 'Error capturing screenshot for ' + url + " " + error);
            return;
        }
        var img = new Buffer(data, 'base64');
        res.writeHead(200, {
            'Content-Type': 'image/png',
            'Content-Length': img.length
        });
        res.end(img);
    };
    if (process.env.AWS_EXECUTION_ENV) {
        launchChrome({
            flags: ["--window-size=1280,1696", "--hide-scrollbars"]
        }).then(run);
    } else {
        run();
    }
});

module.exports.app = app;

if (require.main === module) {
    app.listen(8000, () => console.log('listening on port 8000!'));
}
