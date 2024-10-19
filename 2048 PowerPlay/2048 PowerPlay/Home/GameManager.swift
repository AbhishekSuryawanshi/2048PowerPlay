//
//  GmaeManager.swift
//  2048 PowerPlay
//
//  Created by Abhishek Suryawanshi on 15/10/24.
//

import Foundation

class GameManager: ObservableObject {
    @Published var grid: [[Tile]] = []
    @Published var currentScore: Int = 0
    @Published var bestScore: Int = UserDefaults.standard.integer(forKey: "bestScore")
    
    
    private var gridSize = 4
    private var moves = 0
    
    init() {
        loadGameState()  // Load the game state if it exists
    }
    
    func setupGame() {
        currentScore = 0 // Reset the current score at the start of a new game
        clearSavedState() // Clear previous saved state
        initializeGrid()
        addRandomTile()
        addRandomTile()
    }
    
    private func initializeGrid() {
        grid = Array(repeating: Array(repeating: Tile(content: .number(0), position: (0, 0)), count: gridSize), count: gridSize)
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                grid[row][col].position = (row, col)
            }
        }
    }
    
    // Save the current game state to UserDefaults
    func saveGameState() {
        let gridData = grid.map { row in
            row.map { tile in
                if case let .number(value) = tile.content {
                    return ["content": value, "row": tile.position.row, "col": tile.position.col]
                }
                return ["content": -1, "row": tile.position.row, "col": tile.position.col] // Save power-ups as -1
            }
        }
        
        UserDefaults.standard.set(gridData, forKey: "gameGrid")
        UserDefaults.standard.set(currentScore, forKey: "currentScore")
        UserDefaults.standard.set(bestScore, forKey: "bestScore")
        UserDefaults.standard.set(moves, forKey: "moves")
        UserDefaults.standard.set(true, forKey: "hasSavedGame") // Set flag indicating game is saved
    }
    
    // Load the saved game state from UserDefaults
    func loadGameState() {
        if let savedGrid = UserDefaults.standard.array(forKey: "gameGrid") as? [[Dictionary<String, Int>]] {
            grid = savedGrid.map { row in
                row.map { tileData in
                    let content: TileContent
                    if tileData["content"] == -1 {
                        content = .powerUp(.clearRow) // Adjust this if you have multiple power-ups
                    } else {
                        content = .number(tileData["content"] ?? 0)
                    }
                    return Tile(content: content, position: (tileData["row"]!, tileData["col"]!))
                }
            }
        } else {
            setupGame() // Start a new game if no saved state exists
        }
        
        currentScore = UserDefaults.standard.integer(forKey: "currentScore")
        bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        moves = UserDefaults.standard.integer(forKey: "moves")
    }
    
    // Clear the saved game state when starting a new game
    func clearSavedState() {
        UserDefaults.standard.removeObject(forKey: "gameGrid")
        UserDefaults.standard.removeObject(forKey: "currentScore")
        UserDefaults.standard.removeObject(forKey: "bestScore")
        UserDefaults.standard.removeObject(forKey: "moves")
        UserDefaults.standard.set(false, forKey: "hasSavedGame") // Mark no saved game
    }
    
    // Add a new random tile (either 2 or 4) at an empty position
    func addRandomTile() {
        let emptyTiles = grid.flatMap { $0 }.filter {
            if case .number(0) = $0.content { return true }
            return false
        }
        
        if let randomTile = emptyTiles.randomElement() {
            let value = Int.random(in: 0..<10) < 9 ? 2 : 4
            grid[randomTile.position.row][randomTile.position.col].content = .number(value)
        }
    }
    
    func updateScore(by points: Int) {
        DispatchQueue.main.async {
            self.currentScore += points
            if self.currentScore > self.bestScore {
                self.bestScore = self.currentScore
                UserDefaults.standard.set(self.bestScore, forKey: "bestScore") // Save the best score persistently
            }
        }
    }
    
    // Call this method when the user swipes or performs an action
    func swipe(direction: Direction) {
        switch direction {
        case .left:
            moveLeft()
        case .right:
            moveRight()
        case .up:
            moveUp()
        case .down:
            moveDown()
        }
        
        // After every swipe, add a new random tile to the grid
        addRandomTile()
        moves += 1
        if moves % 5 == 0 {
            addRandomPowerUp()
        }
        
        // Save the game state after each move
        saveGameState()
    }
    
    // Implement moving left logic
    func moveLeft() {
        for row in 0..<gridSize {
            var newRow: [Tile] = grid[row].filter {
                if case .number(0) = $0.content { return false }
                return true
            }
            
            // Merge similar tiles
            if newRow.count > 1 {
                for i in 0..<newRow.count - 1 {
                    if case let .number(val1) = newRow[i].content,
                       case let .number(val2) = newRow[i + 1].content,
                       val1 == val2 {
                        let newValue = val1 * 2
                        newRow[i].content = .number(val1 * 2)
                        newRow[i + 1].content = .number(0)
                        updateScore(by: newValue)
                    }
                }
            }
            
            newRow = newRow.filter {
                if case .number(0) = $0.content { return false }
                return true
            }
            
            while newRow.count < gridSize {
                newRow.append(Tile(content: .number(0), position: (row, newRow.count)))
            }
            
            grid[row] = newRow
        }
    }
    
    // Implement moving right logic
    func moveRight() {
        for row in 0..<gridSize {
            var newRow: [Tile] = grid[row].filter {
                if case .number(0) = $0.content { return false }
                return true
            }
            
            // Merge similar tiles
            for i in stride(from: newRow.count - 1, through: 1, by: -1) {
                if case let .number(val1) = newRow[i].content,
                   case let .number(val2) = newRow[i - 1].content,
                   val1 == val2 {
                    let newValue = val1 * 2
                    newRow[i].content = .number(val1 * 2)
                    newRow[i - 1].content = .number(0)
                    updateScore(by: newValue) //Add points to the score when tiles merge
                }
            }
            
            // Remove zeros and re-arrange tiles to the right
            newRow = newRow.filter {
                if case .number(0) = $0.content { return false }
                return true
            }
            
            // Fill in the remaining spaces with zeros
            while newRow.count < gridSize {
                newRow.insert(Tile(content: .number(0), position: (row, gridSize - newRow.count - 1)), at: 0)
            }
            
            grid[row] = newRow
        }
    }
    
    // Implement moving up logic
    func moveUp() {
        for col in 0..<gridSize {
            var newCol: [Tile] = []
            
            // Collect non-zero tiles
            for row in 0..<gridSize {
                if case .number(0) = grid[row][col].content { continue }
                newCol.append(grid[row][col])
            }
            
            // Merge similar tiles, but only if newCol.count > 1 to avoid range errors
            if newCol.count > 1 {
                for i in 0..<newCol.count - 1 {
                    if case let .number(val1) = newCol[i].content,
                       case let .number(val2) = newCol[i + 1].content,
                       val1 == val2 {
                        let newValue = val1 * 2
                        newCol[i].content = .number(val1 * 2)
                        newCol[i + 1].content = .number(0)
                        updateScore(by: newValue) //Add points to the score when tiles merge
                    }
                }
            }
            
            // Remove zeros and re-arrange tiles upward
            newCol = newCol.filter {
                if case .number(0) = $0.content { return false }
                return true
            }
            
            // Fill in the remaining spaces with zeros
            while newCol.count < gridSize {
                newCol.append(Tile(content: .number(0), position: (newCol.count, col)))
            }
            
            // Update the grid
            for row in 0..<gridSize {
                grid[row][col] = newCol[row]
            }
        }
    }
    
    func moveDown() {
        for col in 0..<gridSize {
            var newCol: [Tile] = []
            
            // Collect non-zero tiles in reverse order
            for row in stride(from: gridSize - 1, through: 0, by: -1) {
                if case .number(0) = grid[row][col].content { continue }
                newCol.append(grid[row][col])
            }
            
            // Merge similar tiles, but only if newCol.count > 1 to avoid range errors
            if newCol.count > 1 {
                for i in 0..<newCol.count - 1 {
                    if case let .number(val1) = newCol[i].content,
                       case let .number(val2) = newCol[i + 1].content,
                       val1 == val2 {
                        let newValue = val1 * 2
                        newCol[i].content = .number(val1 * 2)
                        newCol[i + 1].content = .number(0)
                        updateScore(by: newValue) //Add points to the score when tiles merge
                    }
                }
            }
            
            // Remove zeros and re-arrange tiles downward
            newCol = newCol.filter {
                if case .number(0) = $0.content { return false }
                return true
            }
            
            // Fill in the remaining spaces with zeros
            while newCol.count < gridSize {
                newCol.insert(Tile(content: .number(0), position: (gridSize - newCol.count - 1, col)), at: 0)
            }
            
            // Update the grid
            for row in 0..<gridSize {
                grid[row][col] = newCol[row]
            }
        }
    }
    
    // Power-up related methods remain the same
    func addRandomPowerUp() {
        let powerUps: [PowerUp] = [.clearRow, .clearColumn, .doubleTile]
        
        let emptyTiles = grid.flatMap { $0 }.filter {
            if case .number(0) = $0.content { return true }
            return false
        }
        
        if let randomTile = emptyTiles.randomElement() {
            let randomPowerUp = powerUps.randomElement()!
            grid[randomTile.position.row][randomTile.position.col].content = .powerUp(randomPowerUp)
        }
    }
    
    func activatePowerUp(at row: Int, col: Int) {
        let tile = grid[row][col]
        switch tile.content {
        case .powerUp(let powerUp):
            switch powerUp {
            case .clearRow:
                clearRow(row)
            case .clearColumn:
                clearColumn(col)
            case .doubleTile:
                grid[row][col].doubleValue()
            }
            // After activating the power-up, clear the tile
            grid[row][col].content = .number(0)
        default:
            break
        }
    }
    
    private func clearRow(_ row: Int) {
        for col in 0..<gridSize {
            grid[row][col].content = .number(0)
        }
    }
    
    private func clearColumn(_ col: Int) {
        for row in 0..<gridSize {
            grid[row][col].content = .number(0)
        }
    }
}
