//
//  BookMarkedVC.swift
//  BackgroundAnimation

//hane3mel shape bel shapelayer we ne3melo bath be el UIBezierPathwe nesemo fe el layer beta3et el view we ne3melo el animation bel basic animation

import UIKit
import CoreData

class BookMarkedVC: UIViewController {
    
    //outlets
    @IBOutlet weak var btnDelete: ButtonRounded!
    @IBOutlet weak var tableViewBookMark: TanibleView!
    
    //vars
    var locationArr = [LocationDB]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewBookMark.delegate = self
        tableViewBookMark.dataSource = self
        tableViewBookMark.tableFooterView = UIView()
        btnDelete.addTarget(self, action: #selector(handleBtnTap), for: .touchUpInside)
        loadData()
    }
    
    
    
   
    func loadData(){
        self.fetchLocations { (success) in
            if success{
                if locationArr.isEmpty{
                    btnDelete.isEnabled = false
                    btnDelete.setTitle("No Bookmarked Data", for: .normal)
                }
                DispatchQueue.main.async {
                    self.tableViewBookMark.direction = .right
                    self.tableViewBookMark.setNeedsDisplay()
                    self.tableViewBookMark.reloadData()
                }
             
            }
        }
    }
 
    @objc func handleBtnTap(){
        let alert = UIAlertController(title: "Delete All BookMark", message: "Are you sure tp delete all bookmark ?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {
            (action) in
            self.deleteAllData("LocationDB")
            
        }))
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
        
 
    }
    
    func removeLocation (indexPath : IndexPath){
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        manageContext.delete(locationArr[indexPath.row])
        do {
            try manageContext.save()
        }catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func fetchLocations (complition : (_ complete : Bool)-> () ){
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        let fetchRequest = NSFetchRequest<LocationDB>(entityName: "LocationDB")
        do {
            locationArr =   try   manageContext.fetch(fetchRequest)
            complition(true)
        }catch {
            debugPrint("couldn't get data \(error.localizedDescription)")
        }
    }
    

    func deleteAllData(_ entity:String) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try manageContext.fetch(fetchRequest)
            if results.count == 0{
                alertUser(message: "No Data to delete")
                return
            }
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                manageContext.delete(objectData)
                try manageContext.save()
                
            }
            alertUser( message: "All Records deleted Succefully ")
            locationArr.removeAll()
            tableViewBookMark.reloadData()
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
   
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        dissmissDetail()
    }
    
}


extension BookMarkedVC:UITableViewDelegate,UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locationArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else {return UITableViewCell()}   
            cell.lblLocationName.text = locationArr[indexPath.row].locationname
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { 
            return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (action, indexPath) in
            self.removeLocation(indexPath: indexPath)
            self.locationArr.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
     
            
        }
     // deleteAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
       deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.6127007604, blue: 0.03426229581, alpha: 1)
        
        
        return [deleteAction] //matensash tedef el action
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categorySB = self.storyboard?.instantiateViewController(withIdentifier: "WeatherVC") as? WeatherVC else {return}
        if indexPath.row != 0{
        categorySB.initLocation(loc: locationArr[indexPath.row])
            self.presentDetail(categorySB)
        }
        
    }
}
