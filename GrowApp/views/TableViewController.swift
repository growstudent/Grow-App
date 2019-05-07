//
//  TableViewController.swift
//  GrowApp
//
//  THIS CLASS 
//
//  Created by Andrei on 16/01/2019.
//  Copyright © 2019 Andrei. All rights reserved.
//

import UIKit

import CoreBluetooth


class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let flowerPowerCBUUID = CBUUID(string: "39e1FA00-84a8-11e2-afba-0002a5d5c51b") //flowerPower bluetooth identifier
    
    private var myArray: [String] = []
    var myTableView: UITableView!
    var bluetoothDevice: String!
    var timeSince1970 = 0
    private let connectButton = GAButton(frame: .zero, title: "Scan for devices", textColor: .white, backgroundColor: .blue, radius: 12)
    let headerLabel = GALabel(title: "Devices found: ", frame: .zero, color: .white, size: 25, textAlignment: .center)
    var checkSearch:Bool = true
    
    var flowerPowerPeripherial: CBPeripheral!
    var centralManager: CBCentralManager!
    
    @objc func connectButtonFunction() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.connectButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.connectButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (_) in
                self.centralManager = CBCentralManager(delegate: self, queue: nil)
                self.updateHeader()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        timeSince1970 = Int(NSDate().timeIntervalSince1970)
        let header = GAHeader(frame: .zero, title: "Available devices", color: .blue, radius: 12)
        
        view.backgroundColor = .black
        
        myTableView = GATableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.backgroundColor = .black
        myTableView.layer.cornerRadius = 25
        
        connectButton.addTarget(self, action: #selector(connectButtonFunction), for: .touchUpInside)
        
        self.view.addSubview(header)
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        header.heightAnchor.constraint(equalToConstant: 120).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        self.view.addSubview(myTableView)
        myTableView.topAnchor.constraint(equalTo: header.topAnchor, constant: 150).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160).isActive = true
        myTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        myTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        self.view.addSubview(connectButton)
        connectButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        connectButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        
        header.addSubview(headerLabel)
        headerLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        
    }
    
    func updateHeader() {
        headerLabel.text = "Devices found: \(myArray.count)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.present(BluetoothView(), animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
    
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width-52, height: 30))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        cell.textLabel!.text = "\(indexPath.row + 1). \(myArray[indexPath.row])"
        
        cell.contentView.backgroundColor = .black
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
}

extension TableViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
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
        centralManager.stopScan()
        centralManager.connect(flowerPowerPeripherial)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        myArray.append(peripheral.name ?? "No Device Name")
        let indexPath = IndexPath(row: self.myArray.count-1, section: 0)
        
        self.myTableView.beginUpdates()
        self.myTableView.insertRows(at: [indexPath], with: .automatic)
        self.myTableView.endUpdates()
    }
    
}
