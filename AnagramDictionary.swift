//
//  AnagramDictionary.swift
//  AnagramDictionary
//
//  Created by Chris Nevin on 27/05/2016.
//  Copyright © 2016 CJNevin. All rights reserved.
//

import Foundation
import Lookup

internal func hashValue(word: String) -> String {
    return String(word.characters.sort())
}

internal func hashValue(characters: [Character]) -> String {
    return String(characters.sort())
}

public struct AnagramDictionary: Lookup {
    private let words: Words
    
    public subscript(letters: [Character]) -> Anagrams? {
        return words[hashValue(letters)]
    }
    
    public func lookup(word: String) -> Bool {
        return self[hashValue(word)]?.contains(word) ?? false
    }
    
    public static func deserialize(data: NSData) -> AnagramDictionary? {
        guard let words = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! Words else {
            return nil
        }
        return AnagramDictionary(words: words)
    }
    
    public static func load(path: String) -> AnagramDictionary? {
        guard let data = NSData(contentsOfFile: path) else {
            return nil
        }
        return AnagramDictionary.deserialize(data)
    }
    
    public init?(filename: String, type: String = "bin", bundle: NSBundle = .mainBundle()) {
        guard let
            anagramPath = bundle.pathForResource(filename, ofType: type),
            anagramDictionary = AnagramDictionary.load(anagramPath) else {
            return nil
        }
        self = anagramDictionary
    }
    
    init(words: Words) {
        self.words = words
    }
}

public class AnagramBuilder {
    private var words = Words()

    public func addWord(word: String) {
        let hash = hashValue(word)
        var existing = words[hash] ?? []
        existing.append(word)
        words[hash] = existing
    }
    
    public func serialize() -> NSData {
        return try! NSJSONSerialization.dataWithJSONObject(words, options: NSJSONWritingOptions(rawValue: 0))
    }
    
}