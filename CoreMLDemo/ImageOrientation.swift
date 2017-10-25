//
//  ImageOrientation.swift
//  CoreMLDemo
//
//  Created by Markus Mühlberger on 10/25/17.
//  Copyright © 2017 Markus Mühlberger. All rights reserved.
//

import UIKit
import ImageIO

extension CGImagePropertyOrientation {
    init(_ orientation: UIImageOrientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
