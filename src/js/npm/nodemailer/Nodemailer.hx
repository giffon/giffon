package js.npm.nodemailer;

import js.lib.Promise;
import haxe.extern.EitherType;

@:jsRequire("nodemailer")
extern class Nodemailer {
    static public function createTestAccount():Promise<Dynamic>;
    static public function createTransport(options:Dynamic, ?defaults:Dynamic):Transporter;
}

extern class Transporter {
    public function sendMail(data:MessageData, ?callb:(err:Dynamic, info:TransportInfo, response:String)->Void):Promise<TransportInfo>;
}

typedef TransportInfo = {
    messageId:Dynamic,
    envelope:Dynamic,
    accepted:Array<Dynamic>,
    rejected:Array<Dynamic>,
    pending:Array<Dynamic>,
}

typedef MessageData = {
    ?from:Address,
    ?to:AddressList,
    ?cc:AddressList,
    ?bcc:AddressList,
    ?subject:String,
    ?text:String,
    ?html:String,
    ?attachments:Array<Attachment>,

    ?sender:Address,
    ?replyTo:Address,
    ?inReplyTo:String,
    ?references:EitherType<String, Array<String>>,
    ?envelope:Dynamic,
    ?attachDataUrls:Dynamic,
    ?watchHtml:Dynamic,
    ?amp:Dynamic,
    ?icalEvent:Dynamic,
    ?alternatives:Dynamic,
    ?encoding:Dynamic,
    ?raw:Dynamic,
    ?textEncoding:Dynamic,
    ?priority:Dynamic,
    ?headers:Dynamic,
    ?messageId:Dynamic,
    ?date:Dynamic,
    ?list:Dynamic,
    ?disableFileAccess:Bool,
    ?disableUrlAccess:Bool,
}

typedef Address = EitherType<String, {name:String, address:String}>;
typedef AddressList = EitherType<String, Array<Address>>;

typedef Attachment = {
    ?filename:String,
    ?content:EitherType<String, EitherType<js.node.Buffer, js.node.Stream<Dynamic>>>,
    ?path:String,
    ?href:String,
    ?httpHeaders:Array<Dynamic>,
    ?contentType:String,
    ?contentDisposition:String,
    ?cid:String,
    ?encoding:String,
    ?headers:Array<Dynamic>,
    ?raw:String,
}