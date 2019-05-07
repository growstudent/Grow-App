//
//  ViewController.swift
//  GrowApp
//
//  THIS CLASS TAKES CARE OF THE MAIN SCENE OF THE APPLICATION 
//
//  Created by Andrei on 06/01/2019.
//  Copyright © 2019 Andrei. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {
    let titleLabel = GALabel(title: "Grow App PRE-ALPHA VERSION", frame: .zero, color: .black, size: 25, textAlignment: .center)
    let startButton = GAButton(frame: .zero, title: "Enter!", textColor: .black, backgroundColor: .white, radius: 30)
    
    let bg:UIView = {
       let view = UIView()
       view.backgroundColor = .cyan
       view.layer.cornerRadius = 25
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    @objc func connectButton() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.startButton.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.startButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (_) in
                self.present(TableViewController(), animated: true, completion: nil)
//                self.present(GraphView(), animated: true, completion: nil)

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.numberOfLines = 3
        
        startButton.addTarget(self, action: #selector(connectButton), for: .touchUpInside)
        
        view.backgroundColor = .black
        
        view.addSubview(bg)
        bg.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        bg.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        bg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        bg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        bg.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: bg.topAnchor, constant: 120).isActive = true
        
        bg.addSubview(startButton)
        startButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        startButton.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        startButton.bottomAnchor.constraint(equalTo: bg.bottomAnchor, constant: -120).isActive = true
    }
}


