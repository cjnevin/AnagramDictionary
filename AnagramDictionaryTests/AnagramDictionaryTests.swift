//
//  AnagramDictionaryTests.swift
//  AnagramDictionaryTests
//
//  Created by Chris Nevin on 26/06/2016.
//  Copyright © 2016 CJNevin. All rights reserved.
//

import XCTest
@testable import AnagramDictionary
@testable import Lookup

class AnagramDictionaryTests: XCTestCase {
    
    func testBuildAndLoad() {
        let input = NSBundle(forClass: self.dynamicType).pathForResource("test", ofType: "txt")!
        let data = try! NSString(contentsOfFile: input, encoding: NSUTF8StringEncoding)
        let lines = data.componentsSeparatedByString("\n").sort()
        let anagramBuilder = AnagramBuilder()
        lines.forEach { anagramBuilder.addWord($0) }
        let output = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first! + "/output.txt"
        XCTAssert(anagramBuilder.serialize().writeToFile(output, atomically: true))
        
        // Test build worked
        let dictionary = AnagramDictionary.load(output)!
        lines.forEach { XCTAssertTrue(dictionary.lookup($0)) }
        XCTAssertEqual(dictionary["part"]!, ["part", "prat", "rapt", "tarp", "trap"])
        XCTAssertFalse(dictionary.lookup("arpt"))
        XCTAssertFalse(dictionary.lookup("fake"))
    }
    
    func testLoadFailsIfInvalidFile() {
        XCTAssertNil(AnagramDictionary.load(""))
    }
    
    func testDeserializeFails() {
        XCTAssertNil(AnagramDictionary.deserialize(NSData()))
    }
    
    func testInitSucceeds() {
        XCTAssertNotNil(AnagramDictionary(filename: "test", type: "bin", bundle: NSBundle(forClass: self.dynamicType)))
    }
    
    func testInitFailsIfInvalidBundledFile() {
        XCTAssertNil(AnagramDictionary(filename: ""))
    }
    
    func testInitFailsIfInvalidBundledFileOfType() {
        XCTAssertNil(AnagramDictionary(filename: "", type: "txt"))
    }
    
    func testInitFailsIfInvalidBundledFileOfTypeInBundle() {
        XCTAssertNil(AnagramDictionary(filename: "fake", type: "bin", bundle: NSBundle(forClass: self.dynamicType)))
    }
}
