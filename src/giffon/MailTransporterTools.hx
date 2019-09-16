package giffon;

import tink.CoreApi;
import haxe.Json;
import js.npm.nodemailer.Nodemailer;

class MailTransporterTools {
    static public function sendMailWithRetries(t:Transporter, data:MessageData, trials = 3):Promise<{}> {
        return Future.async(function(resolve) {
            t.sendMail(data, function(err, info, resp) {
                if (err != null) {
                    if (trials > 1) {
                        sendMailWithRetries(t, data, trials - 1);
                    } else {
                        resolve(Failure(err));
                    }
                } else {
                    resolve(Success({}));
                }
            });
        });
    }
}