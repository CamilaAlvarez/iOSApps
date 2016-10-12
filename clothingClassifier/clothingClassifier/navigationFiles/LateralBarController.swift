//
//  LateralBarController.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 03-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func getScreenSize()->CGSize{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window:UIWindow = appDelegate.window!
        return window.frame.size
    }
}

class LateralBarController: UIViewController, CenterControllerDelegate, LeftBarDelegate {
    private var centerViewNavigationController:CenterViewNavigationController
    private var centerViewController:UIViewController
    private var leftViewController:LeftBarViewController?
    private var optionList:[String : [String:String]] = PlistFileManager.loadPlistFile(named: "leftBarOptions") as! [String : [String:String]]
    private var leftBarwidth:CGFloat? = nil
    private let margin:CGFloat = 8

    
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
            viewController.view.frame.size.width = getLeftBarWidth()
            self.view.insertSubview(viewController.view, at: 0)
            self.addChildViewController(viewController)
            viewController.didMove(toParentViewController: self)
            centerViewController.view.isUserInteractionEnabled = false
        case .opened:
            leftViewController?.view.removeFromSuperview()
            leftViewController?.willMove(toParentViewController: nil)
            leftViewController?.removeFromParentViewController()
            leftViewController = nil
            centerViewController.view.isUserInteractionEnabled = true
        }
    }
    
    
    func animateLateralBar(forState currentState:barState, completion:((Bool)->Void)?){
        let centerView:UIView = centerViewNavigationController.view
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            switch currentState{
            case .closed:
                centerView.frame.origin.x += self.getLeftBarWidth()
                self.centerViewNavigationController.view.alpha = 0.6
            case .opened:
                centerView.frame.origin.x = 0
                self.centerViewNavigationController.view.alpha = 1
            }
        }, completion: completion)
    }
    
    func didSelectOption(from tableView:UITableView, atIndexPath indexPath:IndexPath){
        var nextViewController:UIViewController? = nil
        switch indexPath.row{
        case 0:
            nextViewController = CropViewController(nibName: "CropView", bundle: nil)
        case 1:
            nextViewController = LabeledImagesController(nibName: "LabeledImagesController", bundle: nil)
        case 2:
            nextViewController = SynchronizeViewController(nibName: "SynchronizeViewController", bundle: nil)
        default:
            break
        }
        
        self.centerViewController = nextViewController!
        self.centerViewNavigationController.setViewControllers([self.centerViewController], animated: false)
        self.centerViewNavigationController.finishNavigationBar()
        self.centerViewNavigationController.openLeftBar(self)
        
    }
    
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
        var labelFrame = view.bounds
        labelFrame.origin.y += margin
        labelFrame.size.height -= 2*margin
        labelFrame.size.width -= margin

        let labelView = UILabel(frame: labelFrame)
        labelView.numberOfLines = 0
        
        switch indexPath.row {
        case 0:
            labelView.text = optionList["classify"]!["label"]
        case 1:
            labelView.text = optionList["review"]!["label"]
        case 2:
            labelView.text = optionList["sync"]!["label"]
        default:
            break
        }
        
        return labelView
    }
    
    func getLeftBarWidth() -> CGFloat{
        guard let width = leftBarwidth else{
            let windowFrameSize = getScreenSize()
            leftBarwidth = 5*windowFrameSize.width/6
            return leftBarwidth!
        }
        return width
    }

}
