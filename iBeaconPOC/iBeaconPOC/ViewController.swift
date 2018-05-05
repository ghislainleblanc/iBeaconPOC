//
//  ViewController.swift
//  iBeaconPOC
//
//  Created by Ghislain Leblanc on 2018-05-05.
//  Copyright © 2018 Leblanc, Ghislain. All rights reserved.
//

import UIKit
import CoreLocation
import CocoaLumberjack

struct Constants {
    static let iBeaconUUID = "E33A1F47-547C-45AC-923D-F6821E6E7D3E"
    static let iBeaconMajorValue: UInt16 = 0x0000
    static let iBeaconMinorValue: UInt16 = 0x0000
    static let iBeaconIdentifier = "iBeacon"

    static let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: iBeaconUUID)!,
    major: iBeaconMajorValue,
    minor: iBeaconMinorValue,
    identifier: iBeaconIdentifier)
}

class ViewController: UIViewController {
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startMonitoringBeacon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func startMonitoringBeacon() {
        DDLogVerbose(#function)

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        locationManager.startMonitoring(for: Constants.beaconRegion)
        locationManager.startRangingBeacons(in: Constants.beaconRegion)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        DDLogInfo("Exited region: " + region.description)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        DDLogInfo("Entered region: " + region.description)
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        DDLogError("Failed monitoring region: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DDLogError("Location manager failed: \(error.localizedDescription)")
    }
}
