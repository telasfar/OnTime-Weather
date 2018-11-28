//
//  HomeWeatherVC.swift
//  OnTime Weather App
//
//  Created by Tariq Maged on 11/25/18.
//  Copyright © 2018 Tariq. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class HomeWeatherVC: UIViewController {
    
    //MARK:- vars
    var locationArr = [LocationDB]()
    var  isMenuOpened = true

    //MARK:- outlets
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet  weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintMenu: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityIdentifier = "table--articleTableView"

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightAction))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(swipeRight)
        tableViewHeight.constant =  60.0

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        longPress.minimumPressDuration = 1.0
       mapKit.addGestureRecognizer(longPress)
        tableView.delegate = self
        tableView.dataSource = self
        fetchLocations { (success) in
            if success{
                self.tableView.reloadData()
                self.tableViewHeight.constant =  adjustTableViewheight() > 0.0 ? adjustTableViewheight():60.0
                
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomConstraintMenu.constant = -180
        mapKit.reloadInputViews()
        tableViewHeight.constant =  adjustTableViewheight() > 0.0 ? adjustTableViewheight():60.0
        tableView.reloadData()

    }
    
    func openCloseMenu(){
        if (isMenuOpened){
            bottomConstraintMenu.constant = 0
            animateMenu(viewMwnu: menuView, moveDirect: kCATransitionFromRight)
        }else{
            bottomConstraintMenu.constant = -180
            animateMenu(viewMwnu: menuView, moveDirect: kCATransitionFromLeft)
        }
        
        isMenuOpened = !isMenuOpened
    }
    
    
    
    @objc func swipeRightAction(){
        bottomConstraintMenu.constant = -180
        animateMenu(viewMwnu: menuView, moveDirect: kCATransitionFromLeft)
        isMenuOpened = true
    }
    
    @objc func handleGesture (_ gesture : UIGestureRecognizer) {

        let touchPoint = gesture.location(in: self.mapKit)
        let newCordinate : CLLocationCoordinate2D = mapKit.convert(touchPoint, toCoordinateFrom: mapKit)

        mapKit.addAnnotation(makeAnnotation(loc: newCordinate))

    }
    
    func adjustTableViewheight()->CGFloat{
        if locationArr.count < 4 && locationArr.count >= 0 {
            return CGFloat(locationArr.count) * 60.0
        }else{
            return 250.0
        }
    }
    
    func makeAnnotation(loc:CLLocationCoordinate2D  )-> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = loc
        
        let alert = UIAlertController(title: "Add Bookmark", message: "please enter name for the choosen Location", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { (action) in
            var text = alert.textFields?[0].text ?? ""
            if text == ""{
                let num = arc4random()
                text = "Not Entered \(num%10000)"
            }
          
            self.saveLocations(latitude: loc.latitude, longitude: loc.longitude, name: text)
            annotation.title = text
            
            self.fetchLocations { (success) in
                if success{
                   
                    self.tableViewHeight.constant =  self.adjustTableViewheight() > 0.0 ? self.adjustTableViewheight():60.0
                     self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.locationArr.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
                }
            }
          
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
      
        return annotation
    }
    
    func saveLocations(latitude:Double ,longitude:Double,name:String){
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        let location = LocationDB(context: manageContext)
        location.latitude = latitude
        location.longitude = longitude
        location.locationname = name
        do {
            try     manageContext.save()
            
        }catch  {
            debugPrint(error.localizedDescription)
            
        }

    }
    
    func removeLocation (indexPath : IndexPath){ //hab3at men el tableview indexpath beta3 el row ely hayet7azaf
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
        let fetchRequest = NSFetchRequest<LocationDB>(entityName: "LocationDB")//2adem talab lel2edara be2esm el entiti ely enta 3ayezaha
        do {
            locationArr =   try   manageContext.fetch(fetchRequest) //el2edara tenafez el alab we teraga3 el data fe array
            complition(true)
        }catch {
            debugPrint("couldn't get data \(error.localizedDescription)")
        }
    }
    
    
    
    //MARK:- Actions
    @IBAction func btnMenuPressed(_ sender: UIButton) {
        openCloseMenu()
    }
    
    @IBAction func btnHelpPressed(_ sender: UIButton) {
        guard let categorySB = self.storyboard?.instantiateViewController(withIdentifier: "HelpVC") as? HelpVC else {return}
            self.presentDetail(categorySB)
    }
    
    @IBAction func btnSettingPressed(_ sender: UIButton) {
        guard let categorySB = self.storyboard?.instantiateViewController(withIdentifier: "CirlceAnimationVC") as? CirlceAnimationVC else {return}
        
        self.presentDetail(categorySB)
    }
}
extension HomeWeatherVC:UITableViewDelegate,UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locationArr.count == 0 {
            return 1
        }
        return locationArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else {return UITableViewCell()}
        cell.accessibilityIdentifier = "myCell_\(indexPath.row)"

        if indexPath.row != 0 {
            cell.lblLocationName.text = locationArr[indexPath.row].locationname

        }else{
            cell.selectionStyle = .none
            cell.lblLocationName.text = "Your Bookmark Locations".uppercased()
            cell.lblLocationName.textAlignment = .center
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { //3ashan ne3mel edit fe l tableview
        if indexPath.row != 0{
            return true
        }else{
            return false
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (action, indexPath) in
            self.removeLocation(indexPath: indexPath)
            self.locationArr.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
          self.tableViewHeight.constant =  self.adjustTableViewheight() > 0.0 ? self.adjustTableViewheight():60.0
            
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
