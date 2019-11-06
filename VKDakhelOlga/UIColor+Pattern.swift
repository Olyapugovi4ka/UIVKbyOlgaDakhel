//
//  UIColor+Pattern.swift
//  VKDakhelOlga
//
//  Created by Olga Melnik on 04.11.2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit

extension UIColor {
    private static var colorsCache: [String: UIColor] = [:]
    
    public static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, a: CGFloat) -> UIColor {
        let key = "\(r)_\(g)_\(b)_\(a)"
        if let cacheColor = self.colorsCache[key] {
            return cacheColor
        }
        let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
        self.colorsCache[key] = color
        return color
    }
    private static func clearColorCacheIfNeeded(){
        let maxObjectsCount = 100
        guard self.colorsCache.count >= maxObjectsCount else { return }
        colorsCache = [:]
    }
}
