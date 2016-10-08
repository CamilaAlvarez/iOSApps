//
//  LeftBarOptionCell.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 04-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit

class LeftBarOptionCell: UITableViewCell {
    @IBOutlet var iconView:UIImageView!
    @IBOutlet var optionContentView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
