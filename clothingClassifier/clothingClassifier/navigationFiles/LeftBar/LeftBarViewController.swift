//
//  LeftBarViewController.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 04-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class LeftBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var delegate: LeftBarDelegate?
    @IBOutlet var optionsTableView:UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTableView.register(UINib(nibName: "LeftBarOptionCell", bundle: nil), forCellReuseIdentifier: "OptionCell")
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "emptyCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectOption(from: tableView, atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return delegate!.numberOfOptions(forGroup: section, inView: tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        default:
            return delegate?.headerView(forOptionGroup: section, inView: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = optionsTableView.dequeueReusableCell(withIdentifier: "emptyCell")!
            if let headerView = delegate?.optionListHeaderView(){
                cell.addSubview(headerView)
            }
            return cell
        default:
            let cell = optionsTableView.dequeueReusableCell(withIdentifier: "OptionCell") as! LeftBarOptionCell
            cell.iconView.image = delegate?.getIconForOption(atIndexPath: indexPath)
            cell.optionContentView.addSubview(delegate!.getViewForOption(atIndexPath: indexPath, withParentView: cell.optionContentView))
            return cell
        }
    }
    
    /* plus 1 for the header */
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate!.numberOfOptionGroups(forView: tableView) + 1
    }

}
