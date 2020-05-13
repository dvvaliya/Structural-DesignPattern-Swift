//
//  File.swift
//  Tree
//
//  Created by Dharmendra Valiya
//

import Foundation

class File: FileSystemEntry {
    private var fileName: String
    private var fileLevel: Int
    private var fileSize: Float
    
    var name: String { fileName }
    var size: Float { fileSize }
    var level: Int { fileLevel }
        
    init(name: String, level: Int, size: Float) {
        self.fileName = name
        self.fileLevel = level
        self.fileSize = size
    }
}

extension File: CustomStringConvertible {
    var description: String {
        let indent = String(repeating: "\t", count: level)
        return "\(indent)- \(name) \(String(format: "%.3f", size)) MB"
    }
}
