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
        viewControl.modalPresentationStyle = .fullScreen
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
    

    func alertUser (message:String){
           let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
         
           self.present(alert, animated: true, completion: nil)
       }
       
       
       func shouldPresentLoadingView(_ status:Bool){
           var fadeView:UIView
           if status {
               if Holder._myComputedProperty{
               fadeView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
               fadeView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
               fadeView.alpha = 0.0
               fadeView.tag = 991
               let spinner = UIActivityIndicatorView() //spinner
               spinner.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                spinner.activityIndicatorViewStyle = .whiteLarge
               spinner.center = view.center
               view.addSubview(fadeView)//7atenah el 2awel fa hyro7 lel backGround
               fadeView.addSubview(spinner) //hayet7at fo2 el fadeView
               fadeView.fadeTo(alphaValue: 0.7, withDuration: 0.3)
               spinner.startAnimating()
               Holder._myComputedProperty = false
               }
           }else {
               Holder._myComputedProperty = true
               for subview in view.subviews {
                   if subview.tag == 991 {
                       UIView.animate(withDuration: 0.3, animations: {
                           subview.alpha = 0.0
                           
                       }, completion: { (finish) in
                           subview.removeFromSuperview() //elspinner hayetshal ma3a el fadeview
                       })
                   }
               }
           }
       }
    
    
    
}

