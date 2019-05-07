//
//  BluetoothView.swift
//  GrowApp
//
//  THIS CLASS TAKES CARE OF THE SCENE DISPLAYING LIVE DATA
//
//  Created by Andrei on 07/01/2019.
//  Copyright © 2019 Andrei. All rights reserved.
//

import UIKit
import CoreBluetooth
import Charts

class BluetoothView:UIViewController {
    
    var lineChartView = LineChartView()
    var lineChartView2 = LineChartView()
    
    let flowerPowerCBUUID = CBUUID(string: "39e1FA00-84a8-11e2-afba-0002a5d5c51b") //flowerPower bluetooth identifier
    
    let flowerPowerBatteryInfoCBUUID = CBUUID(string: "0x180F") // flower power battery info
    let flowerPowetBatterLevelCBUUID = CBUUID(string: "0x2A19") // flower power battery level
    
    let flowerPowerDeviceInformationCBUUID = CBUUID(string: "0x180A") // flower power device information
    
    let flowerPowerTimeCommunicationCBUUID = CBUUID(string: "39e1FD00-84a8-11e2-afba-0002a5d5c51b")// flower power LED
    let flowerPowerTimeCommuncationCurrentDevice = CBUUID(string: "39E1FD01-84A8-11E2-AFBA-0002A5D5C51B")
    
    let flowerPowerLiveServiceCBUUID = CBUUID(string: "39e1FA00-84a8-11e2-afba-0002a5d5c51b")//flower power Live Service
    let flowerPowerLightValue = CBUUID(string: "39E1FA01-84A8-11E2-AFBA-0002A5D5C51B")//flower power light value
    let flowerPowerAirTempCBUUID = CBUUID(string: "39E1FA02-84A8-11E2-AFBA-0002A5D5C51B")//flower power air temp
    let flowerPowerLastTimeMoveCBUUID = CBUUID(string: "39E1FA08-84A8-11E2-AFBA-0002A5D5C51B")//flower power last move
    let flowerPowerLEDCBUUID = CBUUID(string: "39E1FA07-84A8-11E2-AFBA-0002A5D5C51B")//flower power led
    let flowerPowerLiveMeasurePeriod = CBUUID(string: "39E1FA06-84A8-11E2-AFBA-0002A5D5C51B")//flower power live measure period
    
    let flowerPowerHistoryCBUUID = CBUUID(string: "39E1FC00-84A8-11E2-AFBA-0002A5D5C51B")//flower power history CBUUID
    let flowerPowerStartTransferIndexCBUUID = CBUUID(string: "39E1FC03-84A8-11E2-AFBA-0002A5D5C51B")//flower power nb entries
    
    let flowerPowerUploadServCBUUID = CBUUID(string: "39e1FB00-84a8-11e2-afba-0002a5d5c51b") //flower power upload CBUUID
    let flowerPowerUploadRxCBUUID = CBUUID(string: "39E1FB03-84A8-11E2-AFBA-0002A5D5C51B")//flower power RxBuffer CBUUID
    let flowerPowerUploadTxCBUUID = CBUUID(string: "39E1FB02-84A8-11E2-AFBA-0002A5D5C51B")//flower power TxBuffer CBUUID
    let flowerPowerUploadTxBuffer = CBUUID(string: "39E1FB01-84A8-11E2-AFBA-0002A5D5C51B")//flower power TxBuffer CBUUID
    
    
    var distance:CGFloat = 250
    
    var test = 0;
    var i = 0.0 // this is for the graph x value
    
    var testArray:[Data] = []
    
    var entries:[ChartDataEntry] = Array()
    
    var centralManager: CBCentralManager!
    var flowerPowerPeripherial: CBPeripheral!
    
    let infoButton = GAButton(frame: .zero, title: "Retrieve Data", textColor: .white, backgroundColor: .blue, radius: 12)
    let graphViewButton = GAButton(frame: .zero, title: "Go to graph view", textColor: .white, backgroundColor: .blue, radius: 12)
    let batteryLabel = GALabel(title: "Battery Level: ", frame: .zero, color: .white, size: 25, textAlignment: .center)
    let batteryLevelLabel = GALabel(title: "", frame: .zero, color: .white, size: 25, textAlignment: .left)
    let lightLabel = GALabel(title: "Light Level" , frame: .zero, color: .white, size: 25, textAlignment: .center)
    let lightLabelValue = GALabel(title: "" , frame: .zero, color: .white, size: 25, textAlignment: .left)
    let RSSILabel = GALabel(title: "Signal Strength:  ", frame: .zero, color: .white, size: 25, textAlignment: .center)
    let RSSILevelLabel = GALabel(title: " ", frame: .zero, color: .white, size: 25, textAlignment: .left)
    let lastTimeOpenLabel = GALabel(title: "Device been on since:  ", frame: .zero, color: .white, size: 25, textAlignment: .center)
    let lastTimeOpenDate = GALabel(title: "", frame: .zero, color: .white, size: 25, textAlignment: .left)
    let header = GAHeader(frame: .zero, title: "Device information available", color: .blue, radius: 12)
    let headerLabel = GALabel(title: "Device information available: ", frame: .zero, color: .white, size: 25, textAlignment: .center)

    var txCB: CBCharacteristic!
    var txBuffer: CBCharacteristic!
    var rxCB: CBCharacteristic!
    var peri: CBPeripheral!
    var testing = true
    
    @objc func infoButtonFuctionality() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.infoButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.infoButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (_) in
            self.centralManager = CBCentralManager(delegate: self, queue: nil)
            }
        }
    }
    
    @objc func graphButtonFunctionality() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.graphViewButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.graphViewButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (_) in
                self.present(GraphView(), animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView2.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(infoButton)
        infoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        infoButton.addTarget(self, action: #selector(infoButtonFuctionality), for: .touchUpInside)
        
        view.addSubview(graphViewButton)
        graphViewButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        graphViewButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        graphViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        graphViewButton.bottomAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: -120).isActive = true
        graphViewButton.addTarget(self, action: #selector(graphButtonFunctionality), for: .touchUpInside)
        
        self.view.addSubview(header)
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        header.heightAnchor.constraint(equalToConstant: 120).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        header.addSubview(headerLabel)
        headerLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        
        view.addSubview(batteryLabel)
        batteryLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: -100).isActive = true
        batteryLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: distance).isActive = true
        
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
        
        view.addSubview(batteryLevelLabel)
        batteryLevelLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 115).isActive = true
        batteryLevelLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: distance).isActive = true
        
        view.addSubview(RSSILabel)
        RSSILabel.centerXAnchor.constraint(equalTo: batteryLabel.centerXAnchor).isActive = true
        RSSILabel.topAnchor.constraint(equalTo: batteryLabel.topAnchor, constant: 40).isActive = true
        
        view.addSubview(RSSILevelLabel)
        RSSILevelLabel.centerXAnchor.constraint(equalTo: batteryLevelLabel.centerXAnchor).isActive = true
        RSSILevelLabel.topAnchor.constraint(equalTo: batteryLevelLabel.topAnchor, constant: 40).isActive = true
        
        view.addSubview(lastTimeOpenLabel)
        lastTimeOpenLabel.centerXAnchor.constraint(equalTo: RSSILabel.centerXAnchor).isActive = true
        lastTimeOpenLabel.topAnchor.constraint(equalTo: RSSILabel.topAnchor, constant: 40).isActive = true
        
        view.addSubview(lastTimeOpenDate)
        lastTimeOpenDate.centerXAnchor.constraint(equalTo: RSSILevelLabel.centerXAnchor, constant: 40).isActive = true
        lastTimeOpenDate.topAnchor.constraint(equalTo: RSSILevelLabel.topAnchor, constant: 40).isActive = true
        
        view.addSubview(lightLabel)
        lightLabel.centerXAnchor.constraint(equalTo: lastTimeOpenLabel.centerXAnchor).isActive = true
        lightLabel.topAnchor.constraint(equalTo: lastTimeOpenLabel.topAnchor, constant: 40).isActive = true
        
        view.addSubview(lightLabelValue)
        lightLabelValue.centerXAnchor.constraint(equalTo: lastTimeOpenDate.centerXAnchor, constant: 40).isActive = true
        lightLabelValue.topAnchor.constraint(equalTo: lastTimeOpenDate.topAnchor, constant: 40).isActive = true
        
    }
    

}

extension BluetoothView: CBCentralManagerDelegate, CBPeripheralDelegate {
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
           centralManager.scanForPeripherals(withServices: [flowerPowerCBUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true)])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        flowerPowerPeripherial = peripheral
        flowerPowerPeripherial.delegate = self
        centralManager.stopScan()
        centralManager.connect(flowerPowerPeripherial)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        flowerPowerPeripherial.discoverServices(nil)
        peripheral.readRSSI()
        peri = peripheral
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

//            case flowerPowerUploadTxBuffer:
//                peripheral.setNotifyValue(true, for: characteristic)
//                break
//
//            case flowerPowerUploadTxCBUUID:
//                peripheral.setNotifyValue(true, for: characteristic)
//                break
//
//            case flowerPowerUploadRxCBUUID:
//                rxCB = characteristic
//                peripheral.readValue(for: characteristic)
//                break
                
//                THE SECTION ABOVE IS THE SECTION THAT IS SUPPOSED TO START THE DONWLOAD PROCEDURE
//                I HAVE COMMENTED THE SECTION AS IT IS NOT FUNCTIONAL FOR THE TIME BEING
                
            case flowerPowerTimeCommuncationCurrentDevice:
                peripheral.readValue(for: characteristic)

            case flowerPowetBatterLevelCBUUID:
                peripheral.readValue(for: characteristic)
                
            case flowerPowerAirTempCBUUID:
                 peripheral.setNotifyValue(true, for: characteristic)
                 peripheral.readValue(for: characteristic)
                
            case flowerPowerLightValue:
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            
            case flowerPowerLEDCBUUID:
                peripheral.readValue(for: characteristic)
                break
            case flowerPowerLiveMeasurePeriod:
                 writeRxValue(from: characteristic, peripherial: peripheral, number: 0x01)

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

        if characteristic.uuid == flowerPowerUploadTxBuffer {
            let characteristicData = characteristic.value
            let byteArray:[UInt8] = [UInt8](characteristicData!)
            let u32 = UnsafePointer(byteArray).withMemoryRebound(to: UInt16.self, capacity: 2) {
                $0.pointee
            }
        }
        
        if characteristic.uuid == flowerPowerTimeCommuncationCurrentDevice {
            flowerPowerTimeCommunication(from: characteristic)
        }
        
        if characteristic.uuid == flowerPowerLightValue {
            let characteristicData = characteristic.value
            let byteArray:[UInt8] = [UInt8](characteristicData!)
            let u8 = UnsafePointer(byteArray).withMemoryRebound(to: UInt16.self, capacity: 2) {
                $0.pointee
            }
            
            lightLabelValue.text = String(u8)
            
        }
        
        if characteristic.uuid == flowerPowerUploadTxCBUUID {
            print("This is the value for TxCBUUID: ", returnValueUInt8(from: characteristic))
            if(returnValueUInt8(from: characteristic) == 2) {
                writeRxValue(from: rxCB, peripherial: peripheral, number: 0x02)
            }
        }
        
        if characteristic.uuid == flowerPowerLEDCBUUID {
            writeRxValue(from: characteristic, peripherial: peripheral, number: 0x01)
        }
        
        if characteristic.uuid == flowerPowetBatterLevelCBUUID {
            batteryLevelLabel.text = String(batteryService(from: characteristic))
        }
    
        if characteristic.uuid == flowerPowerUploadRxCBUUID {
            print("This is the value for Rx: ", characteristic)
            writeRxValue(from: rxCB, peripherial: peripheral, number: 0x01)

        }
        
        if characteristic.uuid == flowerPowerStartTransferIndexCBUUID {
            let characteristicData = characteristic.value
            let byteArray:[UInt8] = [UInt8](characteristicData!)
            let u32 = UnsafePointer(byteArray).withMemoryRebound(to: UInt32.self, capacity: 2) {
                $0.pointee
            }
            print("This is the value for transferIndex \(u32)")
        }
        
        if characteristic.uuid == flowerPowerTimeCommuncationCurrentDevice {
            flowerPowerTimeCommunication(from: characteristic)
        }
       
    }
    
    func returnValueUInt8(from characteristic: CBCharacteristic)->UInt8 {
        let characteristicData = characteristic.value
        let byteArray:[UInt8] = [UInt8](characteristicData!)
        let u8 = UnsafePointer(byteArray).withMemoryRebound(to: UInt8.self, capacity: 2) {
            $0.pointee
        }
        return u8
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(String(describing: error))")
            return
        }
        print("Value has been modified for:  \(characteristic)")
    }
    
    private func modifyTransferIndex(from characteristic: CBCharacteristic, peripherial:CBPeripheral) {
        let array : [UInt8] = [0x01, 0, 0, 0]
        let data = NSData(bytes: array, length: 4)
        
        peripherial.writeValue(data as Data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    private func retreiveAirTemp(from characteristic: CBCharacteristic) {
        let characteristicData = characteristic.value
        
        let byteArray:[UInt8] = [UInt8](characteristicData!)
        let bigEndianValue = byteArray.withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: Float32.self, capacity: 4) { $0 })
            }.pointee
    }
    
    private func writeRxValue(from characteristic: CBCharacteristic, peripherial:CBPeripheral, number: UInt8) {
        let array : [UInt8] = [number]
        let data = NSData(bytes: array, length: 1)
        peripherial.writeValue(data as Data, for: characteristic, type: CBCharacteristicWriteType.withResponse)
        
    }
    
    private func currSes(from characteristic: CBCharacteristic) {
        let characteristicData = characteristic.value
        
        let byteArray:[UInt8] = [UInt8](characteristicData!)
        let bigEndianValue = byteArray.withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: UInt8.self, capacity: 2) { $0 })
            }.pointee
        
        let u16 = UnsafePointer(byteArray).withMemoryRebound(to: UInt8.self, capacity: 2) {
            $0.pointee
        }
    }
    
    private func flowerPowerTimeCommunication(from characteristic: CBCharacteristic) {
        let characteristicData = characteristic.value
        
        let byteArray:[UInt8] = [UInt8](characteristicData!)
        

        let u32 = UnsafePointer(byteArray).withMemoryRebound(to: UInt32.self, capacity: 4) {
            $0.pointee
        }

        let lastTimeOpen = UInt32(NSDate().timeIntervalSince1970) - u32

        let todayDate = Date(timeIntervalSince1970: TimeInterval(lastTimeOpen))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy/HH:mm"//Specify your format that you want
        let strDate = dateFormatter.string(from: todayDate)

        lastTimeOpenDate.text = strDate
    }

    private func batteryService(from characteristic: CBCharacteristic) -> Int {
        
        guard let characteristicData = characteristic.value,
            let byte = characteristicData.first else { return -1 }
        return Int(byte)
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        RSSILevelLabel.text = RSSI.stringValue
        peripheral.readRSSI()
    }
    
}
