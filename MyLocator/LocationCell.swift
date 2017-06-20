//
//  LocationCell.swift
//  MyLocator
//
//  Created by Dmytro Pasinchuk on 20.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    
    func configure(for location: Location) {
        
        if location.locationDescription.isEmpty {
            descriptionLabel.text = "No Description"
        } else {
        descriptionLabel.text = location.locationDescription
        }
        if let placemark = location.placemark {
            var text = ""
            if let s = placemark.subThoroughfare{
                text += s + " "
            }
            if let s = placemark.thoroughfare {
                text += s + " "
            }
            if let s = placemark.locality {
                text += s
            }
            adressLabel.text = text
        } else {
            adressLabel.text = String(format: "Lat: %0.8f, Long: %0.8f", location.latitude, location.longtitude)
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
