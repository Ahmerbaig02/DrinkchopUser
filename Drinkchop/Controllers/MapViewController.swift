//
//  MapViewController.swift
//  ParkVit
//
//  Created by Mac on 07/12/2016.
//
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

var ID:String = ""


class MapViewController: UIViewController, GMSMapViewDelegate {
    
    
    @IBOutlet var SearchLocationBtn:UIButton!
    @IBOutlet var gpsBtn: UIButton!
    @IBOutlet var bottomView:UIView!
    
    var MapMovedWithGesture:Bool = false
    var MapView: GMSMapView!
    let locationManager = CLLocationManager()
    
    var Lat:CLLocationDegrees = 0.0
    var Long:CLLocationDegrees = 0.0
    
    let reachability = Reachability()!
    var ActivityIndicator = UIActivityIndicatorView()
    
    let apikey = "AIzaSyAeuNhmQ-S0ooczHpduDYLNvoD5hPPzc5A"
    
    var getData:AlamofireRequestFetch!
    var getGeoCodedData:AlamofireRequestFetch!
    
    var zoomLevel:Float = 14
    var selectedFleetIndex = 0
    var stripeToken:STPToken!

    
    var barMarkers:[GMSMarker] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        SearchLocationBtn.titleLabel?.numberOfLines = 2
        
        getData = AlamofireRequestFetch(baseUrl: DrinkChopBaseURL)
        getGeoCodedData = AlamofireRequestFetch(baseUrl: "https://maps.googleapis.com/maps/api/geocode/json?latlng=")
        
        if (String(Lat) == "0.0") && (String(Long) == "0.0") {
            GPSUpdateLocation()
        }
        else{
            dropPinZoomIn(Latitude: Lat, Longitude: Long)
        }
        
        
        // current location marker tint Color
        
        gpsBtn.getRounded(cornerRaius: 2.0)
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        gpsBtn.getRounded(cornerRaius: gpsBtn.frame.width / 2)
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
        //performLoad()
        dropPinZoomIn(Latitude: Lat, Longitude: Long)
        enableScreenEdgepanGestureDrawer(value: true)
        
        if ID != "" && ID != "Legal"{
            self.performSegue(withIdentifier: ID, sender: nil)
            ID = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self)
        
        enableScreenEdgepanGestureDrawer(value: false)
        
        cancelGeoCodingRequestsToServer()
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
        MapView.delegate = self
    }
    
    func cancelGeoCodingRequestsToServer() {
        if self.getGeoCodedData.getRequest != nil {
            self.getGeoCodedData.getRequest.cancel()
        }
    }
    
    func enableScreenEdgepanGestureDrawer(value:Bool) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.screenEdgePanGestureEnabled = value
        }
    }
    
    func GeoCode( _ Location : CLLocationCoordinate2D){
        
        cancelGeoCodingRequestsToServer()
        
        getGeoCodedData.getDataFromServer(subUrl: "\(Location.latitude),\(Location.longitude)&key=\(apikey)") { [weak self] (response) in
            
            if self != nil && response != nil {
                if let address = response as? [String:AnyObject] {
                    // print(address["results"] )
                    if let result = address["results"] as? NSArray {
                        // print(result)
                        if result.count > 0 {
                            if let address = (result[0] as! [String:AnyObject])["formatted_address"] as? String {
                                let placeName = address.components(separatedBy: ",")
                                self!.SearchLocationBtn.setTitle(placeName.first!, for: .normal)
                            }
                        }
                    }
                }
            } else {
                
            }
        }
    }
    
    
    func changeMapRegion(position: GMSCameraPosition!) {
        
        Lat = position.target.latitude
        Long = position.target.longitude
        // DidFinishUpdatingLocation = false
        GeoCode( CLLocation(latitude: Lat, longitude: Long).coordinate )
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
        SearchLocationBtn.setTitle("Searching Location", for: .normal)
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
    
    func setRegionOnMap(Latitude:CLLocationDegrees,Longitude:CLLocationDegrees){
        
        // RidermapView.clear()
        
        //  DidFinishUpdatingLocation = false
        
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
                self.SearchLocationBtn.setTitle("Searching Location", for: .normal)
                UIView.animate(withDuration: 1.0, animations: {
                    self.GeoCode(CLLocationCoordinate2D(latitude: self.Lat,longitude: self.Long))
                    
                })
                
                
            }  else {
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.SearchLocationBtn.setTitle("Unable to fetch location", for: .normal)
                })
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
        zoomLevel = 16.5
        self.setRegionOnMap(Latitude: Lat, Longitude: Long)
    }
    
    
    func getRouteForLocation() {
        let origin = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsService.LocationCoordinate2D.init(latitude: GoogleMapsService.LocationDegrees(Lat), longitude: GoogleMapsService.LocationDegrees(Long)))
        let dropLat = Lat
        let dropLng = Long
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
    
    func sortAndGetNearestDriverTime() {
        
            let origin = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsService.LocationCoordinate2D.init(latitude: GoogleMapsService.LocationDegrees(Lat), longitude: GoogleMapsService.LocationDegrees(Long)))
            let destination = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsService.LocationCoordinate2D.init(latitude: GoogleMapsService.LocationDegrees(Lat), longitude: GoogleMapsService.LocationDegrees(Long)))
            
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
                UIView.animate(withDuration: 0.55) {
                    let routesData = (response?.routes.first)!
                    if let steps = routesData.legs.first?.steps {
                        
                    }
                }
            }
    }
    
    func getDistanceBtwLocations(pickupLocation: CLLocation, destinationLocation: CLLocation) -> Double {
        var distance = pickupLocation.distance(from: destinationLocation) / 1609.34
        distance = Double(round(100*distance)/100)
        return distance
    }
    
    @IBAction func onLaunchClicked(_ sender: AnyObject) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMapView(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func Menu(_ sender: AnyObject) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    
    // MARK - GPS Location Code
    
    @IBAction func GPSLocation(_ sender: AnyObject) {
        GPSUpdateLocation()
    }
    
    @IBAction func showCartAction(_ sender: Any) {
        
    }
    
    deinit{
        
        MapView.clear()
        MapView.removeFromSuperview()
        MapView.delegate = nil
        MapView = nil
        print("MapView deinit")
    }
    
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress!)
        print("Place coordinates: ", place.coordinate)
        
        Lat = place.coordinate.latitude
        Long = place.coordinate.longitude
        
        SearchLocationBtn.setTitle(place.name, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            Lat = location.coordinate.latitude
            Long = location.coordinate.longitude
            print("location update coordinates:    \(Lat)   \(Long) ")
            GeoCode(location.coordinate)
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
