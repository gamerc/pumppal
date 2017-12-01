//
//  UINavigationController+preferencesStatusBarStyle.swift
//  EasyExercise
//
//  Created by Charlie Gamer on 11/29/17.
//  Copyright © 2017 Charlie Gamer. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
