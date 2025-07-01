//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Bin Liu on 5/24/25.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userAnswer = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var showingGameOver = false
    @State private var currentRound = 0
    private let totalRounds = 8
    
    // Track rotation for each flag
    @State private var rotationDegrees = [0.0, 0.0, 0.0]
    // Track tapped flag index
    @State private var tappedFlag: Int? = nil
    
    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ],
                center: .top,
                startRadius: 200,
                endRadius: 400
            ).ignoresSafeArea()
            
            Spacer()
            // outer main box
            VStack {
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
            
                VStack(spacing: 15) {
                    // from last step
                    VStack {
                        Text("Tap the flag of")
                            //.foregroundStyle(.white)
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            //.foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            // flag was tapped
                            flagTapped(number)
                            userAnswer = number
                            // add animation
                            withAnimation(.easeIn(duration: 1.0)) {
                                // Rotate the tapped flag
                                rotationDegrees[number] += 360
                            }
                            // Track which flag was tapped
                            tappedFlag = number
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                                // now add rotation effect
                                .rotation3DEffect(
                                    .degrees(rotationDegrees[number]),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                // add 25% opacity effect for untapped flags
                                .opacity(tappedFlag == nil || tappedFlag == number ? 1 : 0.25)
                                // add a scale effect for tapped flag to reduce 25%
                                .scaleEffect(tappedFlag == nil || tappedFlag == number ? 1 : 0.75)
                                // add an animation for opacity
                                .animation(.easeIn(duration: 0.6), value: tappedFlag)
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            //Text("Your score is \(score)")
            if scoreTitle == "Correct" {
                Text("Your score is \(score)")
            } else {
                Text("Wrong! That's the flag of \(countries[userAnswer]).")
            }
        }
        
        .alert("Game Over", isPresented: $showingGameOver) {
            Button("Restart", action: restartGame)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
            score -= 1
        }

        showingScore = true
        currentRound += 1
        
        if currentRound >= totalRounds {
            showingGameOver = true
            
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        // Reset rotation degress
        rotationDegrees = [0.0, 0.0, 0.0]
        // Reset tapped flag
        tappedFlag = nil
    }
    
    func restartGame() {
        currentRound = 0
        score = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        showingGameOver = false
        // Reset rotation degrees
        rotationDegrees = [0.0, 0.0, 0.0]
        // Reset tapped flag
        tappedFlag = nil
    }
}

#Preview {
    ContentView()
}
