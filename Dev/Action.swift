 //
//  Action.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 7/5/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

import Foundation


class Action {
    var Image = UIImage()
    var Url: String
    var Title: String

    init (Url: String, Title: String, Image: UIImage) {
        self.Url = Url
        self.Title = Title
        self.Image = Image
    }
}
