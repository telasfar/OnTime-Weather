//
//  SplashScreenVC.swift
//  ONTime Weather


import UIKit
import Lottie
class SplashScreenVC: UIViewController {

    @IBOutlet  var viewAnimate: LOTAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(splashTimeOut))
        gesture.direction = .left
        view.addGestureRecognizer(gesture)
         Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(splashTimeOut), userInfo: nil, repeats: false)
        animateWeather()
    }

    func animateWeather(){
         viewAnimate.setAnimation(named: "a_simple_sun_day")
        viewAnimate.play()
    }

    @objc func splashTimeOut(){
        guard let categorySB = self.storyboard?.instantiateViewController(withIdentifier: "HomeWeatherVC") as? HomeWeatherVC else {return}
        self.presentDetail(categorySB)
        
    }

}

