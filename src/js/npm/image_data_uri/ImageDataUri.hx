package js.npm.image_data_uri;

import js.Promise;
import js.node.Buffer;

@:jsRequire("image-data-uri")
extern class ImageDataUri {
    static public function decode(dataURI:String):{
        imageType:String,
        dataBase64:String,
        dataBuffer:Buffer
    };
    static public function encode(data:Buffer, mediaType:String):String;
    static public function encodeFromURL(imageURL:String):Promise<String>;
    static public function encodeFromFile(filePath:String):Promise<String>;
    static public function outputFile(dataURI:String, filePath:String):Promise<String>;
}