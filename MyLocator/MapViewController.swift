//
//  MapViewController.swift
//  MyLocator
//
//  Created by Dmytro Pasinchuk on 21.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext, queue: OperationQueue.main) { notification in
                if self.isViewLoaded {
                    if let dictionary = notification.userInfo{
                        self.updateLocation(from: dictionary)
                    }
                }
            }
        }
    }
    
    var locations = [Location]()
    
    @IBAction func showUser() {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func showLocations() {
        let theRegion = region(for: locations)
        mapView.setRegion(theRegion, animated: true)
        
    }
    
    func updateLocation(from dictionary: [AnyHashable : Any]) {
        if let insertedLocations = dictionary[NSInsertedObjectsKey] as? Set<Location> {
            let insettedLocation = insertedLocations.first!
            locations.append(insettedLocation)
            mapView.addAnnotation(insettedLocation)
            
            let newRegion = region(for: locations)
            mapView.setRegion(newRegion, animated: true)
        }
        if let deletedLocations = dictionary[NSDeletedObjectsKey] as? Set<Location> {
            let deletedLocation = deletedLocations.first!
            let removedIndex = locations.index(of: deletedLocation)!
            locations.remove(at: removedIndex)
            mapView.removeAnnotation(deletedLocation)
            
            let newRegion = region(for: locations)
            mapView.setRegion(newRegion, animated: true)
        }
        if let modifiredLocations = dictionary[NSUpdatedObjectsKey] as? Set<Location> {
            let modifiredLocation = modifiredLocations.first!
            mapView.removeAnnotation(modifiredLocation)
            mapView.addAnnotation(modifiredLocation)
        }
    }
    
    func clearAndUpdateLocations() {
        mapView.removeAnnotations(locations)
        
        let entity = Location.entity()
        let fetchRequest = NSFetchRequest<Location>()
        fetchRequest.entity = entity
        
        locations = try! managedObjectContext.fetch(fetchRequest)
        mapView.addAnnotations(locations)
        
    }
    
    func showLocationDetails(_ sender: UIButton) {
        performSegue(withIdentifier: "EditLocation", sender: sender)
    }
    
    func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
        let region: MKCoordinateRegion
        
        switch annotations.count {
        case 0:
            region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
        default:
            var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            
            for annotation in annotations {
                topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
                topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
                
                bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
                bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude)/2,
                                                longitude: topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude)/2 )
            
            let extraSpace = 1.1
            let span = MKCoordinateSpan(latitudeDelta: abs(topLeftCoord.latitude - bottomRightCoord.latitude)*extraSpace,
                                        longitudeDelta: abs(topLeftCoord.longitude-bottomRightCoord.longitude)*extraSpace)
            
            region = MKCoordinateRegion(center: center, span: span)
        }
        return mapView.regionThatFits(region)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        clearAndUpdateLocations()
        
        if !locations.isEmpty {
            showLocations()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditLocation" {
            let navController = segue.destination as! UINavigationController
            let destination = navController.topViewController as! LocationDetailTableViewController
            destination.managedObgectContext = managedObjectContext
            let button = sender as! UIButton
            let location = locations[button.tag]
            destination.locationToEdit = location
        }
    }
    

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Location else {
            return nil
        }
        
        let identifer = "Location"
        var anotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifer)
        if anotationView == nil {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifer)
            
            pinView.isEnabled = true
            pinView.canShowCallout = true
            pinView.animatesDrop = false
            pinView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(self, action: #selector(showLocationDetails), for: .touchUpInside)
            pinView.rightCalloutAccessoryView = rightButton
            anotationView = pinView
        }
        if let anotationView = anotationView {
            anotationView.annotation = annotation
            
            let button = anotationView.rightCalloutAccessoryView as! UIButton
            if let index = locations.index(of: annotation as! Location) {
                button.tag = index
            }
        }
        return anotationView
    }
    
}

extension MapViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
