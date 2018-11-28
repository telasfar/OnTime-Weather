//
//  LocationCell.swift
//  OnTime Weather App
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblLocationName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       backView.layer.cornerRadius = 5
        lblLocationName.layer.cornerRadius = 3
    }




}
