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
    static let iBeaconUUID = "594650A2-8621-401F-B5DE-6EB3EE398170"
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

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            switch beacon.proximity {
            case .far:
                DDLogInfo("beacon: \(beacon.major), \(beacon.minor)" + " is far (\(beacon.accuracy.string(fractionDigits: 2))m, \(beacon.rssi)dB).")
            case .near:
                DDLogInfo("beacon: \(beacon.major), \(beacon.minor)" + " is near (\(beacon.accuracy.string(fractionDigits: 2))m, \(beacon.rssi)dB).")
            case .immediate:
                DDLogInfo("beacon: \(beacon.major), \(beacon.minor)" + " is immediate (\(beacon.accuracy.string(fractionDigits: 2))m, \(beacon.rssi)dB).")
            default:
                break
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        DDLogError("Failed ranging beacons: \(error.localizedDescription)")
    }
}

extension Double {
    func string(fractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
