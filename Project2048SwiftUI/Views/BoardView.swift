//
//  BoardView.swift
//  Project2048SwiftUI
//
//  Created by hyperactive hi-tech ltd on 22/02/2021.
//  Copyright © 2021 JFTech. All rights reserved.
//

import SwiftUI

struct BoardView: View
{
    @EnvironmentObject var GameEngine: JFTGame
    @EnvironmentObject var Settings: GameSettings
    
    var body: some View
    {
        let boardSize = CGFloat(100.0)
        return ZStack{
            ForEach(0..<self.GameEngine.GameBoard.count, id: \.self) { i in
                TileView(Tile: self.GameEngine.GameBoard[i], settings: self.Settings)
            }
        }//.frame(width: boardSize, height: boardSize)
            .aspectRatio(1.0, contentMode: .fit)
            .background(Color(UIColor.darkGray))
            .gesture(DragGesture(minimumDistance: 5.0, coordinateSpace: .local).onEnded({ offset in
                if abs(offset.translation.width) > abs(offset.translation.height)
                {
                    if offset.translation.width > 0
                    {
                        self.GameEngine.OnMoveMade(moveType: .Right)
                    }
                    else
                    {
                        self.GameEngine.OnMoveMade(moveType: .Left)
                    }
                }
                else
                {
                    if offset.translation.height > 0
                    {
                        self.GameEngine.OnMoveMade(moveType: .Down)
                    }
                    else
                    {
                        self.GameEngine.OnMoveMade(moveType: .Up)
                    }
                }
            }))
    }
}

struct BoardView_Previews: PreviewProvider
{
    static var previews: some View
    {
        BoardView()
            .environmentObject(JFTGame())
            .environmentObject(GameSettings())
    }
}
