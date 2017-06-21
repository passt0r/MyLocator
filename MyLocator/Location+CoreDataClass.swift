//
//  Location+CoreDataClass.swift
//  MyLocator
//
//  Created by Dmytro Pasinchuk on 19.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(Location)
public class Location: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longtitude)
    }
    
    public var title: String? {
        if locationDescription.isEmpty {
            return "(No Descryption)"
        } else {
            return locationDescription
        }
    }
    
    public var subtitle: String? {
        return category
    }
}
