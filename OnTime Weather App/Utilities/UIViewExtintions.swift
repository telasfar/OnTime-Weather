//
//  UIViewExtintions.swift
//  ONTime Weather

import Foundation


import UIKit
import Foundation

extension UIViewController {
    
    func presentDetail(_ viewControl : UIViewController){  //func ta7'od el viewcontroller ely hane3melo present
        let transtion = CATransition() //CA 2e7'tesar Core Animation ..lazem ne3mel create lel transtion
        transtion.duration = 0.3
        transtion.type = kCATransitionPush
        transtion.subtype = kCATransitionFromRight  //hato men el yemen
        self.view.window?.layer.add(transtion, forKey: kCATransition)    //hane3mel add lel transion
        present(viewControl, animated: false, completion: nil) //ha7ot el animated be false le 2an ana 3amel animation aslan we mosh me7tag ely mawgod by default
        
    }
    
    
    
    func dissmissDetail (){
        let transtion = CATransition() //CA 2e7'tesar Core Animation ..lazem ne3mel create lel transtion
        transtion.duration = 0.3
        transtion.type = kCATransitionPush
        transtion.subtype = kCATransitionFromLeft  //hato men el yemen
        self.view.window?.layer.add(transtion, forKey: kCATransition)    //hane3mel add lel transion
        dismiss(animated: false, completion: nil)
    }
    
    func alertUser (msg :String){
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action) in
            guard let categorySB = self.storyboard?.instantiateViewController(withIdentifier: "SplashScreenVC") as? SplashScreenVC else {return}
            
            self.presentDetail(categorySB)
            
        }))
        alert.message = msg
        self.present(alert, animated: true, completion: nil)
    }

    
    func animateMenu (viewMwnu : UIView,moveDirect:String){
        let transaction = CATransition()
        let withDuration = 0.5
        transaction.duration = withDuration
        transaction.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transaction.type = kCATransitionPush
        transaction.subtype = moveDirect
        viewMwnu.layer.add(transaction, forKey: kCATransition)
    }
    
    
    
    func showLoading(_ state : Bool) {
        
        let overlayView = UIView()
        let activityIndicator = UIActivityIndicatorView()
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            
            overlayView.frame = CGRect(x:0, y:0, width:80, height:80)
            overlayView.center = CGPoint(x: window.frame.width / 2.0, y: window.frame.height / 2.0)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            overlayView.clipsToBounds = true
            overlayView.layer.cornerRadius = 10
            activityIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
            activityIndicator.activityIndicatorViewStyle = .whiteLarge
            activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
            if state {
                overlayView.addSubview(activityIndicator)
                window.addSubview(overlayView)
                activityIndicator.startAnimating()
            }else {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
                overlayView.isHidden = true
                overlayView.removeFromSuperview()
            }
        }
    }
    

    
    
    
    
}


extension UIView { //hane3mel extinsion le uiview ely beyweres meno el elements zy elbutton we eltextfield we keda
    
    func bindToKeyboard(){
        //nedeef observer yetabe3 el keyboard we ba3d keda ye3mel action eno yerfa3 el send key le foo2
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc  func keyboardWillChange (notification : NSNotification){ //elnotification hwa el observer ely haydena elma3lomat beta3et el animatekeyfram
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double  //a7'adna el duration ely hatesta3'rekaha el kb fe el zohor we hanedeha nafsaha lel button
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue  //bedayet 7araket el animation we ne3melaha cast le ns value we ne7awelaha le cgrect
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil) //han7arak frame beta3 element
    }
    
}


