//
//  Categories.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 20-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import Foundation
class Categories:QuerySet{
    override var tableName: String! { return "Categories" }    
}

class ImageCategories:QuerySet{
    override var tableName: String! { return "ImageCategories" }
}

class Images:QuerySet{
    override var tableName: String! { return "Images" }
}

class Labels:QuerySet{
    override var tableName: String! { return "Labels" }
}
