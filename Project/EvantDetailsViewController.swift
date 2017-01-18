//
//  EvantDetailsViewController.swift
//  Project
//
//  Created by admin on 28/12/2016.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class EvantDetailsViewController: UIViewController {

    var nameToDisplay : Int?
    
    
    @IBOutlet weak var stTitle: UILabel!
    @IBOutlet weak var stNoats: UILabel!
    @IBOutlet weak var stTimeAndDate: UILabel!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    //image
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Event Details"
        var image :UIImage
        image = #imageLiteral(resourceName: "Photo Libary")
        var ev:MyEvents = MyEvents("","","",image)
         ev = Model.shareInstance.eventsArray[nameToDisplay!]
        
        self.stTitle.text = ev.title
        self.stNoats.text = ev.noats
        self.stTimeAndDate.text = ev.time
        self.ImageView.image = ev.image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
