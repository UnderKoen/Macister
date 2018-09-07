//
//  ColorPalette.swift
//  Macister
//
//  Created by Koen van Staveren on 26/03/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class ColorPalette: NSObject {
    static let magisterBlue: NSColor = NSColor(red: 0, green: 147 / 255, blue: 226 / 255, alpha: 1)
    static let magisterBlack: NSColor = NSColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
    static let magisterGreen: NSColor = NSColor(red: 0, green: 150 / 255, blue: 90 / 255, alpha: 1)
    static let magisterRed: NSColor = NSColor(red: 202 / 255, green: 91 / 255, blue: 91 / 255, alpha: 1)
    static let magisterYellow: NSColor = NSColor(red: 254 / 255, green: 245 / 255, blue: 202 / 255, alpha: 1)

    static let black: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let white: NSColor = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let none: NSColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0)

    static let textColor: NSColor = NSColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 0.85)
    static let whiteTextColor: NSColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0.85)

    static let textLabel: NSColor = NSColor(red: 36 / 255, green: 36 / 255, blue: 36 / 255, alpha: 1)
    static let notActiveLabel: NSColor = NSColor(red: 178 / 255, green: 178 / 255, blue: 178 / 255, alpha: 1)
}
