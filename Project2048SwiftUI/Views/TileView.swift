//
//  TileView.swift
//  Project2048SwiftUI
//
//  Created by hyperactive hi-tech ltd on 22/02/2021.
//  Copyright © 2021 JFTech. All rights reserved.
//

import SwiftUI

struct TileView: View
{
    var Settings: GameSettings
    @ObservedObject var Tile: JFTTile
    private var TileSize: Float
    
    init(Tile: JFTTile, settings: GameSettings)
    {
        self.Tile = Tile
        self.TileSize = 0.0
        self.Settings = settings
        self.TileSize = calculateTileSize()
    }
    
    var body: some View
    {
        VStack{
            Text("\(Tile.Value)")
        }
            .frame(width: CGFloat(TileSize), height: CGFloat(TileSize)).animation(.linear)
            .background(Color.init(UIColor.ColorForValue(value: Tile.Value)))
            .cornerRadius(10)
            .position(calculatePosition())
        .animation(Tile.Moved ? .linear : .none)
            .onReceive(self.Tile.$Position){_ in 
                self.position(self.calculatePosition())
        }
    }
    
    private func calculateTileSize() -> Float
    {
        let screenWidth = Float(UIScreen.main.bounds.width)
        let tileMargin = screenWidth * 0.01
        return screenWidth / Float(Settings.BoardSize) - tileMargin //Settings.BoardSize
    }
    
    private func calculatePosition() -> CGPoint
    {
        let x = TileSize * Float(Tile.Position.Column)
        let y = TileSize * Float(Tile.Position.Row)
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}

struct TileView_Previews: PreviewProvider
{
    static var previews: some View
    {
        TileView(Tile: JFTTile(position: JFTPosition(row: 0, col: 0), value: 2), settings: GameSettings())
    }
}
