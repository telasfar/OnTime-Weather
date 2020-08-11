//
//  GradientLabel.swift
//  Elsawy
//
//  Created by Tariq Maged on 4/30/19.
//  Copyright © 2019 Tariq Maged. All rights reserved.
//

import UIKit

@IBDesignable
class GradientLabel: UILabel {
    
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1) {
        didSet { setNeedsLayout() }
    }
    //setNeedsLayout...tells the system that you want it to layout and redraw that view and all of its subviews, when it is time for the update cycle. This is an asynchronous activity, because the method completes and returns immediately 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateTextColor()
    }
    
    private func updateTextColor() {
        let image = UIGraphicsImageRenderer(bounds: bounds).image { context in
            let colors = [topColor.cgColor, bottomColor.cgColor]
            guard let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: nil) else { return }
            context.cgContext.drawLinearGradient(gradient,
                                                 start: CGPoint(x: bounds.midX, y: bounds.minY),
                                                 end: CGPoint(x: bounds.midX, y: bounds.maxY),
                                                 options: [])
        }
        
        textColor = UIColor(patternImage: image)
    }
    

    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        let gredient = GradientView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
//        gredient.bottomColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
//        gredient.topColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
//        setTextColorToGradient(image: imageWithView(view: gredient)!)
//    }

    
//    func imageWithView(view: UIView) -> UIImage? {//bet7awel uiview to image
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
//        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return img
//    }
//
//    func setTextColorToGradient(image: UIImage) {//beta7'od image we tekteb beha el text fe el label
//        UIGraphicsBeginImageContext(frame.size)
//        image.draw(in: bounds)
//        let myGradient = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        textColor = UIColor(patternImage: myGradient!)
//
//    }

}
//You don’t want to rely on awakeFromNib. Furthermore, you really don’t want to do this in init, either, as you want to be able to respond to size changes (e.g. if you have constraints and the frame changes after the label is first created)....Instead, update your gradient from layoutSubviews, which is called whenever the view’s frame changes:

//setNeedsDisplay() //thatis how i tell the system to redraw my self ...we deh ely tala3et 3eny fe el tableview

//layoutIfNeeded() ... tells the system you want a layout and redraw of a view and its subviews, and you want it done immediately without waiting for the update cycle

//layoutSubviews...to determine the size and position of any subviews....Subclasses can override this method as needed to perform more precise layout of their subviews..You should not call this method directly. If you want to force a layout update, call the setNeedsLayout() method instead to do so prior to the next drawing update. If you want to update the layout of your views immediately, call the layoutIfNeeded() method.

//UIGraphicsImageRenderer...You can use image renderers to accomplish drawing tasks, without having to handle configuration such as color depth and image scale, or manage Core Graphics contexts...we beha momken arsem imge 3an tare2 eny 2a3mel .image we amla el clousre bely harsem beh el image

//UIGraphicsBeginImageContext ..3ashan ne7adar context nersem beh image we el geded beta3aha el func ely fatet

/* HOW TO DROW AN IMAGE
Make an image graphics context. (Before iOS 10, you would do this by calling UIGraphicsBeginImageContextWithOptions. In iOS 10 there's another way, UIGraphicsImageRenderer, but you don't have to use it if you don't want to.)

Draw (i.e. copy) the image into the context. (UIImage actually has draw... methods for this very purpose.)

Draw your line into the context. (There are CGContext functions for this.)

Extract the resulting image from the context. (For example, if you used UIGraphicsBeginImageContextWithOptions, you would use UIGraphicsGetImageFromCurrentImageContext.) Then close the context

*/
