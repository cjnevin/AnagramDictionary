//
//  AnagramDictionary.swift
//  AnagramDictionary
//
//  Created by Chris Nevin on 27/05/2016.
//  Copyright © 2016 CJNevin. All rights reserved.
//

import Foundation
import Lookup

internal func hashValue(_ word: String) -> String {
    return String(word.characters.sorted())
}

internal func hashValue(_ characters: [Character]) -> String {
    return String(characters.sorted())
}

public struct AnagramDictionary: Lookup {
    private let words: Words
    
    public subscript(letters: [Character]) -> Anagrams? {
        return words[hashValue(letters)]
    }
    
    public func lookup(_ word: String) -> Bool {
        return self[hashValue(word)]?.contains(word) ?? false
    }
    
    public static func deserialize(_ data: Data) -> AnagramDictionary? {
        guard let words = try? JSONSerialization.JSONObjectWithData(data, options: JSONSerialization.ReadingOptions.AllowFragments) as! Words else {
            return nil
        }
        return AnagramDictionary(words: words)
    }
    
    public static func load(_ path: String) -> AnagramDictionary? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        return AnagramDictionary.deserialize(data)
    }
    
    public init?(filename: String, type: String = "bin", bundle: Bundle = .main()) {
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

    public func addWord(_ word: String) {
        let hash = hashValue(word)
        var existing = words[hash] ?? []
        existing.append(word)
        words[hash] = existing
    }
    
    public func serialize() -> Data {
        return try! JSONSerialization.dataWithJSONObject(words, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
    
}
