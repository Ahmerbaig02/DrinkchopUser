////
//  LocationVC.swift
//  Drinkchop
//
//  Created by CodeX on 23/02/2018.
//  Copyright © 2018 Dev_iOS. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import GoogleMapsDirections
import Reachability
import Alamofire
import Stripe

class LocationVC: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet var routeBtn: UIButton!
    @IBOutlet var gpsBtn: UIButton!
    @IBOutlet var bottomView:UIView!
    
    var MapMovedWithGesture:Bool = false
    var MapView: GMSMapView!
    let locationManager = CLLocationManager()
    
    var Lat:CLLocationDegrees = 0.0
    var Long:CLLocationDegrees = 0.0
    
    let reachability = Reachability()!
    var ActivityIndicator = UIActivityIndicatorView()
    
    let apikey = "AIzaSyDvkMCRWfMr5y76ORRW2bFvHa-HJM8gJlg"
    
    var getData:AlamofireRequestFetch!
    var getGeoCodedData:AlamofireRequestFetch!
    
    var zoomLevel:Float = 14
    var selectedFleetIndex = 0
    var stripeToken:STPToken!
    
    var barLat:CLLocationDegrees = 0.0
    var barLng:CLLocationDegrees = 0.0
    
    var barMarkers:[GMSMarker] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        
        getData = AlamofireRequestFetch(baseUrl: DrinkChopBaseURL)
        
        if (String(Lat) == "0.0") && (String(Long) == "0.0") {
            GPSUpdateLocation()
        }
        else{
            dropPinZoomIn(Latitude: Lat, Longitude: Long)
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        gpsBtn.getRounded(cornerRaius: gpsBtn.frame.width / 2)
        routeBtn.getRounded(cornerRaius: routeBtn.frame.width / 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do {
            try reachability.startNotifier()
            
        }catch {
            print("could not start reachability notifier")
        }
        dropPinZoomIn(Latitude: Lat, Longitude: Long)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // func to handle the tap in order to hide the keyboard
    func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            
        }
    }
    
    func setupMap() {
        MapView = MapSingleton(Frame : self.view.frame).GMap
        MapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.bottomView.frame.height + 30, right: 0)
        MapView.setMinZoom(zoomLevel, maxZoom: MapView.maxZoom)
        MapView.accessibilityElementsHidden = false
        MapView.settings.allowScrollGesturesDuringRotateOrZoom = false
        view.addSubview(MapView)
        view.sendSubview(toBack: MapView)
        MapView.isMyLocationEnabled = true
        MapView.settings.compassButton = true
        MapView.delegate = self
    }
    
    func changeMapRegion(position: GMSCameraPosition!) {
        Lat = position.target.latitude
        Long = position.target.longitude
        print("idle camera")
    }
    
    // MARK: - GMSMapView Delegate
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if String(Lat) == String(coordinate.latitude) && String(Long) == String(coordinate.longitude) {
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if MapMovedWithGesture == true {
            changeMapRegion(position: position)
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        MapMovedWithGesture = gesture
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("position changed")
    }
    
    func GPSUpdateLocation() {
        //DidFinishUpdatingLocation = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setRegionOnMap(Latitude:CLLocationDegrees,Longitude:CLLocationDegrees) {
        CATransaction.begin()
        CATransaction.setValue(0.75, forKey: kCATransactionAnimationDuration)
        let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude), zoom: zoomLevel)
        MapView.animate(to: camera)
        CATransaction.commit()
    }
    
    func performAnimationToView() {
        self.performSegue(withIdentifier: ID, sender: nil)
        ID =  ""
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        DispatchQueue.main.async {
            if reachability.isReachable {
                UIApplication.shared.endIgnoringInteractionEvents()
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                
                
            }  else {
                UIApplication.shared.beginIgnoringInteractionEvents()
                print("Network not reachable")
            }
        }
    }
    
    // MARK: - Navigation Fucntions
    
    func showNearestLocation(routesData:GoogleMapsDirections.Response.Route) {
        let path = GMSMutablePath()
        if let steps = routesData.legs.first?.steps {
            for (index,route) in steps.enumerated() {
                let lat = route.startLocation?.latitude
                let long = route.startLocation?.longitude
                path.add(CLLocationCoordinate2D(latitude: lat! , longitude: long!))
            }
            if steps.count > 1 {
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude:(steps.last!.endLocation?.latitude)!, longitude:(steps.last!.endLocation?.longitude)!))
                marker.map = MapView
                path.add(CLLocationCoordinate2D(latitude: (steps.last!.endLocation?.latitude)! , longitude: (steps.last!.endLocation?.longitude)!))
            }
        }
        
        let routeLine = GMSPolyline(path: path)
        routeLine.strokeWidth = 4.0
        routeLine.strokeColor = appTintColor
        routeLine.map = MapView
        zoomLevel = 12.5
        self.setRegionOnMap(Latitude: Lat, Longitude: Long)
    }
    
    
    func getRouteForLocation() {
        let origin = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsService.LocationCoordinate2D.init(latitude: GoogleMapsService.LocationDegrees(Lat), longitude: GoogleMapsService.LocationDegrees(Long)))
        let dropLat = self.barLat
        let dropLng = self.barLng
        let destination = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsService.LocationCoordinate2D.init(latitude: GoogleMapsService.LocationDegrees(dropLat), longitude: GoogleMapsService.LocationDegrees(dropLng)))
        
        GoogleMapsDirections.direction(fromOrigin: origin, toDestination: destination) { [weak self] (response, error) -> Void in
            // Check Status Code
            guard response?.status == GoogleMapsDirections.StatusCode.ok else {
                // Status Code is Not OK
                print((response?.errorMessage))
                return
            }
            
            // Use .result or .geocodedWaypoints to access response details
            // response will have same structure as what Google Maps Directions API returns
            
            //debugPrint("it has \(response?.routes)")
            self!.MapView.clear()
            UIView.animate(withDuration: 0.55) {
                self!.showNearestLocation(routesData: (response?.routes.first!)!)
            }
        }
    }
    
    func showAlert(_title: String, _Message: String) {
        let alert = UIAlertController(title: _title, message: _Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDistanceBtwLocations(pickupLocation: CLLocation, destinationLocation: CLLocation) -> Double {
        var distance = pickupLocation.distance(from: destinationLocation) / 1609.34
        distance = Double(round(100*distance)/100)
        return distance
    }
    
    
    // MARK - GPS Location Code
    
    @IBAction func getRouteAction(_ sender: Any) {
        self.getRouteForLocation()
    }
    
    @IBAction func GPSLocation(_ sender: AnyObject) {
        GPSUpdateLocation()
    }
    
    @IBAction func showCartAction(_ sender: Any) {
        
    }
    
    deinit {
        MapView.clear()
        MapView.removeFromSuperview()
        MapView.delegate = nil
        MapView = nil
        print("MapView deinit")
    }
    
}

extension LocationVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            Lat = location.coordinate.latitude
            Long = location.coordinate.longitude
            print("location update coordinates:    \(Lat)   \(Long) ")
            setRegionOnMap(Latitude: Lat, Longitude: Long)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    func dropPinZoomIn(Latitude: CLLocationDegrees , Longitude:CLLocationDegrees){
        // if internet_Connection == true {
        setRegionOnMap(Latitude: Latitude , Longitude: Longitude)
        print("drop zoom In coordinates:    \(Lat)   \(Long) ")
        //}
        
    }
}
