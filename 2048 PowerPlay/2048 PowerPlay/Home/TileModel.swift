//
//  Untitled.swift
//  2048 PowerPlay
//
//  Created by Abhishek Suryawanshi on 15/10/24.
//

enum TileContent: Equatable {
    case number(Int)
    case powerUp(PowerUp)
}

enum PowerUp : Equatable {
    case clearRow
    case clearColumn
    case doubleTile
}

enum Direction {
    case up
    case down
    case left
    case right
}

struct Tile {
    var content: TileContent
    var position: (row: Int, col: Int)
    
    mutating func doubleValue() {
        if case let .number(value) = content {
            content = .number(value * 2)
        }
    }
}

