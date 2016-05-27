//
//  AnagramDictionary.swift
//  AnagramDictionary
//
//  Created by Chris Nevin on 27/05/2016.
//  Copyright © 2016 CJNevin. All rights reserved.
//

import Foundation

public typealias Anagrams = [String]
public typealias Words = [String: Anagrams]

protocol AnagramHashable {
    func hashValue(word: String) -> String
}

extension AnagramHashable {
    func hashValue(word: String) -> String {
        return String(word.characters.sort())
    }
}

public struct AnagramDictionary: AnagramHashable {
    private let words: Words
    
    /// - letters: Letters to use in anagrams (including fixed letters).
    /// - returns: Anagrams for provided the letters.
    public subscript(letters: String) -> Anagrams? {
        return words[hashValue(letters)]
    }
    
    /// - letters: Letters to use in anagrams (including fixed letters).
    /// - fixedLetters: Index-Character dictionary for all spots that are currently filled.
    /// - returns: Anagrams for provided the letters where fixed letters match and remaining letters.
    public subscript(letters: String, fixedLetters: [Int: Character]) -> Anagrams? {
        var remaining: [Character] = Array(letters.characters)
        // Remove fixed letters from remaining (starting at end)
        fixedLetters.keys.sort({ $0 > $1 }).forEach { (index) in
            remaining.removeAtIndex(index)
        }
        return self[letters]?.filter({ word in
            var remainingForWord = remaining
            for (index, char) in Array(word.characters).enumerate() {
                if let fixed = fixedLetters[index] {
                    if char != fixed {
                        return false
                    }
                } else {
                    if let firstIndex = remainingForWord.indexOf(char) {
                        // Remove from pool, word still appears to be valid
                        remainingForWord.removeAtIndex(firstIndex)
                    } else {
                        // We ran out of viable letters for this word
                        return false
                    }
                }
            }
            return true
        })
    }
    
    public static func deserialize(data: NSData) -> AnagramDictionary {
        // TODO: Handle failure
        let words = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! Words
        return AnagramDictionary(words: words)
    }
}

public class AnagramBuilder: AnagramHashable {
    private var words = Words()
    
    public convenience init(words: Words) {
        self.init()
        self.words = words
    }
    
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