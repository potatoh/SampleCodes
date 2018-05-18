//
//  MapViewController.swift
//  Crush
//
//  Created by Sherif Ahmed on 3/20/18.
//  Copyright © 2018 DREIDEV. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import SwiftyJSON
class MapViewController: UIViewController {
    
    @objc var bottlesArray : NSArray = []
    var bottles: [Bottle] = []
    @IBOutlet weak var mapOutlet: MKMapView!
    @objc let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiveBottles()
        mapOutlet.delegate = self
    }
    
    func receiveBottles(){
        Api.getReceivedBottles().subscribe(
            onNext: { (_, json) in
            
                print("getReceivedBottles")
                print(json)
                self.bottlesArray =  json
                self.bottles = JSON(self.bottlesArray).arrayValue.map{
                    Bottle(json: $0)
                }
                
                self.updateMap()
                
        },
            onError: { error in
                print("Error loading getting received bottles: ",error)
                
        },
            onCompleted: {
                print("Completed getting received bottles")
        } )
    }
    
    func updateMap() {
        
        //Centering the map
        
        let centerLocation = CLLocation(latitude: 30.0080293, longitude: 31.4351897)
        self.centerMapOnLocation(location: centerLocation)
        
        //Adding pins
        for bottle in self.bottles {
            
            print(bottle.latitude)
            print(bottle.longitude)
            let artwork = Artwork(title: "Message",
                                  locationName: "BottleLocation",
                                  discipline: "Message Details",
                                  
                                  coordinate: CLLocationCoordinate2D(latitude: bottle.latitude, longitude: bottle.longitude))
            mapOutlet.addAnnotation(artwork)
            
        }
        self.mapOutlet.showAnnotations(self.mapOutlet.annotations, animated: true)
        
    }
    
    @objc func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapOutlet.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func exit(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
}
extension UIViewController: MKMapViewDelegate {
    // 1
    @available(iOS 11.0, *)
    @available(iOS 10.0, *)
    private func mapView(_ mapOutlet: MKMapView!,
                         viewFor annotation: MKAnnotation!)
        -> MKAnnotationView! {
            // 2
            guard let annotation = annotation as? Artwork else { return nil }
            // 3
            let identifier = "marker"
            var view: MKMarkerAnnotationView
            // 4
            if let dequeuedView = mapOutlet.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 5
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
    }
}


