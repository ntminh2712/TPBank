//
//  MapkitViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/14/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapkitViewController: UIViewController, CLLocationManagerDelegate,UISearchBarDelegate{
    @IBOutlet weak var Mapkit: MKMapView!
    let manage = CLLocationManager()
    
    @IBAction func btnSearch(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    func activityStart(){
        activity.center = self.view.center
        activity.hidesWhenStopped = true
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activity)
        activity.startAnimating()
    }
    func activityStop(){
        activity.stopAnimating()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.Mapkit.showsUserLocation = false
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityStart()
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, err) in
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityStop()
            if response == nil {
                print(err)
                print("không load đc ")
            }else{
                let annotations = self.Mapkit.annotations
                self.Mapkit.removeAnnotations(annotations)
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                let regionDistance:CLLocationDistance = 1000;
                let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let span = MKCoordinateRegionMakeWithDistance(myLocation, regionDistance, regionDistance)
                let option = [MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate:span.center),MKLaunchOptionsMapSpanKey:NSValue(mkCoordinateSpan: span.span)]
                let placeMark = MKPlacemark(coordinate: myLocation)
                let mapitem = MKMapItem(placemark: placeMark)
                mapitem.name = searchBar.text
                mapitem.openInMaps(launchOptions: option)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        Mapkit.setRegion(region, animated: true)
        self.Mapkit.showsUserLocation = true
    }

    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScreenHomeCustomer")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        manage.delegate = self
        manage.desiredAccuracy = kCLLocationAccuracyBest
        manage.requestWhenInUseAuthorization()
        manage.startUpdatingLocation()
        setupMap()
    }
    func setupMap() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityStart()
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = "TPBank"
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, err) in
        UIApplication.shared.endIgnoringInteractionEvents()
        self.activityStop()
        if response == nil {
        print(err)
        print("không load đc ")
        }else{
        let annotations = self.Mapkit.annotations
        self.Mapkit.removeAnnotations(annotations)
        let latitude = response?.boundingRegion.center.latitude
        let longitude = response?.boundingRegion.center.longitude
        let regionDistance:CLLocationDistance = 1000;
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let span = MKCoordinateRegionMakeWithDistance(myLocation, regionDistance, regionDistance)
        let option = [MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate:span.center),MKLaunchOptionsMapSpanKey:NSValue(mkCoordinateSpan: span.span)]
        let placeMark = MKPlacemark(coordinate: myLocation)
        let mapitem = MKMapItem(placemark: placeMark)
        mapitem.name = "TPBank"
        mapitem.openInMaps(launchOptions: option)
        }
    }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
