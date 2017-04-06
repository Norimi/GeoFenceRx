//
//  RxCLLocationManagerDelegateProxy.swift
//  GeoFence
//
//  Created by netNORIMINGCONCEPTION on 2017/03/31.
//  Copyright © 2017年 flatLevel56. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class RxCLLocationManagerDelegateProxy: DelegateProxy, CLLocationManagerDelegate, DelegateProxyType {
    
    //DelegateProxyType採用のために以下の2つのメソッドが必要
    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let locationManager: CLLocationManager = object as! CLLocationManager
        return locationManager.delegate
    }
    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let locationManager: CLLocationManager = object as! CLLocationManager
        locationManager.delegate = delegate as? CLLocationManagerDelegate
    }
}

//Reactive拡張してObservableにデリゲートメソッドを登録する
extension Reactive where Base: CLLocationManager {
    public var delegate: DelegateProxy {
        return RxCLLocationManagerDelegateProxy.proxyForObject(base)
    }

    var rx_didUpdateLocations: Observable<[CLLocation]>{
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { a in
                return try castOrThrow([CLLocation].self, a[1])
        }
    }
    
    var rx_didFailWithError: Observable<NSError> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFailWithError:)))
            .map { a in
                return try castOrThrow(NSError.self, a[1])
        }
    }
    
    var rx_didChangeAuthorizationStatus: Observable<CLAuthorizationStatus>{
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
            .map { a in
                return try castOrThrow(CLAuthorizationStatus.self, a[1])
        }
    }
    
    var rx_didEnterRegion: Observable<[Any]>{
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didEnterRegion:)))
    }
    
    var rx_didExitRegion: Observable<[Any]>{
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didExitRegion:)))
    }
}

    
fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        
        return returnValue
}
