//
//  LoggerTests.swift
//  LoggerTests
//
//  Created by Dharmendra Valiya on 05/13/20 on 1/24/20.
//

import XCTest
@testable import Logger

class LoggerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFilePrinter() {
        let subsystem = "com.pluralsight.test"
        let category = "UnitTest"
        let logger = Logger(subsystem: subsystem, category: category, printer: .file)
        logger.log("This is an error message", type: LogType.error)
        
        guard let filePrinter = logger.printer as? FilePrinter else {
            XCTFail("Invalid printer type")
            return
        }
        
        guard let logFileURL = filePrinter.logFileURL else {
            XCTFail("Could not retrieve log file URL")
            return
        }
        
        let log = try? String(contentsOf: logFileURL, encoding: .utf8)
        XCTAssertNotNil(log, "Could not retrieve log entry")
    }
    
    func testSharedPrinter() {
        let subsystem = "com.pluralsight.test"
        let category = "Testing"
        
        let loggerA = Logger(subsystem: subsystem, category: category, printer: .console)
        let loggerB = Logger(subsystem: subsystem, category: category, printer: .console)
        
        XCTAssert(loggerA.printer === loggerB.printer, "The printer properties should point to teh same shared resource")
    }
    
    func testSharedPrinterNegative() {
        let subsystem = "com.pluralsight.test"
        let category = "Testing"
        
        let consoleLogger = Logger(subsystem: subsystem, category: category, printer: .console)
        let fileLogger = Logger(subsystem: subsystem, category: category, printer: .file)
        
        XCTAssert(consoleLogger.printer !== fileLogger.printer, "The printer objects should be different")
    }

}
