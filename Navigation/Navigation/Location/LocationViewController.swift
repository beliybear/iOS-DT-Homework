//
//  LocationViewController.swift
//  Navigation
//
//  Created by Beliy.Bear on 08.06.2023.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    private lazy var hybridStyleButton: UIButton = {
        let hybridStyleButton = UIButton()
        hybridStyleButton.setTitle(NSLocalizedString("Hybrid", comment: ""), for: .normal)
        hybridStyleButton.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        hybridStyleButton.layer.cornerRadius = 10
        hybridStyleButton.setTitleColor(UIColor.createColor(lightMode: .black, darkMode: .white), for: .normal)
        hybridStyleButton.addTarget(self, action: #selector(hybridStyleButtonPressed), for: .touchUpInside)
        return hybridStyleButton
    }()
    
    private lazy var satelliteStyleButton: UIButton = {
        let satelliteStyleButton = UIButton()
        satelliteStyleButton.setTitle(NSLocalizedString("Satellite", comment: ""), for: .normal)
        satelliteStyleButton.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        satelliteStyleButton.layer.cornerRadius = 10
        satelliteStyleButton.setTitleColor(UIColor.createColor(lightMode: .black, darkMode: .white), for: .normal)
        satelliteStyleButton.addTarget(self, action: #selector(satelliteStyleButtonPressed), for: .touchUpInside)
        return satelliteStyleButton
    }()
    
    private lazy var standardStyleButton: UIButton = {
        let standardStyleButton = UIButton()
        standardStyleButton.setTitle(NSLocalizedString("Standard", comment: ""), for: .normal)
        standardStyleButton.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        standardStyleButton.layer.cornerRadius = 10
        standardStyleButton.setTitleColor(UIColor.createColor(lightMode: .black, darkMode: .white), for: .normal)
        standardStyleButton.addTarget(self, action: #selector(standardStyleButtonPressed), for: .touchUpInside)
        return standardStyleButton
    }()
    
    private lazy var removeAnnotationsButton: UIButton = {
        let removeAnnotationsButton = UIButton()
        removeAnnotationsButton.setTitle(NSLocalizedString("Remove all annotations", comment: ""), for: .normal)
        removeAnnotationsButton.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        removeAnnotationsButton.layer.cornerRadius = 10
        removeAnnotationsButton.setTitleColor(UIColor.createColor(lightMode: .black, darkMode: .white), for: .normal)
        removeAnnotationsButton.addTarget(self, action: #selector(removeAnnotationsButtonPressed), for: .touchUpInside)
        return removeAnnotationsButton
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        
        let pointOfInterestFilter = MKPointOfInterestFilter()
        mapView.pointOfInterestFilter = pointOfInterestFilter
        // Moscow
        let initialLocation = CLLocationCoordinate2D(
            latitude: 55.75222,
            longitude: 37.61556
        )
        mapView.setCenter(
            initialLocation,
            animated: false
        )
        let region = MKCoordinateRegion(
            center: initialLocation,
            latitudinalMeters: 1_000_000,
            longitudinalMeters: 1_000_000
        )
        mapView.setRegion(
            region,
            animated: false
        )
        mapView.addAnnotations(CapitalAnnotation.make())
        return mapView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        findUserLocation()
        mapView.delegate = self
        let lpgr = UILongPressGestureRecognizer(target: self,
                                                action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
    }
    
    private func setupUI(){
        view.addSubview(mapView)
        mapView.addSubview(stackView)
        mapView.addSubview(removeAnnotationsButton)
        stackView.addArrangedSubview(hybridStyleButton)
        stackView.addArrangedSubview(satelliteStyleButton)
        stackView.addArrangedSubview(standardStyleButton)
    }
    
    private func setupConstraints(){
        mapView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        hybridStyleButton.translatesAutoresizingMaskIntoConstraints = false
        satelliteStyleButton.translatesAutoresizingMaskIntoConstraints = false
        standardStyleButton.translatesAutoresizingMaskIntoConstraints = false
        removeAnnotationsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            removeAnnotationsButton.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 16),
            removeAnnotationsButton.centerXAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.centerXAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -6)
        ])
    }
    
    private func findUserLocation(){
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
    
    @objc private func hybridStyleButtonPressed() {
        mapView.mapType = .hybrid
    }
    
    @objc private func satelliteStyleButtonPressed() {
        mapView.mapType = .satellite
    }
    
    @objc private func standardStyleButtonPressed() {
        mapView.mapType = .standard
    }
    
    @objc private func removeAnnotationsButtonPressed() {
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        let overlays = self.mapView.overlays
        self.mapView.removeOverlays(overlays)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            return
        }
        else if gestureRecognizer.state != UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let touchMapCoordinate =  self.mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = CapitalAnnotation(title: "You long pressed here", coordinate: touchMapCoordinate, info: "")
            self.mapView.addAnnotation(annotation)
            if locationManager.location != nil {
                let startLatitude: Double = locationManager.location!.coordinate.latitude
                let startLongitude: Double = locationManager.location!.coordinate.longitude
                let pick1 = CLLocationCoordinate2D.init(latitude: startLatitude, longitude: startLongitude)
                let pick2 = CLLocationCoordinate2D.init(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
                showRouteOnMap(pickupCoordinate: pick1, destinationCoordinate: pick2)
            }
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            print("Определение локации невозможно")
        case .notDetermined:
            print("Определение локации не запрошено")
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            mapView.setCenter(
                location.coordinate,
                animated: true
            )
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ){}
}

extension LocationViewController: MKMapViewDelegate {
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            if let route = unwrappedResponse.routes.first {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 5.0
        return renderer
    }
    
}
