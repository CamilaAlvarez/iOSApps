//
//  Image.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 04-11-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import Foundation

class Image{
    private var id:Int
    private var url:String
    private var image:UIImage! = nil
    
    init(imageId:Int, imageUrl:String) {
        id=imageId
        url=imageUrl
    }
    
    func getImageId()->Int{
        return id
    }

    func getImage()->UIImage?{
        guard image != nil else {
            do{
                let imageUrl = URL(string: url)
                let imageData = try Data(contentsOf: imageUrl!)
                let loadedImage = UIImage(data: imageData)
                return loadedImage
            }
            catch{
                return nil
            }
        }
        return image
    }
}
