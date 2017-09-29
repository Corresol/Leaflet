//
//  MapTestView.swift
//  Leaflets
//
//  Created by Dondrey Taylor on 10/28/16.
//  Copyright © 2016 Leaflets. All rights reserved.
//

import UIKit
import GoogleMaps

class MapTestView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView() {
        let camera = GMSCameraPosition.cameraWithLatitude(-33.868, longitude:151.2086, zoom:6)
        let mapView = GMSMapView.mapWithFrame(bounds, camera:camera)
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        addSubview(mapView)
    }
}
