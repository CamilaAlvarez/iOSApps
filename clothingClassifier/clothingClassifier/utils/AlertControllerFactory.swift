//
//  AlertControllerFactory.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 24-11-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class AlertControllerFactory {
    
    static func createStandardErrorAlert(message:String)->UIAlertController{
        let alert = UIAlertController(title: NSLocalizedString("alert_no_image_title",
                                                               comment: "alert title")
                                        , message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("alert_button",
                                                                 comment: "alert button")
                                        ,style: .default){action in}
        alert.addAction(alertAction)
        
        return alert
    }

}
