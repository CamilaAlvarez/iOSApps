//
//  CenterControllerDelegate.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 05-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

protocol CenterControllerDelegate {
    func toggleBar()
    func animateLateralBar()
    func headerViewForNavigation() -> UIView?
}

extension CenterControllerDelegate {
    func headerViewForNavigation() -> UIView? {
        return nil
    }
}
