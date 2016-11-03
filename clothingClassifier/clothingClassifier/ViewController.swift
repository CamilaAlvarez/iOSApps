//
//  ViewController.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 16-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import UIKit
import FMDB

class CropViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private struct category{
        let categoryCode:String
        let categoryDescription:String
    }
    
    @IBOutlet var photoView:AdaptableRectangle!
    @IBOutlet var categoryPicker:UIPickerView!
    private let categories:[category] = CropViewController.loadCategoriesIntoArray()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private class func loadCategoriesIntoArray()->[category]{
        var categories = [category]()
        let categoryDictionary = PlistFileManager.loadPlistFile(named: "Categories")!
        for (code, description) in categoryDictionary as! [String:String]{
            categories.append(category(categoryCode: code, categoryDescription: description))
        }
        return categories
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        let imageData = try? Data(contentsOf: URL(string: "https://s-media-cache-ak0.pinimg.com/564x/5c/a5/28/5ca5280505933a20ba48869ca9722ad3.jpg")!)
        let image = UIImage(data: imageData!)
        photoView.image = image
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].categoryDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addLabel(sender:UIButton)->Void{
        let rect = photoView.getCroppedRect()
        print("view: \(photoView.frame.size)")
        print("image: \(photoView.image?.size)")
        
        print("view point: \(rect.origin)")
        print("image point : \(photoView.convertPoint(fromView: rect.origin))")
        
        let selectedRow = categoryPicker.selectedRow(inComponent: 0)
        print("class: \(categories[selectedRow].categoryDescription)")
    }
    

}

