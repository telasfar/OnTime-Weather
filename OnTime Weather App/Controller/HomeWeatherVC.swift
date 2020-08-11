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
    var  isMenuOpened = false
    var isCityValid = false
    var isCountryValid = false

    //MARK:- outlets
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var imgCity: UIImageView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var btnSearch: ButtonRounded!
    @IBOutlet weak var txtFieldCountry: CustomTextField!
    @IBOutlet weak var txtFieldCity: CustomTextField!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var bottomConstraintMenu: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        handleAllGestures()
        btnSearch.isEnabled = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isMenuOpened = false
    }
    
    private func handleAllGestures(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightAction))
         swipeRight.direction = UISwipeGestureRecognizerDirection.right
         view.addGestureRecognizer(swipeRight)

         let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
         longPress.minimumPressDuration = 1.0
        mapKit.addGestureRecognizer(longPress)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomConstraintMenu.constant = -180
        mapKit.reloadInputViews()
    }
    
    func openCloseMenu(){
        isMenuOpened = !isMenuOpened
        view.bringSubview(toFront: menuView)
        if (isMenuOpened){
            bottomConstraintMenu.constant = 0
            animateMenu(viewMwnu: menuView, moveDirect: kCATransitionFromRight)
        }else{
            bottomConstraintMenu.constant = -180
            animateMenu(viewMwnu: menuView, moveDirect: kCATransitionFromLeft)
        }
    }
    
  
    
    @objc func swipeRightAction(){
        bottomConstraintMenu.constant = -180
        animateMenu(viewMwnu: menuView, moveDirect: kCATransitionFromLeft)
        isMenuOpened = false
    }
    
    @objc func handleLongGesture (_ gesture : UIGestureRecognizer) {

        let touchPoint = gesture.location(in: self.mapKit)
        let newCordinate : CLLocationCoordinate2D = mapKit.convert(touchPoint, toCoordinateFrom: mapKit)

        mapKit.addAnnotation(makeAnnotation(loc: newCordinate))

    }
 
    
    func makeAnnotation(loc:CLLocationCoordinate2D  )-> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = loc
        
        let alert = UIAlertController(title: "Add Bookmark", message: "please enter name for the choosen Location", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Search & Save", style: UIAlertActionStyle.default, handler: { (action) in
            var text = alert.textFields?[0].text ?? ""
            if text == ""{
                let num = arc4random()
                text = "Not Entered \(num%10000)"
            }
          
            let location = self.saveLocations(latitude: loc.latitude, longitude: loc.longitude, name: text)
            annotation.title = text
            
            guard let weatherVC = self.storyboard?.instantiateViewController(withIdentifier: "WeatherVC") as? WeatherVC else {return}
            weatherVC.isFromMap = true
            if let location = location {
            weatherVC.initLocation(loc: location)
            self.presentDetail(weatherVC)
            }
            
          
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
      
        return annotation
    }
    
    func saveLocations(latitude:Double ,longitude:Double,name:String)->LocationDB?{
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return nil}
        let location = LocationDB(context: manageContext)
        location.latitude = latitude
        location.longitude = longitude
        location.locationname = name
        do {
            try     manageContext.save()
            
        }catch  {
            debugPrint(error.localizedDescription)
            
        }
       return location
    }
    
    
    
    
    
    //MARK:- Actions
    @IBAction func btnMenuPressed(_ sender: UIButton) {
        openCloseMenu()
    }
    
   
    
    @IBAction func btnSettingPressed(_ sender: UIButton) {
        guard let categorySB = self.storyboard?.instantiateViewController(withIdentifier: "BookMarkedVC") as? BookMarkedVC else {return}
        
        self.presentDetail(categorySB)
    }
    
    @IBAction func txtFieldCountryChanged(_ sender: CustomTextField) {
          isCountryValid = sender.text?.count ?? 0 >= 2
          imgCountry.image = isCountryValid ? #imageLiteral(resourceName: "PRGVFValid"):#imageLiteral(resourceName: "PRGVFInvalid")
          btnSearch.isEnabled = isCountryValid && isCityValid
      }
      
      @IBAction func txtFieldCityChanged(_ sender: CustomTextField) {
          isCityValid = sender.text?.count ?? 0 >= 3
          imgCity.image = isCityValid ? #imageLiteral(resourceName: "PRGVFValid"):#imageLiteral(resourceName: "PRGVFInvalid")
          btnSearch.isEnabled = isCountryValid && isCityValid
      }
      
      @IBAction func btnSearchPressded(_ sender: ButtonRounded) {
          guard let city = txtFieldCity.text ,let country = txtFieldCountry.text else {return}
        shouldPresentLoadingView(true)
        DataService.instance.getWeatherByCity(city: city, country: country) { (success, weather) in
            if success{
                guard let weatherVC = self.storyboard?.instantiateViewController(withIdentifier: "WeatherVC") as? WeatherVC else {return}
                weatherVC.isFromMap = false
                weatherVC.weatherResource = weather
                self.presentDetail(weatherVC)
            }else{
                self.alertUser(message: "Connection Error")
            }
            self.shouldPresentLoadingView(false)
        }
      }
}

