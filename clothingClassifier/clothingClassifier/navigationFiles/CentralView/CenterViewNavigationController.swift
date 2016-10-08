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
    private var currentState:barState = .closed
    
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
        addShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addShadow() {
        let centerViewLayer = self.view.layer
        centerViewLayer.shadowOpacity = 0.8
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
        switch currentState {
        case .opened:
            centralDelegate?.animateLateralBar(forState: currentState, completion:{_ in
                self.centralDelegate?.toggleBar(forState: self.currentState)})
        case .closed:
            centralDelegate?.toggleBar(forState: currentState)
            centralDelegate?.animateLateralBar(forState: currentState, completion: nil)
        }
        
        changeState()
        
    }
    
    private func changeState(){
        switch currentState {
        case .opened:
            currentState = .closed
        case .closed:
            currentState = .opened
        }
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
