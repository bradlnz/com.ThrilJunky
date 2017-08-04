//
//  Array.swift
//  ThrilJunky
//
//  Created by Lietz on 12/08/2016.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import UIKit

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
