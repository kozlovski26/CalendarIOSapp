//
//  MyEventsTableViewController.swift
//  Project
//
//  Created by admin on 01/01/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit


class MyEventsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    static let instance = MyEventsTableViewController()
    @IBOutlet weak var MyEventsTableView: UITableView!
    var myEventsList = [MyEvents]()
    var selectedIndex:Int?
 
    
    override func viewWillAppear(_ animated: Bool) {

        NotificationCenter.default.addObserver(self, selector:
        #selector(MyEventsTableViewController.MyEventsListDidUpdate),name: NSNotification.Name(rawValue: notifyMyEventsListUpdate),object: nil)
        Model.instance.getAllMyEventsAndObserve()
            self.MyEventsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MyEventsTableViewController.MyEventsListDidUpdate),name: NSNotification.Name(rawValue: notifyMyEventsListUpdate),object: nil)
         Model.instance.getAllMyEventsAndObserve()
      
    
            self.MyEventsTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    @objc func MyEventsListDidUpdate(notification:NSNotification){
        self.myEventsList = notification.userInfo?["events"] as! [MyEvents]
        self.MyEventsTableView.reloadData()
        //self.myEventsList.sort (by: { $0.time < $1.time })
        
        //sort()
        
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func sort() {
      //self.myEventsList.sort (by: { $0.time < $1.time })
//        eventDic = [String:[MyEvents]]()
//        var events = [(date: Date, event: MyEvents)]()
//        for event in self.myEventsList {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
//            let date = dateFormatter.date(from: event.time)
//            if date == nil {
//                continue
//            }
//            events.append((date!, event))
//        }
//        events.sort(by: { $0.date < $1.date })
//        for event in events {
//            let calendar = Calendar.current.dateComponents([.day, .month, .year], from: event.date)
//            let day = calendar.day
//            let month = calendar.month
//            let year = calendar.year
//            let d = "\(day!)/\(month!)/\(year!)"
//            let dayInDic = eventDic[d]
//            if dayInDic == nil {
//                dates.append(d)
//                eventDic[d] = [MyEvents]()
//            }
//            eventDic[d]?.append(event.event)
//            
//        }
//        MyEventsTableView.reloadData()
//    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let stDetailsVc = segue.destination as? EvantDetailsViewController{
            stDetailsVc.nameToDisplay = selectedIndex!
        }
    }

//     func numberOfSections(in tableView: UITableView) -> Int {
//        return myEventsList.count
//    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myEventsList.count
        
    }
    
    ///Table View Data Source functions
    /////////////////////////////////////////
    // return how many rows in section
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       return self.eventDic[dates[section]]!.count
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return dates[section]
//    }
    
    //return the cell for each indexPath
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEventsCell", for: indexPath) as! MyEventsTableViewCell
       // let key = dates[indexPath.section]
        cell.stTitle!.text = myEventsList[indexPath.row].title //self.eventDic[key]?[indexPath.row].title //self.myEventsList[indexPath.row].title
        cell.stDate!.text = myEventsList[indexPath.row].time //self.eventDic[key]?[indexPath.row].time //self.myEventsList[indexPath.row].time
        
        if let imUrl = myEventsList[indexPath.row].imageUrl { //self.eventDic[key]?[indexPath.row].imageUrl { //self.myEventsList[indexPath.row].imageUrl{
            Model.instance.getImage(urlStr: imUrl, callback :{ (image) in
                cell.stImage!.image = image
            
            })
        }
        return cell
    
        
        
    }
    
    
    
    @IBAction func unwindToFirst(segue:UIStoryboardSegue)
    {
        print()
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
            Model.instance.deleteEvents(name: myEventsList[indexPath.row].title)
            self.myEventsList.remove(at:indexPath.row)
            //Model.instance.eventsArray.remove(at:indexPath.row)
            
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
   
    
    
    
    

    
    
}
