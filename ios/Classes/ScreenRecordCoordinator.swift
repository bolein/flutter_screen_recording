//
//  ScreenRecordCoordinator.swift
//  BugReporterTest
//
//  Created by Giridhar on 21/06/17.
//  Copyright © 2017 Giridhar. All rights reserved.
//

import Foundation

struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
class ScreenRecordCoordinator: NSObject
{
    let viewOverlay = WindowUtil()
    let screenRecorder = ScreenRecorder()
    
    override init()
    {
        super.init()
        
        viewOverlay.onStopClick = {
            
        }
        
        
    }
    
    func startRecording(withFileName fileName: String, recordingHandler: @escaping (Error?) -> Void)
    {
        #if targetEnvironment(simulator)
            recordingHandler(RuntimeError("Simulator not supported"))
            return
        #endif
        self.viewOverlay.show()
        screenRecorder.startRecording(withFileName: fileName) { (error) in
            recordingHandler(error)
        }
    }
    
    func stopRecording(onStopped: @escaping (Error?)->Void)
    {
        #if targetEnvironment(simulator)
            self.viewOverlay.hide()
            onStopped(RuntimeError("Simulator not supported"))
            return
        #endif
        screenRecorder.stopRecording { (error) in
            self.viewOverlay.hide()
            onStopped(error)
        }
    }
    
    class func listAllReplays() -> Array<URL>
    {
        return ReplayFileUtil.fetchAllReplays()
    }
    
    
}
