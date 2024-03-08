//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by enesozmus on 3.03.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var _countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var _correctAnswer = Int.random(in: 0...2)
    
    @State private var _isShowingScore = false
    @State private var _scoreTitle = ""
    
    // ✅ challange (project 3)
    @State private var _score = 0
    let _questionAmount = 8
    
    @State private var _currentQuestion = 1
    @State private var _selectedAnswer = 0
    
    @State private var _isShowingGameOver = false
    
    // ✅ challange (project 6)
    @State private var _isAnimatingOpacity = false
    @State private var _rotationAmount = 0.0
    @State private var _scaleAmount: CGFloat = 1.0
    
    
    var body: some View {
        
        
        ZStack{
            // LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
            // RadialGradient(stops: [
            //      .init(color: .blue, location: 0.3),
            //      .init(color: .red, location: 0.3),
            // ], center: .top, startRadius: 200, endRadius: 700)
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            
            VStack{
                Spacer()
                
                Text("Guess the Flag")
                    //.font(.largeTitle.weight(.bold))
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                
                Text("Current question: \(_currentQuestion)/\(_questionAmount)")
                    .font(.title2)
                    .foregroundColor(.white)
                
                
                // Flags and texts
                VStack(spacing: 15) {
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(_countries[_correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){number in
                        Button {
                            flagTapped(number)
                        } label: {
                            //Image(_countries[number])
                            //  .clipShape(.capsule)
                            //  .shadow(radius: 5)
                            // ✅ challange (project 3)
                            FlagImage(of: _countries[number])
                            // ✅ challange (project 6)
                                .opacity(
                                    _isAnimatingOpacity ? (number == _correctAnswer ? 1 : 0.25) : 1
                                )
                                .rotation3DEffect(
                                    .degrees(number == _selectedAnswer ? _rotationAmount : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .scaleEffect(
                                    number == _correctAnswer ? 1 : _scaleAmount,
                                    anchor: .center
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                .alert(_scoreTitle, isPresented: $_isShowingScore) {
                    Button("Continue", action: askQuestion)
                } message: {
                    _scoreTitle == "Correct!" ? (
                        Text("Your score is now \(_score)/\(_questionAmount).")
                    ) : (
                        Text("Sorry, that's the flag of \(_countries[_selectedAnswer])!")
                    )
                }
                
                Spacer()
                Spacer()
                
                //                Text("Score: ???")
                //                    .foregroundStyle(.white)
                //                    .font(.title.bold())
                
                Text("Score: \(_score)/\(_questionAmount)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                    .alert("Game over!", isPresented: $_isShowingGameOver) {
                        Button("Play again", action: resetGame)
                    } message: {
                        Text("Your final score is \(_score)/\(_questionAmount).")
                    }
                
                Spacer()
            }
            .padding()
        }
        //        .alert(_scoreTitle, isPresented: $_isShowingScore) {
        //            Button("Continue", action: askQuestion)
        //        } message: {
        //            Text("Your score is ???")
        //        }
    }
    
    // Functions
    func flagTapped(_ number: Int) {
        if number == _correctAnswer {
            _scoreTitle = "Correct!"
        } else {
            _scoreTitle = "Wrong"
        }
        
        _score = number == _correctAnswer ? _score + 1 : _score
        _selectedAnswer = number
        
        // ✅ challange (project 6)
        withAnimation(.easeInOut){
            _isAnimatingOpacity = true
        }
        withAnimation {
            _rotationAmount = 360
            _scaleAmount = 0.5
        }
        
        _isShowingScore = true
    }
    
    func askQuestion() {
        if _currentQuestion == _questionAmount {
            _isShowingGameOver = true
        } else {
            _currentQuestion += 1
            _countries.shuffle()
            _correctAnswer = Int.random(in: 0...2)
        }
        
        // ✅ challange (project 6)
        _isAnimatingOpacity = false
        _rotationAmount = 0.0
        _scaleAmount = 1.0
    }
    
    func resetGame() {
        _currentQuestion = 1
        _score = 0
        
        _countries.shuffle()
        _correctAnswer = Int.random(in: 0...2)
    }
}

// ✅ challange (project 3) →→ FlagImage() View
struct FlagImage: View {
    let country: String
    
    init(of country: String) {
        self.country = country
    }
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

// Preview
#Preview {
    ContentView()
}
