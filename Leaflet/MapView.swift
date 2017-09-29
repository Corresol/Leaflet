//
//  MapView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/28/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import GoogleMaps

class MapView: UIView {
    
    private var mapCameraZoom:Float = 14
    private var mapCamera:GMSCameraPosition!
    private var mapView:GMSMapView!
    private var mapMarkers:[GMSMarker] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        generateMapView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func generateMapView() {
        mapCamera = GMSCameraPosition.cameraWithLatitude(-33.868, longitude:151.2086, zoom:mapCameraZoom)
        mapView = GMSMapView.mapWithFrame(bounds, camera:mapCamera)
        addSubview(mapView)
    }
    
    func position(coordinate:CLLocationCoordinate2D) {
        mapCamera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: mapCameraZoom)
        mapView.camera = mapCamera
    }
    
    func positionCentered() {
        if mapMarkers.count > 0 {
            var xS:Double = 0
            var yS:Double = 0
            var zS:Double = 0
            
            for (k,_) in mapMarkers.enumerate() {
                xS += (cos(mapMarkers[k].position.latitude * M_PI/180) * cos(mapMarkers[k].position.longitude * M_PI/180))
            }
            
            for (k,_) in mapMarkers.enumerate() {
                yS += (cos(mapMarkers[k].position.latitude * M_PI/180) * sin(mapMarkers[k].position.longitude * M_PI/180))
            }
            
            for (k,_) in mapMarkers.enumerate() {
                zS += (sin(mapMarkers[k].position.latitude * M_PI/180))
            }
            
            
            xS = xS/Double(mapMarkers.count)
            yS = yS/Double(mapMarkers.count)
            zS = zS/Double(mapMarkers.count)
            
            
            let longitude:Double = atan2(yS, xS) * 180/M_PI
            
            let hyp:Double = sqrt((xS * xS) + (yS * yS))
            
            let latitude:Double = atan2(zS, hyp) * 180/M_PI
            
            mapCamera = GMSCameraPosition.cameraWithTarget(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoom: mapCameraZoom)
            mapView.camera = mapCamera
        }
    }
    
    func addMarkers(coordinate:CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.snippet = ""
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.iconView = UIImageView(image: UIImage(named: "map-marker-" + ((mapMarkers.count >= 0 && mapMarkers.count < 10) ? "\(mapMarkers.count+1)" : "additional")) )
        marker.map = mapView
        mapMarkers.append(marker)
    }
    
    func clearMarkers() {
        mapView.clear()
        mapMarkers = []
    }
}





