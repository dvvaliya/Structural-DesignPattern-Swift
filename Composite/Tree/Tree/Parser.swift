//
//  Parser.swift
//  Tree
//
//  Created by Dharmendra Valiya
//

import Foundation

struct Parser {
    static func parse(folder: Folder) {
        let fm = FileManager.default

        guard let enumerator = fm.enumerator(atPath: folder.name) else {
            print("No entries found")
            return
        }
        
        var foldersByLevel = [0: folder] // initialize with 0 nesting level and the Folder received as argument
        
        while let entryName = enumerator.nextObject() as? String {
            guard let parentFolder = foldersByLevel[enumerator.level - 1] else {
                break
            }
            let size = enumerator.fileAttributes?[FileAttributeKey.size] as? Float
            let type = enumerator.fileAttributes?[FileAttributeKey.type] as? FileAttributeType

            switch type {
            case FileAttributeType.typeDirectory:
                let folder = Folder(name: entryName, level: enumerator.level)
                foldersByLevel[enumerator.level] = folder
                parentFolder.add(entry: folder)
            case FileAttributeType.typeRegular:
                let fileName = entryName.components(separatedBy: "/").last ?? entryName
                let file = File(name: fileName, level: enumerator.level, size: (size ?? 0)/1024/1024)
                parentFolder.add(entry: file)
            default: break
            }
        }
    }
}
