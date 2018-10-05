import Cdp from 'chrome-remote-interface'
import log from '../utils/log'
import sleep from '../utils/sleep'

export default async function captureScreenshotOfUrl (url, canvasSize = null, scrollTo = null, mobile = false) {
  const LOAD_TIMEOUT = process.env.PAGE_LOAD_TIMEOUT || 1000 * 60

  let result
  let loaded = false

  const loading = async (startTime = Date.now()) => {
    if (!loaded && Date.now() - startTime < LOAD_TIMEOUT) {
      await sleep(100)
      await loading(startTime)
    }
  }

  const [tab] = await Cdp.List()
  const client = await Cdp({ host: '127.0.0.1', target: tab })

  const {
    Network, Page, Runtime, Emulation,
  } = client

  Network.requestWillBeSent((params) => {
    log('Chrome is sending request for:', params.request.url)
  })

  Page.loadEventFired(() => {
    loaded = true
  })

  try {
    await Promise.all([Network.enable(), Page.enable()])

    if (mobile) {
      await Network.setUserAgentOverride({
        userAgent:
          'Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_1 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/14A403 Safari/602.1',
      })
    }

    let width = canvasSize && canvasSize[0] ? canvasSize[0] : mobile ? 375 : 1280;
    let height = canvasSize && canvasSize[1] ? canvasSize[1] : 0;

    await Emulation.setDeviceMetricsOverride({
      mobile: !!mobile,
      deviceScaleFactor: 0,
      scale: 1, // mobile ? 2 : 1,
      width,
      height
    })

    await Page.navigate({ url })
    await Page.loadEventFired()
    await loading()

    if (!height) {
      const {
        result: {
          value: { scrollHeight },
        },
      } = await Runtime.evaluate({
        expression: `(
          () => ({ height: document.body.scrollHeight })
        )();
        `,
        returnByValue: true,
      })

      height = scrollHeight;

      await Emulation.setDeviceMetricsOverride({
        mobile: !!mobile,
        deviceScaleFactor: 0,
        scale: 1, // mobile ? 2 : 1,
        width,
        height
      })
    }

    log("scrollTo: " + JSON.stringify(scrollTo));
    let clipY = scrollTo || 0;
    if (typeof clipY === "string") {
      const evalResult = await Runtime.evaluate({
        expression: `(
          () => (document.querySelector("${clipY}") || document.body).offsetTop
        )();
        `,
        returnByValue: true,
      })
      log("evalResult: " + JSON.stringify(evalResult));
      clipY = evalResult.result.value;
    }
    log("clipY: " + JSON.stringify(clipY));

    const screenshot = await Page.captureScreenshot({
      format: 'png',
      clip: {
        x: 0,
        y: clipY,
        width,
        height,
        scale: 1
      }
    })

    result = screenshot.data
  } catch (error) {
    console.error(error)
  }

  await client.close()

  return result
}
