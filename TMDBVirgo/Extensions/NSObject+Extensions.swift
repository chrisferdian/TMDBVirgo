//
//  NSObject+Extensions.swift
//  TMDBVirgo
//
//  Created by Indo Teknologi Utama on 18/05/22.
//

import Foundation

extension NSObject {

    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
