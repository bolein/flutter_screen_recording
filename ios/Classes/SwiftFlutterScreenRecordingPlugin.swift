import Flutter
import UIKit
import ReplayKit
import Photos

public class SwiftFlutterScreenRecordingPlugin: NSObject, FlutterPlugin {
    
    let recorder = ScreenRecordCoordinator()
    
    let screenSize = UIScreen.main.bounds
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_screen_recording", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterScreenRecordingPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        recorder.viewOverlay.stopButtonColor = UIColor.red
        
//        #if targetEnvironment(simulator)
//            result(FlutterError(code: "SIMULATOR_NOT_SUPPORTED",
//                                message: nil,
//                                details: nil))
//            return
//        #endif
        
        print(call.method)
        
        if(call.method == "getPlatformVersion"){
            result("iOS " + UIDevice.current.systemVersion)
            
        }else if(call.method == "startRecordScreen"){
            if let myArgs = call.arguments as? [String: Any],
                let fileName = myArgs["fileName"] as? String {
                recorder.startRecording(withFileName: fileName, recordingHandler: { (error) in
                    guard error == nil else {
                        result(FlutterError(code: "RECORDING_STOP_ERROR",
                                            message: error?.localizedDescription,
                                            details: nil))
                        return
                    }
                    result("success")
                    print("Recording started")
                })
            } else {
                result(FlutterError(code: "UNVALID_ARGUMENTS",
                                    message: nil,
                                    details: nil))
            }
        }else if(call.method == "stopRecordScreen"){
            recorder.stopRecording(onStopped: {(error) in
                guard error == nil else {
                    result(FlutterError(code: "RECORDING_STOP_ERROR",
                                        message: error?.localizedDescription,
                                        details: nil))
                    return
                }
                print("Recording stopped")
                result("success")
            })
        }
    }
    
}
