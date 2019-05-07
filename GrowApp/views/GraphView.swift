//
//  GraphView.swift
//  GrowApp
//
// THIS CLASS TAKES CARE OF THE GRAPH VIEW
//
//  Created by Andrei on 13/03/2019.
//  Copyright © 2019 Andrei. All rights reserved.
//

import UIKit
import CoreBluetooth
import Charts

class GraphView: UIViewController {
    
     let flowerPowerCBUUID = CBUUID(string: "39e1FA00-84a8-11e2-afba-0002a5d5c51b") //flowerPower bluetooth identifier
     let flowerPowerAirTempCBUUID = CBUUID(string: "39E1FA04-84A8-11E2-AFBA-0002A5D5C51B")//flower power air temp`
     let flowerPowerSoilVWCBUUID = CBUUID(string: "39E1FA05-84A8-11E2-AFBA-0002A5D5C51B")//flower power soil vwc
     let flowerPowerSoilTempCBUUID = CBUUID(string: "39E1FA04-84A8-11E2-AFBA-0002A5D5C51B")//flower power soil vwc
     let flowerPowerLiveMeasurePeriod = CBUUID(string: "39E1FA06-84A8-11E2-AFBA-0002A5D5C51B")//flower power live measure period
     let flowerPowerLightLevel = CBUUID(string: "39E1FA01-84A8-11E2-AFBA-0002A5D5C51B")//flower power live measure period
    
    var centralManager: CBCentralManager!
    var flowerPowerPeripherial: CBPeripheral!
    
    var airTempBool = true
    var soilVWCBool = true
    
    var generalStopButton = false
    
    let header = GAHeader(frame: .zero, title: "Graph view", color: .blue, radius: 12)
    let headerLabel = GALabel(title: "Real time graph view scene: ", frame: .zero, color: .white, size: 25, textAlignment: .center)
    var lineChartView = LineChartView()
    var lineChartView2 = LineChartView()
    private let connectButton = GAButton(frame: .zero, title: "Display Graphs", textColor: .white, backgroundColor: .blue, radius: 12)
    private let startStopButton = GAButton(frame: .zero, title: "Stop/Start", textColor: .white, backgroundColor: .blue, radius: 12)
    private let backButton = GAButton(frame: .zero, title: "Go Back", textColor: .white, backgroundColor: .blue, radius: 12)
    var i = 0.0
    var entriesForAirTemp:[ChartDataEntry] = Array()
    var entriesForSoilVWC:[ChartDataEntry] = Array()
    
    @objc func connectButtonFunctionality() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.connectButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.connectButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (_) in
                self.centralManager = CBCentralManager(delegate: self, queue: nil)
            }
        }
    }
    
    @objc func startStopButtonFunctionality() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.startStopButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.startStopButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (_) in
                self.generalStopButton = !self.generalStopButton
            }
        }
    }
    
    @objc func backButtonFunctionality() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.backButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.backButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (_) in
                self.present(BluetoothView(), animated: true, completion: nil)
            }
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView2.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(header)
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        header.heightAnchor.constraint(equalToConstant: 120).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(lineChartView)
        lineChartView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 25).isActive = true
        lineChartView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        lineChartView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        lineChartView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(lineChartView2)
        lineChartView2.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 25).isActive = true
        lineChartView2.heightAnchor.constraint(equalToConstant: 200).isActive = true
        lineChartView2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        lineChartView2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        header.addSubview(headerLabel)
        headerLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        
        self.view.addSubview(connectButton)
        connectButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        connectButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        connectButton.addTarget(self, action: #selector(connectButtonFunctionality), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        backButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: connectButton.bottomAnchor, constant: 40).isActive = true
        backButton.addTarget(self, action: #selector(backButtonFunctionality), for: .touchUpInside)
        
        self.view.addSubview(startStopButton)
        startStopButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        startStopButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startStopButton.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -60).isActive = true
        startStopButton.addTarget(self, action: #selector(startStopButtonFunctionality), for: .touchUpInside)
        
    }
    
    func setupPieChart1() {
        let set1 = LineChartDataSet(entries: entriesForAirTemp, label: "Live Air Temp")
        set1.setCircleColor(.red)
        set1.setColor(.black)
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
    
    func setupPieChart2() {
        let set1 = LineChartDataSet(entries: entriesForSoilVWC, label: "Live Soil VWC")
        set1.setCircleColor(.red)
        set1.setColor(.red)
        let data = LineChartData(dataSet: set1)
        lineChartView2.data = data
    }
}

extension GraphView: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [flowerPowerCBUUID])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        flowerPowerPeripherial = peripheral
        flowerPowerPeripherial.delegate = self
        centralManager.cancelPeripheralConnection(peripheral)
        centralManager.stopScan()
        centralManager.connect(flowerPowerPeripherial)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        flowerPowerPeripherial.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            switch(characteristic.uuid) {
            case flowerPowerSoilTempCBUUID:
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
                break
            case flowerPowerLiveMeasurePeriod:
                writeRxValue(from: characteristic, peripherial: peripheral, number: 0x01)
                break
            case flowerPowerLightLevel:
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
                break
            default:
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error turning on notification property for services: \(String(describing: error))")
            return
        }
        print("The notification property has been turned on for:  \(characteristic)")
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if characteristic.uuid == flowerPowerSoilTempCBUUID {
            let characteristicData = characteristic.value
            let byteArray:[UInt8] = [UInt8](characteristicData!)
            let u16 = UnsafePointer(byteArray).withMemoryRebound(to: UInt16.self, capacity: 2) {
                $0.pointee
            }
            if(generalStopButton == false){
                if(airTempBool == true) {
                self.entriesForAirTemp.append(ChartDataEntry(x: self.i, y: Double(((Double(u16) * 3.3)/Double(((2^11)-1))) - 273.15)))
                self.setupPieChart1()
                self.i = self.i + 1
                airTempBool = false
                } else {
                    airTempBool = true
                }
            }
        }
        
        if characteristic.uuid == flowerPowerLightLevel {
            let characteristicData = characteristic.value
            let byteArray:[UInt8] = [UInt8](characteristicData!)
            let u8 = UnsafePointer(byteArray).withMemoryRebound(to: UInt16.self, capacity: 2) {
                $0.pointee
            }
            if(generalStopButton == false){
                if(soilVWCBool == true) {
                self.entriesForSoilVWC.append(ChartDataEntry(x: self.i, y: Double(u8)))
                self.setupPieChart2()
                self.i = self.i + 1
                soilVWCBool = false
                } else {
                    soilVWCBool = true
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(String(describing: error))")
            return
        }
        print("Value has been modified for:  \(characteristic)")
        peripheral.readValue(for: characteristic)
    }
    
    private func writeRxValue(from characteristic: CBCharacteristic, peripherial:CBPeripheral, number: UInt8) {
        let array : [UInt8] = [number]
        let data = NSData(bytes: array, length: 1)
        peripherial.writeValue(data as Data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
        
    }
    
}
