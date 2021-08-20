//
//  Process+convenienceInit.swift
//  PlantUMLQuickLook
//
//  Created by Tachy_Pochy on 2021/08/19.
//

import Foundation

// 以下のコードは、下記サイトを参考にしました。
// 参考：https://dev.classmethod.jp/articles/simply-cli-with-swift-3/

extension Process {
    
    convenience init(cmd launchPath: String, args arguments: [String]? = []) {
        self.init()
        self.launchPath = launchPath
        self.arguments = arguments
    }
    
    static func | (lhs: Process, rhs: Process) -> Process {
        let pipe = Pipe()
        lhs.standardOutput = pipe
        rhs.standardInput = pipe
        
        lhs.launch()
        return rhs
    }
    
    func resultData() -> Data {
        let pipe = Pipe()
        standardOutput = pipe
        
        launch()
        waitUntilExit()
        
        return pipe.fileHandleForReading.readDataToEndOfFile()
    }
}
