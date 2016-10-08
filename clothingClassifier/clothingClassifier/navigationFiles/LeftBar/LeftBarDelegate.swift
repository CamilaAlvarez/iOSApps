//
//  LeftBarDelegate.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 04-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

protocol LeftBarDelegate {
    
    func didSelectOption(from tableView:UITableView, atIndexPath indexPath:IndexPath)
    func numberOfOptions(forGroup groupNumber:Int, inView tableView:UITableView) -> Int
    func headerView(forOptionGroup groupNumber:Int, inView tableView:UITableView) -> UIView?
    func numberOfOptionGroups(forView tableView:UITableView) -> Int
    func optionListHeaderView() -> UIView?
    func getIconForOption(atIndexPath indexPath:IndexPath) -> UIImage?
    func getViewForOption(atIndexPath indexPath:IndexPath, withParentView view:UIView) -> UIView
}

//Implement default behaviour for optional methods
extension LeftBarDelegate{
    
    func headerView(forOptionGroup groupNumber:Int, inView tableView:UITableView) -> UIView?{
        return nil
    }
    
    func optionListHeaderView() -> UIView?{
        return nil
    }
}
