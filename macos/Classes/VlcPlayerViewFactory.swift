import Foundation
import FlutterMacOS

public class VlcPlayerViewFactory: NSObject, FlutterPlatformViewFactory {
    
    private let vlcApi: VlcPlayerApi

    init(vlcApi: VlcPlayerApi) {
        self.vlcApi = vlcApi
        super.init()
    }
    
    public func create(withViewIdentifier viewId: Int64, arguments args: Any?) -> NSView {
        let arguments = args as? NSDictionary ?? [:]
        let rViewId = (arguments["videoViewId"] as? NSNumber)?.int64Value ?? -1;
        return vlcApi.getVideoViewDiplayView(videoViewId: rViewId)
    }
    
    public func createArgsCodec() -> (any FlutterMessageCodec & NSObjectProtocol)? {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
