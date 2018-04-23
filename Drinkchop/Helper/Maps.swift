//
//  Maps.swift
//  FriendlyLimo
//
//  Created by Mac on 14/01/2017.
//  Copyright © 2017 Ahmer Baig. All rights reserved.
//

import UIKit
import GoogleMaps


// signelton of Gmaps
class MapSingleton {
    
    //MARK: Shared Instance
    
    static let sharedInstance : MapSingleton = {
        let instance = MapSingleton(Frame : CGRect.zero)
        return instance
    }()
    
    //MARK: Local Variable
    
    var GMap : GMSMapView? = nil
    
    //MARK: Init
    
    init (Frame: CGRect) {
        self.GMap = GMSMapView(frame: Frame)
    }
}
