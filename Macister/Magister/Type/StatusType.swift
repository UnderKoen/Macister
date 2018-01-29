//
//  StatusType.swift
//  Macister
//
//  Created by Koen van Staveren on 29/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

enum StatusType: Int {
    case NONE = 0
    case PLANNEDAUTOMATICALLY = 1
    case PLANNEDBYHAND = 2
    case MODIFIED = 3
    case CANCELEDBYHAND = 4
    case CANCELEDAUTOMATICALLY = 5
    case INUSE = 6
    case CLOSED = 7
    case USED = 8
    case MOVED = 9
    case CHANGEDANDMOVED = 10
}
