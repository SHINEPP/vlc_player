import Cocoa
import FlutterMacOS

public class VlcPlayerPlugin: NSObject, FlutterPlugin {
    private static var vlcApi: VlcPlayerApi? = nil;

    public static func register(with registrar: FlutterPluginRegistrar) {
        vlcApi = VlcPlayerApi(messenger: registrar.messenger)
    }
}
