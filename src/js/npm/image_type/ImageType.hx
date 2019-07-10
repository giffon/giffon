package js.npm.image_type;

@:jsRequire("image-type")
extern class ImageType {
    @:selfCall
    static public function imageType(input:Dynamic):{ext:String, mime:String};
}