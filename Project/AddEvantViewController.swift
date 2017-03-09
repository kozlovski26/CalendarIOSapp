//
//  AddEvantViewController.swift
//  Project
//
//  Created by admin on 28/12/2016.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Firebase

class AddEvantViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imageUrl: String?
    @IBOutlet weak var userAvater: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet weak var stTitle: UITextField!

    @IBOutlet weak var stNotes: UITextField!
    @IBOutlet weak var stLocation: UITextField!
    
    var selectedImage:UIImage?
    
    //clear all the field
    @IBAction func clearBtn(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
        
    }
    
    //image
    @IBAction func saveBtn(_ sender: UIButton) {
        
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        if let image = self.selectedImage{
            Model.instance.saveImage(image: image, name: self.stTitle!.text!){(url) in
                self.imageUrl = url
                let ev = MyEvents(self.stTitle!.text!, self.stNotes!.text!, self.stLocation!.text!, self.labelDate!.text!, self.imageUrl)
                   Model.instance.addEvents(ev: ev)
                print (self.stTitle)
                self.spinner.stopAnimating()
               // self.navigationController!.popViewController(animated: true)
            }
        }
        else{
            let ev = MyEvents(self.stTitle!.text!, self.stNotes!.text!, self.stLocation!.text!,self.labelDate!.text!)
            Model.instance.addEvents(ev: ev)
            self.spinner.stopAnimating()
           // self.navigationController!.popViewController(animated: true)
        }
    }

   

    @IBAction func PhotoAction(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        self.userAvater.image = selectedImage
        
        self.dismiss(animated: true, completion: nil);
            
        }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = true
        self.navigationItem.title = "Add Event"
    }

    @objc func MyEventsListDidUpdate(notification:NSNotification){
        let events = notification.userInfo?["events"] as! [MyEvents]
        for ev in events {
            print("title: \(ev.title) \(ev.lastUpdate!)")
        }
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
    

}
