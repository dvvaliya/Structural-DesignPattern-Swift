//
//  Logger.swift
//  Logger
//
//  Created by Dharmendra Valiya on 05/13/20
//

import Foundation

public protocol Logging {
    var subsystem: String {get}
    var category: String {get}
    
    init(subsystem: String, category: String, printer: PrinterType)
    
    func log(_ message: String,
             type: LogType,
             file: String,
             function: String,
             line: Int)
}

public enum LogType {
    case info
    case warning
    case error
}

extension LogType: CustomStringConvertible {
    public var description: String {
        switch(self) {
        case .info:
            return "INFO"
        case .warning:
            return "WARNING"
        case .error:
            return "ERROR"
        }
    }
}

public class Logger: Logging {
    public let subsystem: String
    public let category: String
    
    let printer: Printer
    
    required public init(subsystem: String, category: String, printer: PrinterType) {
        self.printer = PrinterFactory.printer(for: subsystem, category: category, type: printer)
        
        self.subsystem = subsystem
        self.category = category
    }
    
    public func log(_ message: String,
                    type: LogType,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        printer.output(message, type: type, file: file, function: function, line: line)
    }
}

public enum PrinterType: String {
    case console
    case file
}

protocol Printer: AnyObject {
    func output(_ message: String,
                type: LogType,
                file: String,
                function: String,
                line: Int)
}

class ConsolePrinter: Printer {
    private let syncQueue = DispatchQueue(label: "consolePrinterSyncQueue")
    
    func output(_ message: String,
                type: LogType,
                file: String,
                function: String,
                line: Int) {
        syncQueue.sync {
            let message = "\(type) [\(file) \(function) line#\(line)] \(message)"
            print(message)
        }
    }
}

class FilePrinter: Printer {
    let logFileURL: URL?
    private let syncQueue = DispatchQueue(label: "filePrinterSyncQueue")
    
    init() {
        guard let documentsURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            logFileURL = nil
            return
        }
        
        // create the file URL
        let logFile = "logs.txt"
        logFileURL = documentsURL.appendingPathComponent(logFile)
    }
    
    func output(_ message: String,
                type: LogType,
                file: String,
                function: String,
                line: Int) {
        guard let fileURL = logFileURL else {
            return
        }
        syncQueue.sync {
            let message = "\(type) [\(file) \(function) line#\(line)] \(message)"
            try? message.write(to: fileURL, atomically: false, encoding: .utf8)
        }
    }
}


struct PrinterFactory {
    private static var printersByID = Dictionary<String, Printer>()
    
    static func printer(for subsystem: String, category: String, type: PrinterType) -> Printer {
        let result: Printer
        let key = subsystem+category+type.rawValue
        
        if let printer = printersByID[key] {
            result = printer
        } else {
            switch type {
            case .console:
                result = ConsolePrinter()
            case .file:
                result = FilePrinter()
            }
            
            printersByID[key] = result
        }
        return result
    }
}
