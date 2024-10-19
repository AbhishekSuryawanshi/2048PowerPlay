//
//  MenuView.swift
//  2048 PowerPlay
//
//  Created by Abhishek Suryawanshi on 18/10/24.
//

import SwiftUI

struct MenuView: View {
    @Binding var hasSavedGame: Bool  // Binding to the global hasSavedGame state
    @ObservedObject var gameManager: GameManager
    var startGame: (Bool) -> Void  // Callback to start the game

    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.89, blue: 0.81)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Title
                Text("Menu")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.gray)
                
                // Keep Going Button (only visible if there's a saved game)
                if hasSavedGame {
                    Button(action: {
                        startGame(false)  // Continue saved game
                    }) {
                        Text("KEEP GOING")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.75, green: 0.68, blue: 0.6))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                // New Game Button
                Button(action: {
                    startGame(true)  // Start a new game
                }) {
                    Text("NEW GAME")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.75, green: 0.68, blue: 0.6))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 40)
        }
    }
}


#Preview {
    MenuView(
        hasSavedGame: .constant(true),  // Mock saved game status
        gameManager: GameManager(),     // Mock GameManager instance
        startGame: { newGame in
            if newGame {
                print("Starting a new game")
            } else {
                print("Continuing saved game")
            }
        }
    )
}
