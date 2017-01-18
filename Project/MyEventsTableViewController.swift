//
//  MyEventsTableViewController.swift
//  Project
//
//  Created by admin on 01/01/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class MyEventsTableViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{

    @IBOutlet weak var MyEventsTableView: UITableView!
    var selectedIndex:Int?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        MyEventsTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let stDetailsVc = segue.destination as? EvantDetailsViewController{
            stDetailsVc.nameToDisplay = selectedIndex!
        }
    }

    ///Table View Data Source functions
    /////////////////////////////////////////
    // return how many rows in section
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shareInstance.eventsArray.count
    }
    
    //return the cell for each indexPath
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowCell = self.MyEventsTableView.dequeueReusableCell(withIdentifier: "myEventsCell", for: indexPath)
        
        let myEventsCell = rowCell as! MyEventsTableViewCell
        var image : UIImage
        image = #imageLiteral(resourceName: "Photo Libary")
        
        var ev:MyEvents = MyEvents("","","",image)
        ///sort the dates
        Model.shareInstance.eventsArray.sort (by: { $0.time! < $1.time! })
        
        ev = Model.shareInstance.eventsArray[indexPath.row]
        myEventsCell.stTitle.text = ev.title
        myEventsCell.stDate.text = ev.time
        myEventsCell.stImage.image = ev.image
        
        return rowCell
        
    }
    
    
    
    @IBAction func unwindToFirst(segue:UIStoryboardSegue)
    {
        print("back to first")
        
    }
    
    /// UITableViewDelegate function
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("didSelectRowAt \(indexPath)")
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "presentEventsDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            Model.shareInstance.eventsArray.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    
    @IBAction func delBtn(_ sender: AnyObject) {
        
        if(self.MyEventsTableView.isEditing == true)
        {
            self.MyEventsTableView.isEditing = false
        }
        else
        {
            self.MyEventsTableView.isEditing = true
        }
    }
    
    
///////////////////////////////
    /////////////////
    /////for Eliav
    // func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     //   return "Section \(section)"
   // }
    
    // func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      //  let header = tableView.dequeueReusableCell(withIdentifier: "myEventsCell") as CustomHeader
        
     //   return header
      
  //  }
  
    
    
}
