//
//  CenterViewNavigationController.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 05-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class CenterViewNavigationController: UINavigationController {
    var centralDelegate: CenterControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        finishNavigationBar()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        finishNavigationBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        finishNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func finishNavigationBar(){
        for child in self.viewControllers{
            prepare(navigationItem: child.navigationItem)
        }
        prepareNavigationBarView()
    }
    
    private func prepareNavigationBarView(){
        if let navigationBarView = centralDelegate?.headerViewForNavigation(){
            self.navigationBar.addSubview(navigationBarView)
        }
    }
    
    private func prepare(navigationItem item:UINavigationItem){
        guard item.leftBarButtonItem == nil else {
            return
        }
        let lateralBarButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self,
                                               action: #selector(self.openLeftBar(_:)))
        item.leftBarButtonItem = lateralBarButton
        item.hidesBackButton = true
        
    }
    
    func openLeftBar(_ sender:UIBarButtonItem){
        centralDelegate?.toggleBar()
        centralDelegate?.animateLateralBar()
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
