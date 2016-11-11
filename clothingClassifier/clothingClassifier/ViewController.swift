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
    private let categoriesDictionary:[String:String] = PlistFileManager.loadPlistFile(named: "Categories")! as![String:String]
    private var currentImage:Image!
    private var showLabels = false
    private var labels:[LabelContainer] = [LabelContainer]()
    
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
        currentImage = Image(imageId: 1, imageUrl: "https://s-media-cache-ak0.pinimg.com/564x/5c/a5/28/5ca5280505933a20ba48869ca9722ad3.jpg")
        photoView.image = currentImage.getImage()
        addLabels()
        
    }
    
    @IBAction func loadLabels(sender: UIButton){
        if showLabels{
            addLabels()
        }
        else{
            for labelView in labels{
                labelView.removeFromSuperview()
            }
            labels = [LabelContainer]()
        }
        showLabels = !showLabels
    }
    
    private func addLabels(){
            do{
                let getCurrentLabels = try Labels()?.all()
                    .join(table: Categories()!, onColumn:"cat_id", andColumn:"lbl_category")
                    .whereCond(conditions: ["lbl_image_id":currentImage.getImageId()])
                getCurrentLabels?.exec(){ results in
                    for label in results{
                        let x = label["lbl_x"] as! CGFloat
                        let y = label["lbl_y"] as! CGFloat
                        let height = label["lbl_height"] as! CGFloat
                        let width = label["lbl_width"] as! CGFloat
                        let imageRect = CGRect(x: x, y: y, width: width, height: height)
                        let labelCode:String = label["cat_code"] as! String
                        let category:String = self.categoriesDictionary[labelCode]!
                        DispatchQueue.main.async {
                            let viewRect = self.photoView.convertRect(fromImage: imageRect)
                            let labelView = LabelContainer(frame: viewRect, withColor: UIColor.red, withEdgeWidth: 2, withText: category, andTextColor: UIColor.black)
                            self.labels.append(labelView)
                            self.photoView.insertSubview(labelView, at: 0)
                        }
                    }
                }
            }
            catch{
                print("ERROR LOADING LABELS")
            }
        
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
        let imageRect = photoView.getCroppedRect()
        let boundingBox = photoView.convertRect(fromView: imageRect)
        let selectedRow = categoryPicker.selectedRow(inComponent: 0)
        do{
            let categoryIdQuery = try Categories()?.get(columns: ["cat_id"])
                .whereCond(conditions: ["cat_code":categories[selectedRow].categoryCode])
            categoryIdQuery?.exec(){results in
                //There should only be one result
                guard results.count == 1 else{
                    fatalError("Invalid database result")
                }
                let catId = results[0]["cat_id"] as! Int
                let insertValues:[String:Any] = ["lbl_image_id":self.currentImage.getImageId(),
                                                 "lbl_x": boundingBox.origin.x,
                                                 "lbl_y": boundingBox.origin.y,
                                                 "lbl_height": boundingBox.size.height,
                                                 "lbl_width": boundingBox.size.width,
                                                 "lbl_category": catId]
                do{
                    let insertLabelQuery = try Labels()?.insert(values: insertValues)
                    insertLabelQuery?.execUpdate(){success in
                        if success{
                            DispatchQueue.main.async {
                                let labelView = LabelContainer(frame: imageRect,
                                                               withColor: UIColor.red,
                                                               withEdgeWidth: 2,
                                                               withText: self.categories[selectedRow].categoryDescription,
                                                               andTextColor: UIColor.black)
                                self.photoView.insertSubview(labelView, at: 0)
                                self.labels.append(labelView)
                            }
                        }
                    }
                }
                catch queryErrors.badQuery{
                    print("INVALID INSERT")
                }
                catch{
                    print("UNKNOWN ERROR")
                }
            }
        }
        catch queryErrors.badQuery{
            print("INVALID GET QUERY")
        }
        catch queryErrors.invalidCondition{
            print("INVALID WHERE CONDITION")
        }
        catch{
            print("UNKNOWN ERROR")
        }
    }
    

}

