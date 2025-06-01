//
//  ContentView.swift
//  WordScramble
//
//  Created by Bin Liu on 5/31/25.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    // add a state property to track score
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }

                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }

                Section {
                    Text("Score: \(score)")
                        
                }
            }
            // put .navigationTitle here to make sure it appears before the text field
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            /*
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
            */
            .alert(errorTitle, isPresented: $showingError) {} message: {
                Text(errorMessage)
            }
            
            // add a toolbar with a button to start a new game
            .toolbar {
                Button("New Game") {
                    startGame()
                    usedWords.removeAll()
                    newWord = ""
                }
            }
        }
    }
    
    func addNewWord() {
        // lowercase and trim the word to make sure we do not add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        // exit if the remaining string is empty
        guard answer.count > 0 else { return }

        // extra validation to come
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        guard isAllowed(word: answer) else {
            wordError(title: "Word not allowed", message: "You can't use a word shorter than 3 letters or the root word itself!")
            return
        }

        // add animation effect
        withAnimation {
            usedWords.insert(answer, at: 0)
            newWord = ""
            // increase the score
            score += 1
        }
    }
    
    func startGame() {
        // find the url for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")

                // pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                // reset score
                score = 0

                // if everything works, we can exit
                return
            }
        }

        // otherwise we have a problem - trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func isAllowed(word: String) -> Bool {
        // disallow words shorter than 3 letters or the same as the root word
        if word.count < 3 || word == rootWord {
            return false
        } else {
            return true
        }
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
