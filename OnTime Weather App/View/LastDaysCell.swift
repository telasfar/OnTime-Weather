//
//  LastDaysCell.swift
//  OnTime Weather App
//


import UIKit

class LastDaysCell: UITableViewCell {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblTempMax: UILabel!
    @IBOutlet weak var lblTempMin: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.layer.cornerRadius = 5
        // Initialization code
    }

    func configCell(weather:WeatherModel){
       lblDescription.text = "Weather is \(weather.description) "
       lblTempMax.text = "MAX Temp. is \(weather.tempMax) C"
       lblTempMin.text = "MIN Temp is \(weather.tempMin) C"
        
    }

}
