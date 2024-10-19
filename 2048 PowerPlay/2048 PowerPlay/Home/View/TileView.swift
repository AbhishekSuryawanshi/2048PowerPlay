//
//  TileView.swift
//  2048 PowerPlay
//
//  Created by Abhishek Suryawanshi on 15/10/24.
//

import SwiftUICore


struct TileView: View {
    var tile: Tile
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(tileBackgroundColor)
                    .aspectRatio(1, contentMode: .fit) // Ensures the tile remains square.
                
                if case let .number(value) = tile.content, value > 0 {
                    // Only show the number if the value is greater than 0
                    Text("\(value)")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(textColor(for: value))
                } else if case .powerUp(let powerUp) = tile.content {
                    // If it's a power-up, display the appropriate icon
                    powerUpView(for: powerUp)
                }
            }
        }
    
    // Function to determine the text color based on the tile's value.
    private func textColor(for value: Int) -> Color {
        switch value {
        case 2, 4:
            return Color.black
        default:
            return Color.white
        }
    }
    
    private var tileBackgroundColor: Color {
        switch tile.content {
        case .number(let value):
            switch value {
            case 0:
                return .gray
            case 2:
                return Color(red: 0.93, green: 0.89, blue: 0.85)
            case 4:
                return Color(red: 0.93, green: 0.88, blue: 0.78)
            case 8:
                return Color(red: 0.95, green: 0.69, blue: 0.47)
            case 16:
                return Color(red: 0.96, green: 0.58, blue: 0.39)
            case 32:
                return Color(red: 0.96, green: 0.48, blue: 0.37)
            case 64:
                return Color(red: 0.96, green: 0.35, blue: 0.23)
            default:
                return Color(red: 0.93, green: 0.76, blue: 0.61)
            }
        case .powerUp:
            return Color.red
        }
    }
    
    @ViewBuilder
    func powerUpView(for powerUp: PowerUp) -> some View {
        switch powerUp {
        case .clearRow:
            Image(systemName: "rectangle.grid.1x2.fill")
        case .clearColumn:
            Image(systemName: "rectangle.grid.2x1.fill")
        case .doubleTile:
            Image(systemName: "plus.square.fill")
        }
    }
}
