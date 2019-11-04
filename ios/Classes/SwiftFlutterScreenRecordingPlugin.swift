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
        let randomNumber = arc4random_uniform(9999);
        
        print(call.method)
        
        if(call.method == "getPlatformVersion"){
            result("iOS " + UIDevice.current.systemVersion)
            
        }else if(call.method == "startRecordScreen"){
            recorder.startRecording(withFileName: "coolScreenRecording\(randomNumber)", recordingHandler: { (error) in
                print("Recording in progress")
            }) { (error) in
                print("Recording Complete")
                debugPrint(error)
            }
        }else if(call.method == "stopRecordScreen"){
            recorder.stopRecording()
        }
    }
    
}
