//
//  LateralBarController.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 03-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class LateralBarController: UIViewController {
    private var centerViewNavigationController:CenterViewNavigationController
    private var centerViewController:UIViewController
    private var leftViewController:UIViewController?

    
    init(withInitialCenterViewController viewController:UIViewController) {
        centerViewController = viewController
        centerViewNavigationController = CenterViewNavigationController(rootViewController: viewController)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let centerController = UIViewController(coder: aDecoder)!
        centerViewController = centerController
        centerViewNavigationController = CenterViewNavigationController(rootViewController: centerController)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerViewNavigationController.navigationBar.isTranslucent = false
        self.view.addSubview(centerViewNavigationController.view)
        self.addChildViewController(centerViewNavigationController)
        centerViewNavigationController.didMove(toParentViewController: self)
        /* To avoid having the navigation bar cover part of the view */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
