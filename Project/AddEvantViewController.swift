//
//  AddEvantViewController.swift
//  Project
//
//  Created by admin on 28/12/2016.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class AddEvantViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    
    @IBOutlet weak var MyImageView: UIImageView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var stTitle: UITextField!

    @IBOutlet weak var stNoats: UITextField!
    
    //clear all the field
    @IBAction func clearBtn(_ sender: UIButton) {
        stTitle.text = ""
        stNoats.text = ""
        labelDate.text = "DD/MM/Year"
        MyImageView.image = #imageLiteral(resourceName: "Photo Libary")
        
    }
    
    //image
    @IBAction func saveBtn(_ sender: UIButton) {
        var title:String?
        var noats:String?
        var time:String?
        var image:UIImage?
        
        title = stTitle.text
        noats = stNoats.text
        time = labelDate.text
        image = MyImageView.image
        
        //Image
        let ev:MyEvents = MyEvents(title!, noats!, time!,image!)
        Model.shareInstance.eventsArray.append(ev)
        //Model.shareInstance.eventsArray.
    }
    
    
    @IBAction func PhotoAction(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
            
        }
    
    
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
           MyImageView.image = image
            MyImageView.contentMode = .scaleAspectFit
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Event"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changethedate(datePicker12 : UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        labelDate.text = "\(dateFormatter.string(from: datePicker12.date))"
    }
 
    @IBAction func datePickerAction(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: datePicker.date)
        self.labelDate.text = strDate
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
