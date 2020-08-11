//
//  AnimatorFactory.swift
//  Elsawy
//
//  Created by Tariq Maged on 9/25/19.
//  Copyright © 2019 Tariq Maged. All rights reserved.
//

import UIKit

class AnimatorFactory{
    static func scaleUpOrDown(view: UIView,_ isScaleUp:Bool) -> UIViewPropertyAnimator {
      let scale = UIViewPropertyAnimator(duration: 0.3,
        curve: .easeIn)
      scale.addAnimations {
        view.alpha = isScaleUp ? 1.0:0.0
      }
      scale.addAnimations({
        
        view.transform = isScaleUp ? CGAffineTransform.identity:CGAffineTransform(scaleX: 1, y: 0.2)
      }, delayFactor: 0)
      scale.addCompletion {_ in
        print("ready")
      }
      return scale//haraga3aha we ab2a 2a3melha start fe elclass ely an 3ayzo
    }
    
    @discardableResult//3ashan ahmel elreturn beta3 el function law masta7'demtosh zay anchor() keda
    static func jiggleView(_ view: UIView) -> UIViewPropertyAnimator {
        //bethez Elview yemen we shemal
        return UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.66, delay: 0.3, animations: {
                
                //add keyframe inside the propertyAnimator
                UIView.animateKeyframes(withDuration: 1, delay: 0,
                                        animations: {
                                            UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                               relativeDuration: 0.25) {
                                                                view.transform = CGAffineTransform(rotationAngle: -.pi/8)
                                            }
                                            UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                               relativeDuration: 0.75) {
                                                                view.transform = CGAffineTransform(rotationAngle: +.pi/8)
                                            }
                                            UIView.addKeyframe(withRelativeStartTime: 0.75,
                                                               relativeDuration: 1.0) {
                                                                view.transform = CGAffineTransform.identity
                                            }
                },
                                        completion: nil
                )
        },
            completion: {_ in
                view.transform = .identity//haraga3o le7agmo el2asly
        }
        )
        
    }
    
    
    //han7ot temp label shafaf fo2 el label el 2asly bel text el geded
    static func moveLabel(label: UILabel, text: String, offset: CGPoint,containerView:UIView) {
           let auxLabel = UILabel(frame: label.frame)
           auxLabel.text = text
           auxLabel.font = label.font
           auxLabel.textAlignment = label.textAlignment
           auxLabel.textColor = label.textColor
           auxLabel.backgroundColor = UIColor.clear
           auxLabel.transform = CGAffineTransform(translationX: offset.x, y:
               offset.y)
           auxLabel.alpha = 0
           containerView.addSubview(auxLabel)
           //ha7arak el label el 2sly we a7'feh
           UIView.animate(withDuration: 0.5, delay: 0.0,
                          options: .curveEaseIn,
                          animations: {
                           label.transform = CGAffineTransform(translationX: offset.x, y:
                               offset.y)
                           label.alpha = 0.0
           },
                          completion: nil
           )
           
           //hazher el temp label
           UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseIn,
                          animations: {
                           auxLabel.transform = .identity
                           auxLabel.alpha = 1.0
           },
                          completion: {_ in
                           //clean up...hashel eltemb we aset el text el geded fe el label el2asly we arag3o le7agmo el 2asay
                           auxLabel.removeFromSuperview()
                           label.text = text
                           label.alpha = 1.0
                           label.transform = .identity
           } )
           
       }
    
    //han7ot temporery label bel data el geda fo2 ellabel el asly we hwa mesta7'dem el 1 we el -1 3ashan ye7aded el direction
    enum AnimationDirection: Int {
        case positive = 1
        case negative = -1
    }
    
    static func cubeTransition(label: UILabel, text: String, direction:
        AnimationDirection) {
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = label.backgroundColor
        let auxLabelOffset = CGFloat(direction.rawValue) *
            label.frame.size.height/2.0
        //eltransform hena effect lel view nafso
        auxLabel.transform = CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(
                CGAffineTransform(translationX: 0.0, y: auxLabelOffset)//la7ez el ely fe el scale be 0.1 fa haykon el label mad3'ot we fo2 el label el asly..we la7ez enak bete3mel concatenating le etnen transform
        )
        label.superview?.addSubview(auxLabel)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut,
                       animations: {
                        auxLabel.transform = .identity
                        label.transform =
                            CGAffineTransform(scaleX: 1.0, y: 0.1).concatenating(
                                CGAffineTransform(translationX: 0.0, y: -auxLabelOffset)//hansa3'ar el label el 2asly we na7arko we nekbar el temb we ka2no bey3melo push fe nfs el etegah
                        )
        },
                       completion: {_ in
                        //we ne3mel set lel label text we neshel el temb label men elsuperview
                        label.text = auxLabel.text
                        label.transform = .identity
                        auxLabel.removeFromSuperview()
        }
        )
    }

    static func fadeFromImage(imageView: UIImageView, toImage: UIImage, showEffects: Bool) {
          //we ana ba7ot el image el gededa ba7'fy el 2adema be nafs el duration
          UIView.transition(with: imageView, duration: 1.0,
                            options: .transitionCrossDissolve,
                            animations: {
                              imageView.image = toImage
          },
                            completion: nil
          )
          UIView.animate(withDuration: 1.0, delay: 0.0,
                         options: .curveEaseOut,
                         animations: {
                        //  self.snowView.alpha = showEffects ? 1.0 : 0.0
          },
                         completion: nil
          )
      }
    
    static func planeDepart(planeImage:UIImageView) {
          let originalCenter = planeImage.center
          UIView.animateKeyframes(withDuration: 1, delay: 0.0,
                                  animations: {
          //el 1.5 deh modet el animation kolaha
          UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25,animations: {
              //el 0.25 hya 25% men el 1.5 (modet el keyframe dah) haynafez elsatreen ely ta7t men 0.0 ya3ny bedayet el animation
                      planeImage.center.x += 80.0
                      planeImage.center.y -= 10.0
                                      })
                                      
          //men 10% men el duration(1.5) lemodet 40% handawar el tayara
           UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
              planeImage.transform = CGAffineTransform(rotationAngle: -.pi / 8)
          }
           
              UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                  //hanfade el plane ba3d 25% we lemodet 25%
                      planeImage.center.x += 100.0
                      planeImage.center.y -= 50.0
                      planeImage.alpha = 0.0
                  }
          
              UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01) {
                  //han7ot el tayara 3ala awel el shsasha men el shemal we hya el alpha bate3etaha be 0 le makanha el 2asly
                   planeImage.transform = .identity
                   planeImage.center = CGPoint(x: 0.0, y: originalCenter.y)
                  }
              UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45) {
                  //hanezher eltayara fe maknaha we ka2enaha bete3mel landing
                  planeImage.alpha = 1.0
                  planeImage.center = originalCenter
                                      }
          },
                                  completion: nil
          )
          //It’s a short step to imagine your animation as a series of separate animations with delays in between, or even as a set of animations triggered from completion closures. Keyframes are an incredibly useful and flexible way to design and control your animations.
          
      }
    
   static func animateCloud(_ cloud: UIImageView,mainView:UIView) {//bey7arak el sa7aba le aksa el shasha
      let cloudSpeed = 60.0 / mainView.frame.size.width
      let duration = (mainView.frame.size.width - cloud.frame.origin.x) * cloudSpeed
      UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveLinear,
        animations: {
          cloud.frame.origin.x = mainView.frame.size.width
        },
        completion: {_ in
          cloud.frame.origin.x = -cloud.frame.size.width
            self.animateCloud(cloud, mainView: mainView)
        }
      )
    }

    static func animateTextField(textField:UITextField,flashed:Bool){
       
           guard let text = textField.text else { return }
           
           if text.count < 5 {
             // add animations here
             let jump = CASpringAnimation(keyPath: "position.y")
             jump.initialVelocity = 100.0
             jump.mass = 10.0
             jump.stiffness = 1500.0
             jump.damping = 50.0
             jump.fromValue = textField.layer.position.y + 1.0
             jump.toValue = textField.layer.position.y
             jump.duration = jump.settlingDuration
             textField.layer.add(jump, forKey: nil)
            
             if flashed{
             textField.layer.borderWidth = 3.0
             textField.layer.borderColor = UIColor.clear.cgColor
             let flash = CASpringAnimation(keyPath: "borderColor")
             flash.damping = 7.0
             flash.stiffness = 200.0
             flash.fromValue = UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0).cgColor
             flash.toValue = UIColor.white.cgColor
             flash.duration = flash.settlingDuration
             textField.layer.add(flash, forKey: nil)
            }
           }
         }
    
    static func animateBackgroundColor(layer: CALayer, toColor: UIColor) {
      let tint = CASpringAnimation(keyPath: "backgroundColor")
      tint.damping = 5.0
      tint.initialVelocity = -10.0
      tint.fromValue = layer.backgroundColor
      tint.toValue = toColor.cgColor
      tint.duration = tint.settlingDuration
      layer.add(tint, forKey: nil)
      layer.backgroundColor = toColor.cgColor
    }

    static func animateRoundCorners(layer: CALayer, toRadius: CGFloat) {
      let round = CASpringAnimation(keyPath: "cornerRadius")
      round.damping = 5.0
      round.fromValue = layer.cornerRadius
      round.toValue = toRadius
      round.duration = round.settlingDuration
      layer.add(round, forKey: nil)
      layer.cornerRadius = toRadius
    }
    
      @discardableResult
      static func animateConstraint(view: UIView, constraint:
        NSLayoutConstraint, by: CGFloat) -> UIViewPropertyAnimator {
        let spring = UISpringTimingParameters(dampingRatio: 0.55)//3amal spring animator
        let animator = UIViewPropertyAnimator(duration: 1.0,
          timingParameters: spring)
        animator.addAnimations {
          constraint.constant += by
          view.layoutIfNeeded()
        
        }
        return animator
      }
      
   static func animateCAlayer(_ layerShape:CAShapeLayer){
             // add animations here
             let jump = CASpringAnimation(keyPath: "position.y")
             jump.initialVelocity = 100.0
             jump.mass = 10.0
             jump.stiffness = 1500.0
             jump.damping = 50.0
             jump.fromValue = layerShape.position.y + 1.0
             jump.toValue = layerShape.position.y
             jump.duration = jump.settlingDuration
             layerShape.add(jump, forKey: nil)

             let flash = CASpringAnimation(keyPath: "transform.scale")
             flash.damping = 17.0
            // flash.initialVelocity = 100.0
             //flash.mass = 10.0
             flash.stiffness = 200.0
             flash.fromValue = 0
             flash.toValue = 1
             flash.duration = flash.settlingDuration
             layerShape.add(flash, forKey: nil)
         
          // CGAffineTransform.identity:CGAffineTransform(scaleX: 1, y: 0.2)
         }
    
    static func animateDeleteView(_ view:UIView,_ isopen:Bool){
           UIView.transition(with: view, duration: 0.7, options: [.transitionCurlDown,.curveEaseOut], animations: {
               view.isHidden = isopen
           }, completion: nil)
       }
    
}
    



//animateCloud by CABasicAnimation
//func animateCloud(layer: CALayer) {
//
//  //1
//  let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
//  let duration: TimeInterval = Double(view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
//
//  //2
//  let cloudMove = CABasicAnimation(keyPath: "position.x")
//  cloudMove.duration = duration
//  cloudMove.toValue = self.view.bounds.size.width + layer.bounds.width/2
//  cloudMove.delegate = self
//  cloudMove.fillMode = CAMediaTimingFillMode.forwards
//  cloudMove.setValue("cloud", forKey: "name")
//  cloudMove.setValue(layer, forKey: "layer")
//  layer.add(cloudMove, forKey: nil)
//}
