//
//  TravelLocationsMapViewController.swift
//  VIrtualTourist_RoniR
//
//  Created by Roni Rozenblat on 1/10/20.
//  Copyright © 2020 dinatech. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController,UINavigationControllerDelegate,MKMapViewDelegate {

    @IBOutlet weak var touristMap: MKMapView!
    
    var dataController: DataController!
    var pinLocations = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Generate long-press UIGestureRecognizer.
        let userLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        userLongPress.addTarget(self, action: #selector(detectLongUserPress(_:)))
        
        // Added UIGestureRecognizer to MapView.
        touristMap.addGestureRecognizer(userLongPress)
        


        // Do any additional setup after loading the view.
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        if let result = try? dataController.viewContext.fetch(fetchRequest){
            pinLocations = result
        }
    }
    
    // A method called when long press is detected.
    @objc private func detectLongUserPress(_ sender: UILongPressGestureRecognizer) {
        // Do not generate pins many times during long press.
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        // Get the coordinates of the point you pressed long.
        let location = sender.location(in: touristMap)
        
        // Convert location to CLLocationCoordinate2D.
        let myCoordinate: CLLocationCoordinate2D = touristMap.convert(location, toCoordinateFrom: touristMap)
        
        // Generate pins.
        let myPin: MKPointAnnotation = MKPointAnnotation()
                
        // Set the coordinates.
        myPin.coordinate = myCoordinate
        
        // Added pins to MapView.
        
        touristMap.addAnnotation(myPin)
        
        /* TODO: 06-30-2020
         * 1. Perist the pin in COREDATA
         */
    }
    
    // If a pin is tapped, then go to the PhotoAlbumView
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("DID SELECT PIN")
        let photoAlbumVC = storyboard!.instantiateViewController(withIdentifier: "PhotoAlbumVController")  as! PhotoAlMapViewController
        
        let latStr = String((view.annotation?.coordinate.latitude.description)!)
        let lonStr = String((view.annotation?.coordinate.longitude.description)!)
        

        //photoAlbumVC.self.loadPicsForLatLon(pinLatVal: latStr, pinLonVal: lonStr)
        photoAlbumVC.self.latVal = latStr
        photoAlbumVC.self.lonVal = lonStr
        
        // Set the back button item of photo album view controller to "OK"
        let backItem = UIBarButtonItem()
        backItem.title = "OK"
        navigationItem.backBarButtonItem = backItem
        
        navigationController?.pushViewController(photoAlbumVC, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView?.animatesDrop = true
        }
        
        else
        {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let detailVC = segue.destination as! PhotoAlbumViewController
        detailVC.loadPicsForLatLon(pinLatVal: "40", pinLonVal: "40")
    }*/
    

}
