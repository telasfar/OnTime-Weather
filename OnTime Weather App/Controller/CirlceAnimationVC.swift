//
//  CirlceAnimationVC.swift
//  BackgroundAnimation

//hane3mel shape bel shapelayer we ne3melo bath be el UIBezierPathwe nesemo fe el layer beta3et el view we ne3melo el animation bel basic animation

import UIKit
import CoreData

class CirlceAnimationVC: UIViewController {
    
    //vars
    let shapeLayer = CAShapeLayer() //dah ely harsem beh
    
    @IBOutlet weak var lblDelete: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        createTrack() //hane3ml track yemshy feh el loading circle
        let center = view.center
        let cerclePAth = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi/2 , endAngle: CGFloat.pi * 2, clockwise: true) //-CGFloat.pi/2 3ashan yebda2 men nos el dayra foo2
        shapeLayer.path = cerclePAth.cgPath //han7adedlo hayersem eah
        shapeLayer.fillColor = UIColor.clear.cgColor //mafesh lon fe nos el dayra
        shapeLayer.strokeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        shapeLayer.lineCap = kCALineCapRound //3ashan el 7'at ely benersem beh mayeb2ash modabab
        shapeLayer.lineWidth = 7 //3ard el 7'at ely hayersem beh el stroke
        shapeLayer.strokeEnd = 0 //yewa2af el stroke feen we law 7ateteha be 0 mosh hayezhar
        view.layer.addSublayer(shapeLayer) //hanersem fe el view el ra2esy
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }

 
    @objc func handleTap(){
        
        let alert = UIAlertController(title: "Delete All BookMark", message: "Are you sure tp delete all bookmark ?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {
            (action) in
            self.deleteAllData("LocationDB")
            
        }))
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
        
 
    }
    
    func animateCircleLoading(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd") //3ashan a3mel el animation beta3et loading circle stroke ..we edetaha elkey strokeEnd  3ashan dah nehayet el path ely 3ayez 2a3melo animate
        basicAnimation.toValue = 1 //2a7'ro 1 law 7atet be nos hayeb2a be nos
        basicAnimation.duration = 1.5
        basicAnimation.fillMode = kCAFillModeForwards //etegah el animation
        basicAnimation.isRemovedOnCompletion = false //3ashan tefdal ba3d ma tekamel
        
        shapeLayer.add(basicAnimation, forKey: "animBasic") //animBasic dah key ana ely ba7oto
    }

    func deleteAllData(_ entity:String) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try manageContext.fetch(fetchRequest)
            if results.count == 0{
                self.alertUser(msg: "No Data to delete")
            }
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                manageContext.delete(objectData)
                try manageContext.save()
                animateCircleLoading()
                self.alertUser(msg: "All Records deleted Succefully ")

            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    func createTrack(){ //hane3ml track yemshy feh el loading circle
        let trackLAyer = CAShapeLayer()
        let cerclePAth = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -CGFloat.pi/2 , endAngle: CGFloat.pi * 2, clockwise: true) //-CGFloat.pi/2 3ashan yebda2 men nos el dayra foo2
        trackLAyer.path = cerclePAth.cgPath //han7adedlo hayersem eah
        trackLAyer.fillColor = UIColor.clear.cgColor //mafesh lon fe nos el dayra
        trackLAyer.strokeColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 1)
        trackLAyer.lineCap = kCALineCapRound //3ashan el 7'at ely benersem beh mayeb2ash modabab
        trackLAyer.lineWidth = 7 //3ard el 7'at ely hayersem beh el stroke
        view.layer.addSublayer(trackLAyer)
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        dissmissDetail()
    }
    
}
