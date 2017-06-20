//
//  LocationDetailTableViewController.swift
//  MyLocator
//
//  Created by Dmytro Pasinchuk on 16.06.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

//Globals are always lazy properties
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

class LocationDetailTableViewController: UITableViewController {
    //MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - Properties
    var coorditate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "No Category"
    var date = Date()
    
    
    //called when perform prepare(for segue), after viewDidLoad, so didSet perform action
    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                descriptionText = location.locationDescription
                categoryName = location.category
                date = location.date
                coorditate = CLLocationCoordinate2DMake(location.latitude, location.longtitude)
                placemark = location.placemark
            }
        }
    }
    var descriptionText = ""
    
    var managedObgectContext: NSManagedObjectContext!
    
    //MARK: - Actions
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        let hud = HudView.hud(inView: navigationController!.view, animated: true)
        let location: Location
        if let temp = locationToEdit {
            hud.text = "Updated"
            location = temp
        } else {
            hud.text = "Tagged"
            location = Location(context: managedObgectContext)
        }
        
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coorditate.latitude
        location.longtitude = coorditate.longitude
        location.date = date
        location.placemark = placemark
        
        do {
            try managedObgectContext.save()
            
            afterDelay(0.6) {
                self.dismiss(animated: true, completion: nil)
            }
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    //MARK: - Methods
    func string(from placemark: CLPlacemark) -> String {
        var text = ""
        if let s = placemark.subThoroughfare {
            text += s + " "
        }
        if let s = placemark.thoroughfare {
            text += s + ", "
        }
        
        if let s = placemark.locality {
            text += s + ", "
        }
        if let s = placemark.administrativeArea {
            text += s + ", "
        }
        if let s = placemark.postalCode {
            text += s + ", "
        }
        if let s = placemark.country {
            text += s
        }
        return text
    }
    func format(date: Date) -> String {
        return dateFormatter.string(from:date)
    }
    func hideKeyboard(_ gestueRecogniser: UIGestureRecognizer) {
        let point = gestueRecogniser.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
            return
        }
        descriptionTextView.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let location = locationToEdit {
            title = "Edit Location"
        }
        
        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        
        latitudeLabel.text = String(format: "%.8f", coorditate.latitude)
        longtitudeLabel.text = String(format: "%.8f", coorditate.longitude)
        
        if let placemark = placemark {
            adressLabel.text = string(from: placemark)
        } else {
            adressLabel.text = "No Adress Found"
        }
        dateLabel.text = format(date: date)
        
        let gestueRecogniser = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //If gestueRecogniser exist in TableView with "true" at this property, tableView will not recognise self tap on cell
        gestueRecogniser.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestueRecogniser)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 88
        } else if indexPath.section == 2 && indexPath.row == 2 {
            adressLabel.frame.size = CGSize(width: view.bounds.size.width - 115,
                                            height: 10000)
            adressLabel.sizeToFit()
            adressLabel.frame.origin.x = view.bounds.size.width - adressLabel.frame.size.width - 15
            return adressLabel.frame.size.height + 20
            
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PickCategory" {
            let destination = segue.destination as! CategoryPickerTableViewController
            destination.selectedCategoryName = categoryName
        }
    }
    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        let source = segue.source as! CategoryPickerTableViewController
        categoryName = source.selectedCategoryName
        categoryLabel.text = categoryName
        
    }
    

}
