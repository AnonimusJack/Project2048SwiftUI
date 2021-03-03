//
//  EndGameView.swift
//  Project2048SwiftUI
//
//  Created by hyperactive hi-tech ltd on 22/02/2021.
//  Copyright © 2021 JFTech. All rights reserved.
//

import SwiftUI

struct EndGameView: View
{
    @EnvironmentObject var GameEngine: JFTGame
    @State var VictoryScreen: Bool
    let BoardView: AnyView
    private let GoldColor = UIColor.init(red: 1, green: 0.84, blue: 0, alpha: 1)
    private let CrimsonColor = UIColor.init(red: 0.6, green: 0, blue: 0, alpha: 1)
    
    var body: some View
    {
        ZStack{
            BoardView
            VStack{
                Text("You have \(VictoryScreen ? "Won" : "Lost")!")
                    .bold()
                    .foregroundColor(Color(VictoryScreen ? GoldColor : CrimsonColor))
                    .font(Font.custom("Futura", size: 48.0))
                    .shadow(color: Color(VictoryScreen ? GoldColor.DarkerColor() : CrimsonColor.DarkerColor()), radius: 2.0, x: -2, y: 2)
                Text("With \(GameEngine.Score) points!")
                    .foregroundColor(Color(VictoryScreen ? GoldColor : CrimsonColor))
                    .font(Font.custom("Futura", size: 36.0))
                    .shadow(color: Color(VictoryScreen ? GoldColor.DarkerColor() : CrimsonColor.DarkerColor()), radius: 2.0, x: -2, y: 2)
                Text("Tap to continue.")
                    .foregroundColor(Color(VictoryScreen ? GoldColor : CrimsonColor))
                    .font(Font.custom("Futura", size: 28.0))
                    .shadow(color: Color(VictoryScreen ? GoldColor.DarkerColor() : CrimsonColor.DarkerColor()), radius: 2.0, x: -2, y: 2)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.darkGray).opacity(0.55))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { self.onEndGameScreenTap() }
        }
    }
    
    func onEndGameScreenTap()
    {
        GameEngine.OnGameResetRequired()
    }
}

struct EndGameView_Previews: PreviewProvider
{
    static var previews: some View
    {
        EndGameView(VictoryScreen: true, BoardView: AnyView(ZStack{Text("")})).environmentObject(JFTGame())
    }
}
