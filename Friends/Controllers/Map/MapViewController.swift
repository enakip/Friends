//
//  MapViewController.swift
//  Friends
//
//  Created by Emiray Nakip on 5.11.2021.
//

import UIKit
import MapKit

class MapViewController: DismissableViewController {
    
    // MARK: - Varibles
    private lazy var dragHandle: UIView = {
        let view = UIView()
        view.backgroundColor = .myAqua
        view.setCornerRound(value: 3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var mapView : MKMapView = {
        let map = MKMapView()
        map.setCornerRound(value: 30)
        map.clipsToBounds = true
        map.layer.masksToBounds = false
        map.layer.shadowColor =  UIColor(white: 0.25, alpha: 0.85).cgColor
        map.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        map.layer.shadowRadius = 12.0
        map.layer.shadowOpacity = 1.0
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private var viewmodel: ListViewModel? = nil
    
    // MARK: - Life Cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        
    }
    
    override var pannableView: UIView {
        mapView
    }
    
    private func setUI() {
        view.addSubview(mapView)
        mapView.addSubview(dragHandle)
        NSLayoutConstraint.activate([
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.heightAnchor.constraint(equalToConstant: 400),
            dragHandle.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 0.0),
            dragHandle.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            dragHandle.heightAnchor.constraint(equalToConstant: 10.0),
            dragHandle.widthAnchor.constraint(equalToConstant: 50.0)
        ])
        
        self.setAnnotation()
    }
    
    private func setAnnotation() {
        guard let vm = viewmodel else { return }
        
        let annotation = MKPointAnnotation()
        annotation.title = vm.fName+" "+vm.lName+"\n"+vm.address
        
        let lat : CLLocationDegrees = CLLocationDegrees.init(vm.lat) ?? CLLocationDegrees("0")!
        let long : CLLocationDegrees = CLLocationDegrees.init(vm.lon) ?? CLLocationDegrees("0")!
        let newCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.coordinate = newCoordinate
        mapView.addAnnotation(annotation)
       
        let span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta / 2,
                                    longitudeDelta: mapView.region.span.latitudeDelta / 2)
        let region = MKCoordinateRegion(center: newCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK: - Public Functions
    public func showController(parentVc: UIViewController, viewmodel:ListViewModel) {
        self.viewmodel = viewmodel
        self.definesPresentationContext = true
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        parentVc.navigationController?.present(self, animated: true)    }
    
    public func dismissController(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: completion)
        }
    }
    
}
