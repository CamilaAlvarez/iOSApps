//
//  LateralBarController.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 03-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class LateralBarController: UIViewController, CenterControllerDelegate {
    private var centerViewNavigationController:CenterViewNavigationController
    private var centerViewController:UIViewController
    private var leftViewController:LeftBarViewController?

    
    init(withInitialCenterViewController viewController:UIViewController) {
        centerViewController = viewController
        centerViewNavigationController = CenterViewNavigationController(rootViewController: viewController)
        super.init(nibName: nil, bundle: nil)
        centerViewNavigationController.centralDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        let centerController = UIViewController(coder: aDecoder)!
        centerViewController = centerController
        centerViewNavigationController = CenterViewNavigationController(rootViewController: centerController)
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* To avoid having the navigation bar cover part of the view */
        centerViewNavigationController.navigationBar.isTranslucent = false
        self.view.addSubview(centerViewNavigationController.view)
        self.addChildViewController(centerViewNavigationController)
        centerViewNavigationController.didMove(toParentViewController: self)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleBar(forState currentState:barState){
        switch currentState {
        case .closed:
            leftViewController = LeftBarViewController(nibName: "LeftBarViewController", bundle: nil)
            guard let viewController = leftViewController else{
                fatalError("Inconsistent state")
            }
            self.addChildViewController(viewController)
            viewController.didMove(toParentViewController: self)
        case .opened:
            leftViewController?.view.removeFromSuperview()
            leftViewController?.removeFromParentViewController()
            leftViewController = nil
            
        }
    }
    
    func animateLateralBar(forState currentState:barState){
        let centerView:UIView = centerViewNavigationController.view
        UIView.animate(withDuration: 0.5, animations: {
            switch currentState{
            case .closed:
                centerView.frame.origin.x += 180
            case .opened:
                centerView.frame.origin.x -= 180
            }
            
        })
    }
    

    

}
