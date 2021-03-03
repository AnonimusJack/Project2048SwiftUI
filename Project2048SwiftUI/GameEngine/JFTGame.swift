//
//  Game.swift
//  Project2048
//
//  Created by hyperactive hi-tech ltd on 16/08/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation
import SwiftUI

class JFTGame: ObservableObject
{
    enum MoveType
    {
        case Right
        case Left
        case Up
        case Down
    }
    
    enum GameState
    {
        case TurnEnd
        case Idle
        case GameWon
        case GameLost
    }
    
    @Published public var State: GameState = .Idle
//    public var OldPositions: Array = Array<JFTPosition>()
//    public var NewPositions: Array = Array<JFTPosition>()
    public var GameBoard: Array = Array<JFTTile>()
    public var IsGameOver: Bool = false
    public var Score: Int = 0
    
    
    
    
    func OnMoveMade(moveType: MoveType)
    {
        moveTiles(moveType: moveType)
        guard let addedTile = addRandomTile()
        else
        {
            return gameLost()
        }
        if GameBoard.count > 15
        {
            if checkIfGameLostByMovedTiles(newTile: addedTile)
            {
                return gameLost()
            }
        }
//        resetEventPositionsAfterTurnConcluded()
        SaveState()
        State = .TurnEnd
        resetTilesAfterTurnConclusion()
        State = .Idle
    }
    
    func OnGameResetRequired()
    {
        Score = 0
        IsGameOver = false
        gameInit()
    }
    
    func SaveState()
    {
        UserDefaults.standard.setValue(boardToJSON(), forKeyPath: "game_board")
        UserDefaults.standard.setValue(Score, forKeyPath: "game_score")
    }
    
    func LoadState()
    {
        if let savedState = UserDefaults.standard.value(forKey: "game_board")
        {
            boardFromJSON(json: savedState as! Array<Dictionary<String, Any>>)
            Score = UserDefaults.standard.integer(forKey: "game_score")
            State = .Idle
        }
        else
        {
            gameInit()
        }
    }
    
    private func checkIfGameLostByMovedTiles(newTile: JFTTile) -> Bool
    {
        var avaliableMoves = 0
        let newTilePosition = newTile.Position
        for tile in GameBoard
        {
            switch tile.Position {
                case JFTPosition(row: (newTilePosition.Row + 1), col: newTilePosition.Column):
                    avaliableMoves += (newTile.Value == tile.Value) ? 1 : 0
                    break
                case JFTPosition(row: (newTilePosition.Row - 1), col: newTilePosition.Column):
                    avaliableMoves += (newTile.Value == tile.Value) ? 1 : 0
                    break
                case JFTPosition(row: newTilePosition.Row, col: (newTilePosition.Column + 1)):
                    avaliableMoves += (newTile.Value == tile.Value) ? 1 : 0
                    break
                case JFTPosition(row: (newTilePosition.Row + 1), col: (newTilePosition.Column - 1)):
                    avaliableMoves += (newTile.Value == tile.Value) ? 1 : 0
                    break
                default:
                    break;
            }
        }
        return avaliableMoves == 0
    }

    private func gameWon()
    {
        IsGameOver = true
        State = .GameWon
    }
    
    private func gameLost()
    {
        IsGameOver = true
        State = .GameLost
    }
    
    private func gameInit()
    {
        GameBoard.removeAll()
        addRandomTile()
        addRandomTile()
        State = .Idle
        SaveState()
    }
    
    private func moveTiles(moveType: MoveType)
    {
        sortBoardBy(moveType: moveType)
        for tile in GameBoard
        {
            moveTile(tileToMove: tile, moveType: moveType)
        }
        removeZeroes()
    }
    
    private func moveTile(tileToMove: JFTTile, moveType: MoveType)
    {
//        let oldPosition = tileToMove.Position
        var newPosition = tileToMove.Position
        while  nextPosition(position: newPosition, moveType: moveType).InBounds()
        {
            newPosition = nextPosition(position: newPosition, moveType: moveType)
            if let tileAtPosition = GameBoard.first(where: { (tile) -> Bool in tile.Position == newPosition && tile.Value != 0})
            {
                if tileAtPosition.Value == tileToMove.Value && !tileToMove.Merged && !tileAtPosition.Merged
                {
//                    addEventPositions(oldPosition: oldPosition, newPosition: newPosition)
                    mergeTiles(a: tileToMove, b: tileAtPosition)
                    break
                }
                else
                {
                    newPosition = previousPosition(position: newPosition, moveType: moveType)
                    break
                }
            }
            if tileToMove.Value != 0
            {
                changeTilePosition(tileToUpdate: tileToMove, newPosition: newPosition)
            }
        }
        if tileToMove.Value != 0
        {
            tileToMove.Moved = true
//            addEventPositions(oldPosition: oldPosition, newPosition: newPosition)
        }
    }
    
    private func sortBoardBy(moveType: MoveType)
    {
        switch moveType
        {
            case MoveType.Right:
                GameBoard.sort { (a, b) -> Bool in a.Position.Column > b.Position.Column}
                GameBoard.sort { (a, b) -> Bool in a.Position.Row < b.Position.Row}
                break
            case MoveType.Left:
                GameBoard.sort { (a, b) -> Bool in a.Position.Column < b.Position.Column}
                GameBoard.sort { (a, b) -> Bool in a.Position.Row < b.Position.Row}
                break
            case MoveType.Up:
                GameBoard.sort { (a, b) -> Bool in a.Position.Row < b.Position.Row}
                GameBoard.sort { (a, b) -> Bool in a.Position.Column < b.Position.Column}
                break
            case MoveType.Down:
                GameBoard.sort { (a, b) -> Bool in a.Position.Row > b.Position.Row}
                GameBoard.sort { (a, b) -> Bool in a.Position.Column < b.Position.Column}
                break
        }
    }
    
    private func mergeTiles(a: JFTTile, b:JFTTile)
    {
        if a.Value == b.Value
        {
            b.Value += a.Value
            Score += b.Value
            if b.Value == 2048
            {
                gameWon()
            }
            b.Merged = true
            a.Value = 0
        }
    }
    
    private func removeZeroes()
    {
        GameBoard.removeAll { (tile) -> Bool in tile.Value == 0 }
    }
    
    private func changeTilePosition(tileToUpdate: JFTTile, newPosition: JFTPosition)
    {
        GameBoard[GameBoard.firstIndex(where: { (tile) -> Bool in tile.Position == tileToUpdate.Position})!].Position = newPosition
    }
    
    private func resetTilesAfterTurnConclusion()
    {
        for tile in GameBoard
        {
            tile.Merged = false
            tile.Moved = false
        }
    }
    
    private func nextPosition(position: JFTPosition, moveType: MoveType) -> JFTPosition
    {
        switch moveType
        {
            case MoveType.Right:
                return JFTPosition(row: position.Row, col: position.Column + 1)
            case MoveType.Left:
                return JFTPosition(row: position.Row, col: position.Column - 1)
            case MoveType.Up:
                return JFTPosition(row: position.Row - 1, col: position.Column)
            case MoveType.Down:
                return JFTPosition(row: position.Row + 1, col: position.Column)
        }
    }
    
    private func previousPosition(position: JFTPosition, moveType: MoveType) -> JFTPosition
    {
        switch moveType
        {
            case MoveType.Right:
                return JFTPosition(row: position.Row, col: position.Column - 1)
            case MoveType.Left:
                return JFTPosition(row: position.Row, col: position.Column + 1)
            case MoveType.Up:
                return JFTPosition(row: position.Row + 1, col: position.Column)
            case MoveType.Down:
                return JFTPosition(row: position.Row - 1, col: position.Column)
        }
    }
    
    @discardableResult private func addRandomTile() -> JFTTile?
    {
        let rPosition = JFTPosition.GetRandomPosition(tiles: GameBoard)
        if rPosition == nil
        {
            return nil
        }
        let rValue = (Float.random(in: 0...1) > 0.1) ? 2 : 4
        let newTile = JFTTile(position: rPosition!, value: rValue)
        GameBoard.append(newTile)
        return newTile
    }
    
//    private func resetEventPositionsAfterTurnConcluded()
//    {
//        OldPositions.removeAll()
//        NewPositions.removeAll()
//    }
    
//    private func addEventPositions(oldPosition: JFTPosition, newPosition: JFTPosition)
//    {
//        OldPositions.append(oldPosition)
//        NewPositions.append(newPosition)
//    }
    
    private func boardToJSON() -> Array<Dictionary<String, Any>>
    {
        var jsonBoard = Array<Dictionary<String, Any>>()
        for tile in GameBoard
        {
            jsonBoard.append(tile.toJSON())
        }
        return jsonBoard
    }
    
    private func boardFromJSON(json: Array<Dictionary<String, Any>>)
    {
        GameBoard.removeAll()
        for jsonTile in json
        {
            GameBoard.append(JFTTile(json: jsonTile))
        }
    }
}
