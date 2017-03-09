//
//  EvantDetailsViewController.swift
//  Project
//
//  Created by admin on 28/12/2016.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import MapKit

class EvantDetailsViewController: UIViewController {

    var nameToDisplay : Int?
    
    
    @IBOutlet weak var stTitle: UILabel!
    @IBOutlet weak var stNoats: UILabel!
    @IBOutlet weak var stTimeAndDate: UILabel!
    @IBOutlet weak var stLocation: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    //image
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Event Details"
      
        NotificationCenter.default.addObserver(self, selector:
            #selector(MyEventsTableViewController.MyEventsListDidUpdate),
                                               name: NSNotification.Name(rawValue: notifyMyEventsListUpdate),object: nil)
        Model.instance.getAllMyEventsAndObserve()

        var image :UIImage
        image = #imageLiteral(resourceName: "Photo Libary")
        var ev:MyEvents = MyEvents("","","","","")
     
        
        self.stTitle.text = ev.title
        self.stNoats.text = ev.notes
        self.stLocation.text = ev.location
        self.stTimeAndDate.text = ev.time
 
        // Do any additional setup after loading the view.
    }
    
    @objc func MyEventsListDidUpdate(notification:NSNotification){
        let myEventsList = notification.userInfo?["events"] as! [MyEvents]
        let ev = myEventsList[nameToDisplay!]
        
        self.stTitle.text = ev.title
        self.stNoats.text = ev.notes
        self.stLocation.text = ev.location
        self.stTimeAndDate.text = ev.time
        
        if let imUrl = ev.imageUrl{
            Model.instance.getImage(urlStr: imUrl, callback :{ (image) in
                self.ImageView.image = image
                
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onNavigate(_ sender: Any) {
        getDirections()
    }
    
    func getDirections(){
        let geocoder = CLGeocoder()
        let str = self.stLocation.text // A string of the address info you already have
        geocoder.geocodeAddressString(str!) { (placemarksOptional, error) -> Void in
            if let placemarks = placemarksOptional {
                let mkPlacemark = MKPlacemark(coordinate: (placemarks[0].location?.coordinate)!, addressDictionary: placemarks[0].addressDictionary as! [String : Any]?)
                let mapItem = MKMapItem(placemark: mkPlacemark)
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: launchOptions)
            } else {
                // Didn't get any placemarks. Handle error.
            }
        }
    }

}
