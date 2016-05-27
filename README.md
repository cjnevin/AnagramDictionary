![](https://reposs.herokuapp.com/?path=ChrisAU/AnagramDictionary)

# AnagramDictionary
A performant anagram lookup tool, also includes a builder for reducing load time.

### Using the AnagramBuilder:
```swift
let anagramBuilder = AnagramBuilder()
words.forEach { word in
    anagramBuilder.addWord(word)
}
```

### Saving built structure:

```swift
let serialized = anagramBuilder.serialize()
serialized.writeToFile(PATH_TO_FILE, atomically: true)
```

### Loading from storage:

```swift
let anagramDictionary = AnagramDictionary.deserialize(serialized)
```

### Finding anagrams:
```swift
let anagrams = anagramDictionary["team"]
// meat, team, tame, mate
```

### Finding anagrams with some characters that are fixed:
```swift
// Second character must be an 'e'
let anagrams = anagramDictionary["team", [1: "e"]]
// meat, team
```