//
//  NSPredicate+All.swift
//  Weather
//
//  Created by Eugene Kurapov on 30.07.2020.
//  Copyright © 2020 Eugene Kurapov. All rights reserved.
//

import CoreData

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}

