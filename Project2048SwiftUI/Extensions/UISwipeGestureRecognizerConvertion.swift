//
//  UISwipeGestureRecognizerConvertion.swift
//  Project2048SwiftUI
//
//  Created by hyperactive hi-tech ltd on 24/02/2021.
//  Copyright © 2021 JFTech. All rights reserved.
//

import UIKit

public class Swipe: UISwipeGestureRecognizer
{
    var target: InvokeTarget
    
    init(_ direction: Direction, action: @escaping () -> ())
    {
        self.target = InvokeTarget(action: action)
        super.init(target: target, action: #selector(target.Invoke))
        self.direction = direction
    }
}

public class InvokeTarget: NSObject
{
    private var action: () -> ()
    
    init(action: @escaping () -> ())
    {
        self.action = action
        super.init()
    }
    
    @objc public func Invoke()
    {
        self.action()
    }
}
