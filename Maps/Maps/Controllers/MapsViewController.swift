//
//  MapsViewController.swift
//  Maps
//
//  Created by Luiz Araujo on 29/07/23.
//

import UIKit
import MapKit

class MapsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var adressTextfield: UITextField!
    let locationManager = CLLocationManager()
    var lastLocation: CLLocationCoordinate2D? = nil

    var selectedAddress: Address?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView .delegate = self
        locationManager.requestWhenInUseAuthorization()

        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        switch authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestLocation()
            case .notDetermined: break
            case .restricted:  break
            case .denied:  break
            @unknown default:
                print("Location services are not enabled")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true

        if let selectedAddress {
            showRoute(selectedAddress)
        }
    }

    // MARK: - Actions

    @IBAction func tappedShowAdress(_ sender: Any) {
        getPossibleAddressFromText()
    }

    private func getPossibleAddressFromText() {
        guard let text = adressTextfield.text else { return

        }
        var addresses = [Address]()
        CLGeocoder().geocodeAddressString(text) { (placemarks, error) in
            if error == nil {
                for placemark in placemarks! {
                    if let address = self.convertToAddress(placemark: placemark) {
                        addresses.append(address)
                    }
                }

                self.showAddressesTable(addresses: addresses)
            } else {
//                let controller = UIAlertController(
//                    title: "Error",
//                    message: "Problem trying to fetch addresses from text",
//                    preferredStyle: UIAlertController.Style.alert)
//                self.present(controller, animated: true)
                print("Problem trying to fetch addresses from text")
            }
        }
    }

    private func convertToAddress(placemark: CLPlacemark) -> Address? {
        guard let street = placemark.postalAddress?.street, let postalAddress = placemark.postalAddress else { return nil }
        return Address(name: street, placemark: placemark, postalAddress: postalAddress)
    }

    private func showAddressesTable(addresses: [Address]) {
        let addressesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressesTableViewController") as! AddressesTableViewController
        addressesVC.addresses = addresses
        addressesVC.selectedAddress = { address in
            self.selectedAddress = address
        }
        self.navigationController?.pushViewController(addressesVC, animated: true)
    }

    private func showRoute(_ address: Address) {
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = address.placemark.location!.coordinate
        destinationAnnotation.title = address.name

        self.mapView.addAnnotation(destinationAnnotation)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: lastLocation!))
        request.destination = MKMapItem(placemark: MKPlacemark(placemark: address.placemark))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
}

extension MapsViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location.coordinate
        mapView.centerCoordinate = location.coordinate
        let region = mapView.regionThatFits(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 600, longitudinalMeters: 600))
        mapView.setRegion(region, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ ERROR: \(error.localizedDescription)")
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5.0
        return renderer
    }
}
