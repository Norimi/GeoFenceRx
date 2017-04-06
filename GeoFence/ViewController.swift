//
//  ViewController.swift
//  GeoFence
//
//  Created by netNORIMINGCONCEPTION on 2017/03/31.
//  Copyright © 2017年 flatLevel56. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    let manager = CLLocationManager()
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var geoLabel: UILabel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupLocationManager()
        regionMonitoring()
        getLocation()
        initializeRxDelegateMethods()
        fireNotification()
        
    }
    
    func initializeRxDelegateMethods() {

        manager.rx.rx_didUpdateLocations.subscribe({ locations in
            let location = locations.element?[0]
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location!, completionHandler: {(data, error)
                in
                let placeMarks = data! as [CLPlacemark]
                let loc: CLPlacemark = placeMarks[0]
                self.mapView.centerCoordinate = (location?.coordinate)!
                let addr = loc.locality
                self.geoLabel.text = addr! + "にいます"
                let reg = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, 1500, 1500)
                self.mapView.setRegion(reg, animated:true)
                self.mapView.showsUserLocation = true
               

            })
            print("location updated")})
            .addDisposableTo(disposeBag)
        
        manager.rx.rx_didFailWithError.subscribe({error in
            print("error in rx delegate method")}).addDisposableTo(disposeBag)
        
        manager.rx.rx_didEnterRegion.subscribe({_ in
            print("did enter region")
        
        }).addDisposableTo(disposeBag)
        
        manager.rx.rx_didExitRegion.subscribe({_ in
            print("did exit region")
        
        }).addDisposableTo(disposeBag)
    }
    

    func setupLocationManager(){
        //delegateの設定はプロキシで行う
        //manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func regionMonitoring(){
        manager.requestAlwaysAuthorization()
        let location = CLLocationCoordinate2DMake(35.704213, 139.756536)
        let currRegion = CLCircularRegion(center: location, radius: 500, identifier: "lab")
        manager.startMonitoring(for: currRegion)
        
        //notificationにregionを登録
        let notification = UILocalNotification()
        notification.regionTriggersOnce = false
        notification.region = currRegion
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func getLocation(){
        _ = CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self)
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func fireNotification(){
//        let notf = UILocalNotification()
//        notf.fireDate = NSDate(timeIntervalSinceNow: 5) as Date
//        notf.timeZone = NSTimeZone.default
//        notf.alertTitle = "5秒経過"
//        UIApplication.shared.scheduleLocalNotification(notf)
        
        
//        let notification = UILocalNotification()
//        let count = TimeInterval(5.0)
//        notification.fireDate = NSDate(timeIntervalSinceNow: count) as Date
        
        //let date = Date(timeIntervalSinceNow:2*60)
        
        
        
        // notification.fireDate = date
        
//        notification.alertTitle = "Reminder"
//        
//        notification.alertBody = "Car Wash : Take Car to garage"
//        
//        notification.repeatInterval = NSCalendar.Unit.hour
//        
//        UIApplication.shared.scheduleLocalNotification(notification)
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle" // 新登場！
        content.body = "Body"
        content.sound = UNNotificationSound.default()
        
        // 5秒後に発火
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "FiveSecond",
                                            content: content,
                                            trigger: trigger)
        
        // ローカル通知予約
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        
        let identifier = notification.request.identifier
        switch identifier {
        case "alert":
            completionHandler([.alert]) //通知だけ
        case "both":
            completionHandler([.sound, .alert]) //サウンドと通知
        default:
            () // 何もしない
        }
        //...
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

