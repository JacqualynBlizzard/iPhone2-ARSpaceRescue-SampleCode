//
//  Anchor.swift
//  Space Rescue
//
//  Created by Jacqualyn Blizzard-Caron on 3/21/19.
//  Copyright © 2019 Jacqualyn Blizzard-Caron. All rights reserved.
//

import ARKit

enum NodeType: String {
    case trappedDog = "trappedDog"
    case fuel = "fuel"
}

class Anchor: ARAnchor {
    var type: NodeType?
}
