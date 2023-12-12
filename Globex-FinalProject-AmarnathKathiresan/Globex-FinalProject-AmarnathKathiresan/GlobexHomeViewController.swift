//
//  GlobexHomeViewController.swift
//  Globex-FinalProject-AmarnathKathiresan
//
//  Created by Amarnath  Kathiresan on 2023-12-10.
//

import UIKit
import CoreLocation
import MapKit

class GlobexHomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var buttonPressMe: UIButton!
    @IBOutlet weak var buttonNews: UIButton!
    @IBOutlet weak var buttonMap: UIButton!
    @IBOutlet weak var buttonWeather: UIButton!
    @IBOutlet weak var mapViewUserLocation: MKMapView!
    
    // Create a CLLocationManager and assign a delegate
    let locationManager = CLLocationManager()
    var latitude = 0.0
    var longitude = 0.0
    var locationName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // That's it for the initial setup. Everything else is handled in the
        // locationManagerDidChangeAuthorization method.
        locationManagerDidChangeAuthorization(locationManager)
    }
    
    @IBAction func buttonNews(_ sender: UIButton) {
        print("Button clicked")
    
        if let locationName = locationName, !locationName.isEmpty {
            // locationName is non-nil and non-empty, perform the segue
            //performSegue(withIdentifier: "ShowNewsTabPage", sender: locationName)
            self.navigateToNews(index:0,locationName: locationName)
        } else {
            // locationName is nil or empty, handle accordingly
            // You might want to show an error message or take appropriate action
            print("Location name is nil or empty.")
            showLocationAlert(UIButton())
        }
    }
    
    @IBAction func buttonMap(_ sender: UIButton) {
        print("Button clicked")
        if let locationName = locationName, !locationName.isEmpty {
            // locationName is non-nil and non-empty, perform the segue
            // performSegue(withIdentifier: "ShowMapTabPage", sender: locationName)
            self.navigateToNews(index:0,locationName: locationName)
        } else {
            // locationName is nil or empty, handle accordingly
            // You might want to show an error message or take appropriate action
            print("Location name is nil or empty.")
            showLocationAlert(UIButton())
        }
    }
    
    @IBAction func buttonWeather(_ sender: UIButton) {
        print("Button clicked")
        performSegue(withIdentifier: "ShowWeatherTabPage", sender: nil)
        if let locationName = locationName, !locationName.isEmpty {
            // locationName is non-nil and non-empty, perform the segue
            //performSegue(withIdentifier: "ShowWeatherTabPage", sender: locationName)
            self.navigateToNews(index:0,locationName: locationName)
        } else {
            // locationName is nil or empty, handle accordingly
            // You might want to show an error message or take appropriate action
            print("Location name is nil or empty.")
            showLocationAlert(UIButton())
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if let locationName = sender as? String {
        if segue.identifier == "ShowNewsTabPage" {
            // Set the selected index of the Tab Bar Controller
            let tabBarControllerObj = segue.destination as? UITabBarController
            tabBarControllerObj?.selectedIndex = 0 // Index 0 is the first tab
            if let tabBarController = segue.destination as? UITabBarController {
                if let newsNavController = tabBarController.viewControllers?[0] as? UINavigationController,
                   let newsViewController = newsNavController.topViewController as? NewsTableTableViewController {
                    
                    if let location = locationName, !location.isEmpty {
                        // Pass location name to the News view controller
                        newsViewController.locationName = location
                        newsViewController.setCityName(location)
                    } else {
                        // Handle case where locationName is nil or empty
                        showLocationAlert(UIButton())
                    }
                }
            }
        } else if segue.identifier == "ShowMapTabPage" {
            let tabBarControllerObj = segue.destination as? UITabBarController
            tabBarControllerObj?.selectedIndex = 1 // Index 0 is the first tab
            if let tabBarController = segue.destination as? UITabBarController {
                if let mapNavController = tabBarController.viewControllers?[1] as? UINavigationController,
                   let mapViewController = mapNavController.topViewController as? DirectionViewController {
                    if let location = locationName, !location.isEmpty {
                        // Pass location name to the Map view controller
                        mapViewController.locationName = locationName
                        mapViewController.setCityName(locationName!)
                    } else {
                        // Handle case where locationName is nil or empty
                        showLocationAlert(UIButton())
                    }
                    
                }
            }
        } else if segue.identifier == "ShowWeatherTabPage" {
            let tabBarControllerObj = segue.destination as? UITabBarController
            tabBarControllerObj?.selectedIndex = 2 // Index 0 is the first tab
            if let tabBarController = segue.destination as? UITabBarController {
                if let weatherNavController = tabBarController.viewControllers?[2] as? UINavigationController,
                   let weatherViewController = weatherNavController.topViewController as? WeatherViewController {
                    if let location = locationName, !location.isEmpty {
                        // Pass location name to the Weather view controller
                        weatherViewController.locationName = locationName
                        //weatherViewController.setCityName(locationName!)
                    } else {
                        // Handle case where locationName is nil or empty
                        showLocationAlert(UIButton())
                    }
                   
                }
            }
        }
        // }
    }
    
    
    @IBAction func buttonPressMe(_ sender: UIButton) {
        showLocationAlert(UIButton())
    }
    
    //    @IBAction func showLocationAlert(_ sender: UIButton) {
    //            let alert = UIAlertController(title: "Where would you like to go?", message: "Enter your Location", preferredStyle: .alert)
    //
    //            // Add a text field to the alert
    //            alert.addTextField { textField in
    //                textField.placeholder = "Enter your location"
    //            }
    //
    //            // Add action buttons
    //            alert.addAction(UIAlertAction(title: "News", style: .default) { _ in
    //                // Handle News button click
    //                if let location = alert.textFields?.first?.text {
    //                    self.navigateToNews(location: location)
    //                }
    //            })
    //
    //            alert.addAction(UIAlertAction(title: "Map", style: .default) { _ in
    //                // Handle Map button click
    //                if let location = alert.textFields?.first?.text {
    //                    self.navigateToMap(location: location)
    //                }
    //            })
    //
    //            alert.addAction(UIAlertAction(title: "Weather", style: .default) { _ in
    //                // Handle Weather button click
    //                if let location = alert.textFields?.first?.text {
    //                    self.navigateToWeather(location: location)
    //                }
    //            })
    //
    //            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    //
    //            present(alert, animated: true, completion: nil)
    //        }
    
    @IBAction func showLocationAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: "Where would you like to go?", message: "Enter your Location", preferredStyle: .alert)
        
        // Add a text field to the alert
        alert.addTextField { textField in
            textField.placeholder = "Enter your location"
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        // Create action buttons
        let newsAction = UIAlertAction(title: "News", style: .default) { _ in
            if let location = alert.textFields?.first?.text {
                self.locationName = location
                self.navigateToNews(index:0,locationName: location)
            }
        }
        
        let mapAction = UIAlertAction(title: "Map", style: .default) { _ in
            if let location = alert.textFields?.first?.text {
                self.locationName = location
                self.navigateToMap(index:1,locationName: location)
            }
        }
        
        let weatherAction = UIAlertAction(title: "Weather", style: .default) { _ in
            if let location = alert.textFields?.first?.text {
                self.locationName = location
                self.navigateToWeather(index:2,locationName: location)
            }
        }
        
        // Add action buttons to the alert
        alert.addAction(newsAction)
        alert.addAction(mapAction)
        alert.addAction(weatherAction)
        
        // Add an action to make the "OK" button initially disabled
        newsAction.isEnabled = false
        mapAction.isEnabled = false
        weatherAction.isEnabled = false
        
        // Store the action buttons for later validation
        self.newsAction = newsAction
        self.mapAction = mapAction
        self.weatherAction = weatherAction
        
        // Set isModalInPresentation to true to prevent dismissal by tapping outside the alert
        alert.isModalInPresentation = false
        
        present(alert, animated: true, completion: nil)
    }
    
    // Add these properties to your class
    var newsAction: UIAlertAction?
    var mapAction: UIAlertAction?
    var weatherAction: UIAlertAction?
    
    // This function is called when the text field changes
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Enable or disable the action buttons based on the text field content
        let isTextFieldEmpty = textField.text?.isEmpty ?? true
        newsAction?.isEnabled = !isTextFieldEmpty
        mapAction?.isEnabled = !isTextFieldEmpty
        weatherAction?.isEnabled = !isTextFieldEmpty
    }
    
    
    
    func showToast(message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func navigateToNews(index: Int, locationName: String) {
        // Implement navigation to News with the provided location
        print("Navigate to News with location: \(locationName)")
        performSegue(withIdentifier: "ShowNewsTabPage", sender: locationName)
    }
    
    func navigateToMap(index: Int, locationName: String) {
        // Implement navigation to Map with the provided location
        print("Navigate to Map with location: \(locationName)")
        performSegue(withIdentifier: "ShowMapTabPage", sender: locationName)
    }
    
    func navigateToWeather(index: Int, locationName: String) {
        // Implement navigation to Weather with the provided location
        print("Navigate to Weather with location: \(locationName)")
        performSegue(withIdentifier: "ShowWeatherTabPage", sender: locationName)
    }
    
    
    
    /* locationManagerDidChangeAuthorization function - This is called as soon as the location manager is setup (in viewDidLoad)*/
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            // Request the appropriate authorization based on the needs of the app
            manager.requestWhenInUseAuthorization()
            // manager.requestAlwaysAuthorization()
        case .restricted:
            print("Sorry, restricted")
            // Optional: Offer to take user to app's settings screen
            //openSettingsPage()
        case .denied:
            print("Sorry, denied")
            // Optional: Offer to take user to app's settings screen
            //openSettingsPage()
        case .authorizedAlways, .authorizedWhenInUse:
            // The app has permission so start getting location updates
            print("Permission provided")
            // Request a user’s location once
            locationManager.requestLocation()
        @unknown default:
            print("Unknown status")
        }
    }
    
    
    /* openSettingsPage Function */
    func openSettingsPage(){
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    /* LocationManager didUpdateLocation function for reading current location */
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            // Handle location update
            setUserLocationPin()
        }
    }
    
    /* LocationManager didFailWithError function for handling location error */
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
    
    func setUserLocationPin(){
        let receivedLatitude: CLLocationDegrees = latitude
        let receivedLongitude: CLLocationDegrees = longitude
        
        let locationCoordinate = CLLocationCoordinate2D(latitude: receivedLatitude, longitude: receivedLongitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "You are here."
        
        mapViewUserLocation.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapViewUserLocation.setRegion(region, animated: true)
    }
}


