//
//  Package.swift
//  ThrilJunky
//
//  Created by Brad Lietz on 17/12/16.
//  Copyright © 2016 ThrilJunky LLC. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "Tutorial",
    dependencies: [
    .Package(url: "https://github.com/OpenKitten/MongoKitten.git", majorVersion: 1, minor: 4),
    .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 0, minor: 16)
]
)
