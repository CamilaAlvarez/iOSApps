//
//  LateralBarController.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 03-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class LateralBarController: UIViewController, CenterControllerDelegate, LeftBarDelegate {
    private var centerViewNavigationController:CenterViewNavigationController
    private var centerViewController:UIViewController
    private var leftViewController:LeftBarViewController?
    private var optionList:[String : String] = PlistFileManager.loadPlistFile(named: "leftBarOptions") as! [String : String]

    
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
            leftViewController?.delegate = self
            viewController.view.frame.size.height = centerViewNavigationController.view.bounds.height
            viewController.view.frame.size.width = 180
            self.view.insertSubview(viewController.view, at: 0)
            self.addChildViewController(viewController)
            viewController.didMove(toParentViewController: self)
        case .opened:
            leftViewController?.view.removeFromSuperview()
            leftViewController?.willMove(toParentViewController: nil)
            leftViewController?.removeFromParentViewController()
            leftViewController = nil
        }
    }
    
    func animateLateralBar(forState currentState:barState, completion:((Bool)->Void)?){
        let centerView:UIView = centerViewNavigationController.view
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            switch currentState{
            case .closed:
                centerView.frame.origin.x += 180
            case .opened:
                centerView.frame.origin.x = 0
            }
        }, completion: completion)
    }
    
    func didSelectOption(from tableView:UITableView, atIndexPath indexPath:IndexPath){}
    
    func numberOfOptions(forGroup groupNumber:Int, inView tableView:UITableView) -> Int{
        return optionList.count
    }
    
    func numberOfOptionGroups(forView tableView:UITableView) -> Int{
        return 1
    }
    
    func getIconForOption(atIndexPath indexPath:IndexPath) -> UIImage?{
        return nil
    }
    
    func getViewForOption(atIndexPath indexPath:IndexPath, withParentView view:UIView) -> UIView{
        var labelFrame = view.frame
        labelFrame.origin.y += 8
        labelFrame.size.height -= 16
        let labelView = UILabel(frame: labelFrame)
        
        switch indexPath.row {
        case 0:
            labelView.text = optionList["classify"]
        case 1:
            labelView.text = optionList["review"]
        case 2:
            labelView.text = optionList["sync"]
        default:
            break
        }
        
        return labelView
    }
    

}
