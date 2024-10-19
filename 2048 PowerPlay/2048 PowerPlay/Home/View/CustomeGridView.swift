//
//  CustomeGridView.swift
//  2048 PowerPlay
//
//  Created by Abhishek Suryawanshi on 16/10/24.
//

import SwiftUI

struct GameGridView: View {
    @ObservedObject var gameManager: GameManager
    
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 15
            let horizontalPadding: CGFloat = 35 
            let numRows = gameManager.grid.count
            let numCols = gameManager.grid.first?.count ?? 0

            // Calculate the total space occupied by spacings between tiles.
            let totalHorizontalSpacing = spacing * CGFloat(numCols - 1)
            let totalVerticalSpacing = spacing * CGFloat(numRows - 1)

            // Calculate the available width for the tiles after accounting for spacings and padding.
            let availableWidth = geometry.size.width - (horizontalPadding * 2) - totalHorizontalSpacing
            let availableHeight = geometry.size.height - totalVerticalSpacing

            // Determine the tile size based on the minimum available space to keep the grid square.
            let tileSize = min(availableWidth / CGFloat(numCols), availableHeight / CGFloat(numRows))

            // Create grid columns with fixed tile size and spacing.
            let columns = Array(repeating: GridItem(.fixed(tileSize), spacing: spacing), count: numCols)

            VStack {
                Text("Merge the numbers, unleash power-ups, and reach new heights!")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.brown)
                    .multilineTextAlignment(.center)
                    .padding()
                
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(0..<numRows, id: \.self) { row in
                        ForEach(0..<numCols, id: \.self) { col in
                            let tile = gameManager.grid[row][col]
                            TileView(tile: tile)
                                .frame(width: tileSize, height: tileSize)
                                .onTapGesture {
                                    if case .powerUp(_) = tile.content {
                                        gameManager.activatePowerUp(at: row, col: col)
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 15) // Ensure the grid leaves space on the left and right.
                .padding(.vertical, spacing) // Optional: Add some vertical padding.
                .background(Color(red: 0.78, green: 0.73, blue: 0.68))
                .cornerRadius(8)
            }
            
            .frame(maxWidth: geometry.size.width - (horizontalPadding * 2), maxHeight: .infinity) // Limit the width of the entire grid.
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Center the grid within the parent view.
            
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        let horizontalAmount = gesture.translation.width
                        let verticalAmount = gesture.translation.height
                        
                        if abs(horizontalAmount) > abs(verticalAmount) {
                            // Horizontal swipe
                            if horizontalAmount > 0 {
                                gameManager.swipe(direction: .right)
                            } else {
                                gameManager.swipe(direction: .left)
                            }
                        } else {
                            // Vertical swipe
                            if verticalAmount > 0 {
                                gameManager.swipe(direction: .down)
                            } else {
                                gameManager.swipe(direction: .up)
                            }
                        }
                    }
            )
            Spacer()
        }
    }
}

#Preview {
    GameGridView(gameManager: GameManager())
}
