//
//  Reader.swift
//  Truffaut
//
//  Created by Yan Li on 4/3/17.
//  Copyright © 2017 Codezerker. All rights reserved.
//

import Foundation

public enum ShellRuntimeError: Error {
    case brokenPipe
}

class Shell: NSObject {
    
    struct Environment {
        
        static var swiftc: String {
            return UserPreference.customSwiftcPath ?? "/usr/bin/swiftc"
        }
        
        static var ruby: String {
            return UserPreference.customRubyPath ?? "/usr/local/bin/ruby"
        }
    }
    
    public static func call(command: String, arguments: [String] = [], currentDirectoryPath: String? = nil) throws -> String {
        let process = Process()
        process.launchPath = command
        process.arguments = arguments
        if let currentDirectoryPath = currentDirectoryPath {
            process.currentDirectoryPath = currentDirectoryPath
        }
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else {
            throw ShellRuntimeError.brokenPipe
        }
        
        return output
    }
}
