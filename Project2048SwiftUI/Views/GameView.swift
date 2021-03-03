//
//  GameView.swift
//  Project2048SwiftUI
//
//  Created by hyperactive hi-tech ltd on 21/02/2021.
//  Copyright © 2021 JFTech. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var GameEngine: JFTGame
    @ObservedObject var Settings = GameSettings()
    
    var body: some View
    {
        viewForState()
    }
    
    func viewForState() -> AnyView
    {
        switch GameEngine.State
        {
            case .Idle:
                return buildGameView()
            case .TurnEnd:
                return buildGameView()
            case .GameWon:
                return AnyView(EndGameView(VictoryScreen: true, BoardView: buildGameView()).environmentObject(GameEngine))
            case .GameLost:
                return AnyView(EndGameView(VictoryScreen: false, BoardView: buildGameView()).environmentObject(GameEngine))
        }
    }
    
    func buildGameView() -> AnyView
    {
        return AnyView(VStack{
          Text("2048")
            Spacer().frame(height: 75.0)
            HStack{
                Text("Score:").padding(.leading, 50.0)
                Spacer()
            }
            HStack{
                Text("\(GameEngine.Score)").padding(.leading, 50.0)
                Spacer()
                Button(action: { self.GameEngine.OnGameResetRequired() }){ Text("Reset") }
                    .padding(.trailing, 50.0)
            }
            BoardView()
            .environmentObject(GameEngine)
            .environmentObject(Settings)
        })
    }
}

struct GameView_Previews: PreviewProvider
{
    static var previews: some View
    {
        GameView().environmentObject(JFTGame())
    }
}
