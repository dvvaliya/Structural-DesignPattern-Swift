//
//  Folder.swift
//  Tree
//
//  Created by Dharmendra Valiya
//

import Foundation

class Folder: FileSystemEntry {
    var size: Float { entries.reduce(0, { $0 + $1.size }) }
    
    private var folderName: String
    private var folderLevel: Int
    private var entries = [FileSystemEntry]()
    
    var name: String { folderName }
    var level: Int { folderLevel }
    
    init(name: String, level: Int) {
        self.folderName = name
        self.folderLevel = level
    }

    func add(entry: FileSystemEntry) {
        entries.append(entry)
    }
}

extension Folder: CustomStringConvertible {
    var description: String {
        let indent = String(repeating: "\t", count: level)
        var result = "\(indent)[\(name.uppercased())] \(String(format: "%.3f", size)) MB"

        for entry in entries {
            result += "\n\(entry)"
        }
        return result
    }
}

