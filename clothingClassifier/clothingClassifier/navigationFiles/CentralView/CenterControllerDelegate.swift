//
//  CenterControllerDelegate.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 05-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

enum barState{
    case opened
    case closed
    /* mutating modifica el estado interno del 
    objeto */
    mutating func toggle(){
        switch self {
        case .opened:
            self = .closed
        case .closed:
            self = .opened
        }
    }
}

protocol CenterControllerDelegate {
    func toggleBar(forState currentState:barState)
    func animateLateralBar(forState currentState:barState, completion:((Bool)->Void)?)
    func headerViewForNavigation() -> UIView?
}

extension CenterControllerDelegate {
    func headerViewForNavigation() -> UIView? {
        return nil
    }
}
