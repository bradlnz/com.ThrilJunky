//
//  CGFloat.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 13/06/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

public extension Float {
    mutating func roundToDecimals(_ decimals: Int = 2) -> Float {
        let multiplier = Float(10^decimals)
        return multiplier * self / multiplier
    }
}
