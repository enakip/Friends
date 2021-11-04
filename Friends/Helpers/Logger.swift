//
//  Logger.swift
//  
//
//  Created by Emiray Nakip on 3.08.2021.
//

import Foundation

class Logger {
    static let shared = Logger()
    
    private init(){}
    
    func debugPrint(
        _ message: Any,
        extra1: String = #file,
        extra2: String = #function,
        extra3: Int = #line,
        remoteLog: Bool = false,
        plain: Bool = false
    ) {
        if plain {
            print(message)
        }
        else {
            let filename = (extra1 as NSString).lastPathComponent
            print(message, "[\(filename) \(extra3) line]")
        }
        
        // if remoteLog is true record the log in server
        if remoteLog {
//            if let msg = message as? String {
//                logEvent(msg, event: .error, param: nil)
//            }
        }
    }
    
    /// pretty print
    func prettyPrint(_ message: Any) {
        dump(message)
    }
    
    func printDocumentsDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("Document Path: \(documentsPath)")
    }
    
    /// Track event to firebse
    func logEvent(_ name: String? = nil, event: String? = nil, param: [String: Any]? = nil) {
       
        // Analytics.logEvent(name, parameters: param)
    }
}


//               USAGE
//              Logger.shared.debugPrint("Hello World")   --> OUTPUT : Hello World [ContentView.swift 15 Line]
//              Logger.shared.debugPrint(["a", "b", "c"]) --> OUTPUT : ["a", "b", "c"] [ContentView.swift 16 Line]
//              Logger.shared.debugPrint("Log it in the server", remoteLog: true)
//              Logger.shared.prettyPrint(["a", "b", "c"])  --> OUTPUT : ▿ 3 elements
                                                                            //- "a"
                                                                            //- "b"
                                                                            //- "c"
//              Logger.shared.logEvent("ContentView", event: "First Screen")
