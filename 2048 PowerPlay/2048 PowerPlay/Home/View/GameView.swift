//
//  ContentView.swift
//  2048 PowerPlay
//
//  Created by Abhishek Suryawanshi on 15/10/24.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameManager: GameManager
    var startNewGame: Bool
    var returnToMenu: () -> Void  // Closure to return to MenuView
    
    var body: some View {
        ZStack {
            Color(red: 0.94, green: 0.89, blue: 0.81)
                .edgesIgnoringSafeArea(.all)
            
            VStack() {
                
                GeometryReader { geometry in
                    VStack() {
                        HeaderView(currentScore: $gameManager.currentScore,
                                   bestScore: $gameManager.bestScore)
                        
                        //Centered Game grid view
                        GameGridView(gameManager: gameManager)
                        
                        //HStackButtonView just below the GameGridView
                        HStackButtonView(
                            titles: ["MENU", "LEADERBOARD"],
                            actions: [
                                { print("Menu clicked")
                                    gameManager.saveGameState() // Save the game state
                                    UserDefaults.standard.set(true, forKey: "hasSavedGame") // Mark game as saved
                                    returnToMenu() // Dismiss GameView and return to MenuView
                                },
                                { print("Leaderboard clicked") }
                            ]
                        )
                        
                        .padding(.top, 20) // Adjust this value for space between the grid and buttons.
                    }
                    .frame(maxWidth: .infinity) // Center horizontally
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center vertically
                    
                    .onAppear {
                        if startNewGame {
                            gameManager.setupGame() // Start a new game
                        } else {
                            gameManager.loadGameState() // Load from saved state
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GameView(
        gameManager: GameManager(), // Initialize a new GameManager
        startNewGame: true, // Indicate whether this is a new game
        returnToMenu: { print("Return to menu") } // Mock function for the return to menu action
    )
}


