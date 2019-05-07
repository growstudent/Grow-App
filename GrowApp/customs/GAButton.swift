//
//  GAButton.swift
//  GrowApp
//
// THIS CLASS IS FOR CREATING CUSTOM BUTTONS
//
//  Created by Andrei on 07/01/2019.
//  Copyright © 2019 Andrei. All rights reserved.
//

import UIKit

class GAButton:UIButton {
    init(frame:CGRect =  .zero, title:String = "Default text", textColor:UIColor = .black, backgroundColor: UIColor = .white, radius:CGFloat = 22) {
        super.init(frame: frame)
        
        if frame == .zero { self.translatesAutoresizingMaskIntoConstraints = false }
        
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(textColor, for: .normal)
        self.layer.cornerRadius = radius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
