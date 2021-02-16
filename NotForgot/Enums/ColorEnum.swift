//
//  ColorEnum.swift
//  NotForgot
//
//  Created by Sergio Ramos on 30/10/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import Foundation

enum Colors : UInt32 {
    case yellow
    case blue
    case red
    case green
    
    private static let countColors: Colors.RawValue = {
        var maxValue: UInt32 = 0
        while let _ = Colors(rawValue: maxValue) {
            maxValue += 1
        }
        return maxValue
    }()

    static func randomColor() -> Colors {
        let rand = arc4random_uniform(countColors)
        return Colors(rawValue: rand)!
    }
}
