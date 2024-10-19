//
//  _048_PowerPlayApp.swift
//  2048 PowerPlay
//
//  Created by Abhishek Suryawanshi on 15/10/24.
//

import SwiftUI

@main
struct _048_PowerPlayApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var gameManager = GameManager()
    @State private var hasSavedGame: Bool = UserDefaults.standard.bool(forKey: "hasSavedGame")
    
    @State private var isShowingGameView = false
    @State private var startNewGame = false
    
    var body: some Scene {
        WindowGroup {
            MenuView(hasSavedGame: $hasSavedGame, gameManager: gameManager, startGame: { newGame in
                startNewGame = newGame
                if newGame {
                    gameManager.setupGame() // Start a new game
                }
                isShowingGameView = true
            })
            .fullScreenCover(isPresented: $isShowingGameView, onDismiss: {
                // Update the saved game state when GameView is dismissed
                hasSavedGame = UserDefaults.standard.bool(forKey: "hasSavedGame")
            }) {
                GameView(gameManager: gameManager, startNewGame: startNewGame, returnToMenu: {
                    gameManager.saveGameState()
                    UserDefaults.standard.set(true, forKey: "hasSavedGame") // Mark game as saved
                    isShowingGameView = false
                })
            }
            .onAppear {
                // Check if a saved game exists when the app starts
                hasSavedGame = UserDefaults.standard.bool(forKey: "hasSavedGame")
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .background || newPhase == .inactive {
                    gameManager.saveGameState() // Ensure the game state is saved
                }
            }
        }
    }
}
