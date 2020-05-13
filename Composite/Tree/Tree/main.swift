//
//  main.swift
//  Tree
//
//  Created by Dharmendra Valiya
//

import Foundation


protocol FileSystemEntry {
    var name: String { get }
    var size: Float { get }
    var level: Int { get }
}

guard let path = CommandLine.arguments.first else {
    print("Current path not found")
    exit(0)
}

let url = URL(fileURLWithPath: path, isDirectory: false)
let dirPath = url.deletingLastPathComponent().relativePath
let appLaunchFolder = Folder(name: dirPath, level: 0)
print("Working directory: [\(appLaunchFolder.name)]")

Parser.parse(folder: appLaunchFolder)
print(appLaunchFolder)
